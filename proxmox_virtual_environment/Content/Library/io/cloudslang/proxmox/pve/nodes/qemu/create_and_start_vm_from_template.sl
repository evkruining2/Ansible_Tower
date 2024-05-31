########################################################################################################################
#!!
#! @description: Create a new VM by cloning an existing VM or Template. Once successfully created the new VM, it wil be powered on.
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: Name of the PVE node that will host this new vm
#! @input cloneid: The vmid of the source vm/template to clone
#! @input storage: Target storage where the new vm will deployed. Example: local-lvm. If left empty, the new vm will be deployed on the same storage as the source template/vm
#! @input name: The name of the new vm
#! @input pool: Add the new vm to the specified pool
#! @input target: Target node. Only allowed if the original vm/template is on shared storage
#! @input full: [boolean: 0=false, 1=true] Create a full copy of all disks. This is always done when you clone a normal vm. For templates, we try to create a linked clone by default.
#!
#! @output JobStatus: Status of the PBE cloning job
#! @output TaskStatus: Task status of the VM creation ("stopped" means the task has finished)
#! @output ExitStatus: Exit status of the task ("OK" means success)
#! @output vmid: The VMID of the newly created vm
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.qemu
flow:
  name: create_and_start_vm_from_template
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.proxmox.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.proxmox.x_509_hostname_verifier')}"
    - node
    - cloneid
    - storage:
        required: false
    - name:
        default: arie
        required: false
    - pool:
        required: false
    - target:
        required: false
    - full:
        required: false
  workflow:
    - get_ticket:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
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
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
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
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
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
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
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
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
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
    - create_vm_from_template:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
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
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
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
          - SUCCESS: create_vm_from_template
    - get_status_id:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
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
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
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
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
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
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${TaskStatus}'
            - second_string: stopped
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_exit_status
          - FAILURE: sleep
    - sleep:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - get_exit_status:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
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
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ExitStatus}'
            - second_string: ok
            - ignore_case: 'true'
        navigate:
          - SUCCESS: start_vm
          - FAILURE: on_failure
    - start_vm:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/qemu/'+vmid+'/status/start'}"
            - auth_type: basic
            - username: '${pveUsername}'
            - password:
                value: '${pvePassword}'
                sensitive: true
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - json_result: '${return_result}'
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
      create_body:
        x: 240
        'y': 240
      json_path_query:
        x: 87
        'y': 539
      create_vm_from_template:
        x: 244
        'y': 72
      get_exit_status:
        x: 628
        'y': 545
      start_vm:
        x: 800
        'y': 360
        navigate:
          58e42e22-42e8-d4d0-15b3-0b22fd14cb78:
            targetId: f1d69487-d72c-7b03-00dc-8170e90d7482
            port: SUCCESS
      get_ticket:
        x: 80
        'y': 80
      is_exitstatus_ok:
        x: 803
        'y': 539
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
        'y': 360
      contains:
        x: 251
        'y': 543
      get_status_id:
        x: 434
        'y': 69
    results:
      SUCCESS:
        f1d69487-d72c-7b03-00dc-8170e90d7482:
          x: 795
          'y': 191
