########################################################################################################################
#!!
#! @description: This flow will stop and delete a LXC container
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: Name of the PVE node that hosts this container
#! @input vmid: The vmid of the container
#!
#! @output result: The rusult of the request
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.lxc
flow:
  name: delete_lxc
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - node
    - vmid
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
          - SUCCESS: stop_container
    - delete_lxc:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc/'+vmid}"
            - auth_type: basic
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - result: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - stop_container:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc/'+vmid+'/status/stop'}"
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
            io.cloudslang.proxmox.pve.nodes.tasks.get_task_status:
              - node: '${node}'
              - upid: '${JobStatus}'
              - pveURL: '${pveURL}'
              - pveUsername: '${pveUsername}'
              - pvePassword: '${pvePassword}'
              - TrustAllRoots: '${TrustAllRoots}'
              - HostnameVerify: '${HostnameVerify}'
          break:
            - FAILURE
          publish:
            - TaskStatus
            - ExitStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_task_finished
    - is_task_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${TaskStatus}'
            - second_string: stopped
            - ignore_case: 'true'
        navigate:
          - SUCCESS: is_exitstatus_ok
          - FAILURE: sleep
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - is_exitstatus_ok:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ExitStatus}'
            - second_string: ok
            - ignore_case: 'true'
        navigate:
          - SUCCESS: delete_lxc
          - FAILURE: on_failure
  outputs:
    - result: '${result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_ticket:
        x: 55
        'y': 81
      delete_lxc:
        x: 440
        'y': 78
        navigate:
          30bf57e3-e544-0b2d-e58b-9b9211b6b081:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
      stop_container:
        x: 59
        'y': 255
      get_status_id:
        x: 62
        'y': 416
      get_task_status:
        x: 239
        'y': 410
      is_task_finished:
        x: 233
        'y': 241
      sleep:
        x: 445
        'y': 236
      is_exitstatus_ok:
        x: 231
        'y': 84
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 608
          'y': 81
