########################################################################################################################
#!!
#! @description: Generate a ticket (cookie) for all additional PVE API calls
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.access
flow:
  name: get_ticket
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
  workflow:
    - get_pve_tokens:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get('pveURL')+'/api2/json/access/ticket'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - body: "${'username='+pveUsername+'&password='+pvePassword}"
            - content_type: ' '
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_ticket
          - FAILURE: on_failure
    - get_ticket:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.ticket
        publish:
          - pveTicket: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: get_token
          - FAILURE: on_failure
    - get_token:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.CSRFPreventionToken
        publish:
          - pveToken: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pveTicket: '${pveTicket}'
    - pveToken: '${pveToken}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_pve_tokens:
        x: 95
        'y': 121.5
      get_ticket:
        x: 292
        'y': 123
      get_token:
        x: 326
        'y': 315
        navigate:
          1baa2e64-d851-c02e-3f99-f132209db57a:
            targetId: c2769967-dad0-7dfa-46e9-d32658447dd5
            port: SUCCESS
    results:
      SUCCESS:
        c2769967-dad0-7dfa-46e9-d32658447dd5:
          x: 490
          'y': 132
