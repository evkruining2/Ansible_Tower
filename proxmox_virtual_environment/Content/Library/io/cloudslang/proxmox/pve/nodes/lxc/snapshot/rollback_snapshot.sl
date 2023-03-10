########################################################################################################################
#!!
#! @description: Rollback a lxc container to a specified snapshot
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: Name of the PVE node that is hosting the lxc container to snapshot. Example: pve-node2
#! @input vmid: The vmid of the LXC container that needs a snapshot rollback
#! @input snapname: The name of the snapshot to rollback (string)
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.lxc.snapshot
flow:
  name: rollback_snapshot
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - node
    - vmid
    - snapname
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
          - SUCCESS: rollback_snapshot
    - rollback_snapshot:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc/'+vmid+'/snapshot/'+snapname+'/rollback'}"
            - auth_type: basic
            - username: '${pveUsername}'
            - password:
                value: '${pvePassword}'
                sensitive: true
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - body: null
            - content_type: application/x-www-form-urlencoded
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_status_id
          - FAILURE: on_failure
    - get_status_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data
        publish:
          - JobStatus: "${return_result.strip('[').strip(']').strip('\"')}"
          - loops: '10'
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
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_task_status:
        x: 285
        'y': 412
      get_exit_status:
        x: 574
        'y': 74
      get_ticket:
        x: 77
        'y': 63
      is_exitstatus_ok:
        x: 578
        'y': 234
        navigate:
          251dabe6-a9e8-d78d-c5d2-e9949df048bf:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
      sleep:
        x: 441
        'y': 230
      is_task_finished:
        x: 280
        'y': 73
      get_status:
        x: 283
        'y': 234
      rollback_snapshot:
        x: 79
        'y': 223
      get_status_id:
        x: 83
        'y': 410
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 577
          'y': 419
