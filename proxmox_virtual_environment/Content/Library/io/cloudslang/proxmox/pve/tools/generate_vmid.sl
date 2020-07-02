########################################################################################################################
#!!
#! @description: Generate random vmid in the range of 100-9999 and check if the vmis is available in the PVE environment
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!
#! @output vmid: Randomly generated vmid in the range of 100-9999
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.tools
flow:
  name: generate_vmid
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
  workflow:
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '100'
            - max: '9999'
        publish:
          - vmid: '${random_number}'
        navigate:
          - SUCCESS: get_ticket
          - FAILURE: on_failure
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vmids
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
          - FAILURE: SUCCESS
  outputs:
    - vmid: '${vmid}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      random_number_generator:
        x: 83
        'y': 60
      get_ticket:
        x: 86
        'y': 223
      get_vmids:
        x: 93
        'y': 389
      json_path_query:
        x: 294
        'y': 390
      contains:
        x: 289
        'y': 223
        navigate:
          66c7d103-530c-fac1-2462-d37e9f37a480:
            targetId: 6d950a26-7042-1840-de0f-af3fcef22a6c
            port: FAILURE
    results:
      SUCCESS:
        6d950a26-7042-1840-de0f-af3fcef22a6c:
          x: 287
          'y': 54
