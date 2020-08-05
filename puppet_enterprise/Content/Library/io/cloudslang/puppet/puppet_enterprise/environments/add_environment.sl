########################################################################################################################
#!!
#! @description: Create a new Environment in Puppet Enterprise
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input environment: Name of the new Puppet Enterprise environment to create
#!
#! @output return_result: Return result
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.environments
flow:
  name: add_environment
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - environment
  workflow:
    - get_auth_token:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.get_auth_token:
            - PuppetEnterpriseURL: '${PuppetEnterpriseURL}'
            - PuppetUsername: '${PuppetUsername}'
            - PuppetPassword: '${PuppetPassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pe_token
        navigate:
          - SUCCESS: http_client_action
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.*'
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':4433/classifier-api/v1/environments/'+environment}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - content_type: application/json
            - method: put
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token:
        x: 61
        'y': 96
      json_path_query:
        x: 396
        'y': 95
        navigate:
          1b3c2c15-0e98-aeeb-5705-57a450327709:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
      http_client_action:
        x: 225
        'y': 109
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 552
          'y': 97
