########################################################################################################################
#!!
#! @description: Check the current status of a VM (running, stopped, paused, suspended)
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: The name of the PVE node that is hosting the VM. Example: pve_node2
#! @input vmid: The ID of the VM to run this operation against. Example: 102
#! @output vmStatus: The current status of a VM (running, stopped, paused, suspended)
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.qemu
flow:
  name: current_vm_status
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
        do:
          io.cloudslang.proxmox.pve.access.get_ticket:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword: '${pvePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pveTicket
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_version
    - get_version:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/qemu/'+vmid+'/status/current'}"
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
          - SUCCESS: json_path_query_1
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.status
        publish:
          - vmStatus: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - vmStatus: '${vmStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ticket:
        x: 45
        'y': 87
      get_version:
        x: 231
        'y': 82
      json_path_query_1:
        x: 426
        'y': 81
        navigate:
          62053a2d-7bd6-80f4-b941-89b039fe5718:
            targetId: 62d58777-7508-fc70-1b42-21d01def9eff
            port: SUCCESS
    results:
      SUCCESS:
        62d58777-7508-fc70-1b42-21d01def9eff:
          x: 593
          'y': 96
