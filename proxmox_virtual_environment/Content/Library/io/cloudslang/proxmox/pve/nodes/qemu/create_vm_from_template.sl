########################################################################################################################
#!!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input node: Name of the PVE node that will host this new vm
#! @input cloneid: The vmid of the source vm/template to clone
#! @input storage: Target storage where the new vm will deployed. Example: local-lvm. If left empty, the new vm will be deployed on the same storage as the source template/vm
#! @input name: The name of the new vm
#! @input pool: Add the new vm to the specified pool
#! @input target: Target node. Only allowed if the original vm/template is on shared storage
#! @input full: [boolean: 0=false, 1=true] Create a full copy of all disks. This is always done when you clone a normal vm. For templates, we try to create a linked clone by default.
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.qemu
flow:
  name: create_vm_from_template
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots
    - HostnameVerify
    - node
    - cloneid
    - storage:
        required: false
    - name:
        required: false
    - pool:
        required: false
    - target:
        required: false
    - full:
        required: false
  workflow:
    - get_ticket:
        do:
          io.cloudslang.proxmox.pve.access.get_ticket:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pveTicket
          - pveToken
        navigate:
          - FAILURE: on_failure
          - SUCCESS: random_number_generator
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '100'
            - max: '9999'
        publish:
          - vmid: '${random_number}'
        navigate:
          - SUCCESS: get_vmids
          - FAILURE: on_failure
    - get_vmids:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/cluster/resources'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: "${'Cookie:PVEAuthCookie='+pveTicket}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data..vmid
        publish:
          - vmids: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: contains
          - FAILURE: on_failure
    - contains:
        do:
          io.cloudslang.base.lists.contains:
            - container: '${vmids}'
            - sublist: '${vmid}'
            - delimiter: ','
            - ignore_case: 'true'
        publish:
          - response
        navigate:
          - SUCCESS: random_number_generator
          - FAILURE: create_body
    - create_lxc_from_template:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/qemu/'+cloneid+'/clone'}"
            - auth_type: basic
            - username: '${pveUsername}'
            - password:
                value: '${pvePassword}'
                sensitive: true
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - body: "${body+'&newid='+vmid}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_status_id
          - FAILURE: on_failure
    - create_body:
        do:
          io.cloudslang.proxmox.pve.tools.create_body:
            - param_full: '${full}'
            - param_name: '${name}'
            - param_pool: '${pool}'
            - param_storage: '${storage}'
            - param_target: '${target}'
        publish:
          - body: '${request}'
        navigate:
          - SUCCESS: create_lxc_from_template
    - get_status_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data
        publish:
          - JobStatus: "${return_result.strip('[').strip(']').strip('\"')}"
          - loops: '30'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - get_task_status:
        loop:
          for: i in loops
          do:
            io.cloudslang.base.http.http_client_get:
              - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/tasks/'+JobStatus+'/status'}"
              - auth_type: basic
              - username: "${get('pveUsername')}"
              - password:
                  value: "${get('pvePassword')}"
                  sensitive: true
              - trust_all_roots: "${get('TrustAllRoots')}"
              - x_509_hostname_verifier: "${get('HostnameVerify')}"
              - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
          break:
            - FAILURE
          publish:
            - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_status
          - FAILURE: on_failure
    - get_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.status
        publish:
          - TaskStatus: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: is_task_finished
          - FAILURE: on_failure
    - is_task_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${TaskStatus}'
            - second_string: stopped
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_exit_status
          - FAILURE: sleep
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - get_exit_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.exitstatus
        publish:
          - ExitStatus: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: is_exitstatus_ok
          - FAILURE: on_failure
    - is_exitstatus_ok:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ExitStatus}'
            - second_string: ok
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${JobStatus}'
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
    - vmid: '${vmid}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_task_status:
        x: 435
        'y': 221
      create_lxc_from_template:
        x: 244
        'y': 72
      create_body:
        x: 246
        'y': 225
      json_path_query:
        x: 87
        'y': 539
      get_exit_status:
        x: 628
        'y': 545
      get_ticket:
        x: 79
        'y': 71
      is_exitstatus_ok:
        x: 803
        'y': 539
        navigate:
          c9f1073f-a7e6-7875-fe30-c23fd9572cd2:
            targetId: f1d69487-d72c-7b03-00dc-8170e90d7482
            port: SUCCESS
      sleep:
        x: 625
        'y': 380
      is_task_finished:
        x: 439
        'y': 550
      get_vmids:
        x: 85
        'y': 384
      random_number_generator:
        x: 79
        'y': 225
      get_status:
        x: 440
        'y': 378
      contains:
        x: 251
        'y': 543
      get_status_id:
        x: 434
        'y': 69
    results:
      SUCCESS:
        f1d69487-d72c-7b03-00dc-8170e90d7482:
          x: 798
          'y': 373
