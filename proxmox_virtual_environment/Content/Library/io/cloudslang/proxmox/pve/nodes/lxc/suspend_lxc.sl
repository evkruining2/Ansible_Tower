########################################################################################################################
#!!
#! @description: This flow will suspend a LXC container. Note: current PVE versions do not support this feature yet. Expect it to be available in future PVE releases.
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
  name: suspend_lxc
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
          - SUCCESS: get_container_status
    - get_container_status:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/lxc/'+vmid+'/status/current'}"
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
            - json_path: $.data.status
        publish:
          - lxc_status: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: is_lxc_running
          - FAILURE: on_failure
    - is_lxc_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${lxc_status}'
            - second_string: running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: start_container
          - FAILURE: FAILURE
    - start_container:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc/'+vmid+'/status/suspend'}"
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
    - result: '${json_result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_ticket:
        x: 99
        'y': 92
      get_container_status:
        x: 107
        'y': 251
      json_path_query:
        x: 97
        'y': 443
      is_lxc_running:
        x: 313
        'y': 445
        navigate:
          e5271e5d-167a-c44b-56c5-99c7283183a2:
            targetId: 4ea4c2a6-b83f-fc96-e7ae-c14b6ca83334
            port: FAILURE
      start_container:
        x: 303
        'y': 259
        navigate:
          17c6a390-d979-c118-de67-70669870a970:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 553
          'y': 255
      FAILURE:
        4ea4c2a6-b83f-fc96-e7ae-c14b6ca83334:
          x: 558
          'y': 441
