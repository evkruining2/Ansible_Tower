########################################################################################################################
#!!
#! @description: Get a Puppet Enterprise Authentication Token. This token is used for all Puppet Enterprise operations
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!
#! @output pe_token: The Puppet Enterprise authentication token
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.rbac
flow:
  name: get_auth_token
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${PuppetEnterpriseURL+':4433/rbac-api/v1/auth/token'}"
            - username: '${PuppetUsername}'
            - password:
                value: '${PuppetPassword}'
                sensitive: true
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"login\": \"'+PuppetUsername+'\",'+\\\n'   \"password\": \"'+PuppetPassword+'\",'+\\\n'   \"lifetime\": \"1h\",'+\\\n'   \"label\": \"One hour token for integration use\"'+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.token
        publish:
          - pe_token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pe_token: '${pe_token}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_post:
        x: 89
        'y': 91
      json_path_query:
        x: 259
        'y': 91
        navigate:
          1b3c2c15-0e98-aeeb-5705-57a450327709:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 429
          'y': 93
