########################################################################################################################
#!!
#! @description: Get a userid (sid) based on a Puppet Enterprise login name
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input login: A users login name. Example: peuser1
#!
#! @output user_id: List of Puppet Enterprise users
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.rbac
flow:
  name: get_userid
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - login
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
          - SUCCESS: get_users
          - FAILURE: on_failure
    - filter_login:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: "${'$.[?(@.login==\"'+login+'\")]'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: get_userid
          - FAILURE: on_failure
    - get_users:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${PuppetEnterpriseURL+':4433/rbac-api/v1/users'}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: filter_login
          - FAILURE: on_failure
    - get_userid:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $..id
        publish:
          - user_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - user_id: '${user_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token:
        x: 61
        'y': 96
      get_users:
        x: 228
        'y': 99
      filter_login:
        x: 396
        'y': 95
      get_userid:
        x: 493
        'y': 264
        navigate:
          36c76d87-21c4-9f4f-918b-1741a29216d3:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 552
          'y': 97
