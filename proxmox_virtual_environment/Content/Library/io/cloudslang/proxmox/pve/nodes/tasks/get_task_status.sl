########################################################################################################################
#!!
#! @description: Get the status of a current or previous task
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: The name of the PVE node that is hosting the VM. Example: pve_node2
#! @input upid: Task ID. Example: UPID:pve2:00003E60:081A0663:5EFD2E04:aptupdate::root@pam:
#!
#! @output TaskStatus: Status of a task
#! @output ExitStatus: Exitstatus of a taks
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.tasks
flow:
  name: get_task_status
  inputs:
    - pveURL
    - pveUsername
    - pvePassword
    - TrustAllRoots: "${get_sp('io.cloudslang.proxmox.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.proxmox.x_509_hostname_verifier')}"
    - node
    - upid
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
          - SUCCESS: get_task_status
    - get_task_status:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/tasks/'+upid+'/status'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
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
          - SUCCESS: get_exit_status
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
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS
  outputs:
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ticket:
        x: 86
        'y': 81
      get_task_status:
        x: 272
        'y': 84
      get_status:
        x: 447
        'y': 86
      get_exit_status:
        x: 605
        'y': 86
        navigate:
          bdae6068-83a1-1e42-01a6-2c738c10cae6:
            targetId: 06d8a696-d00b-cd7e-0f3f-c5fd72fb3707
            port: SUCCESS
          26a1164e-d7c6-81f2-0670-eadea35f9388:
            targetId: 06d8a696-d00b-cd7e-0f3f-c5fd72fb3707
            port: FAILURE
    results:
      SUCCESS:
        06d8a696-d00b-cd7e-0f3f-c5fd72fb3707:
          x: 753
          'y': 239
