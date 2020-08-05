########################################################################################################################
#!!
#! @description: Delete a user in the Puppet Enterprise environment.
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input user_id: The UserID of the user to delete from Puppet Enterprise. Example: 7b449b2b-afff-4a13-b4e1-4ade8ad88ef1
#!
#! @output result: The ID for the new user
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.rbac
flow:
  name: delete_user
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - user_id
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
          - SUCCESS: delete_user
          - FAILURE: on_failure
    - delete_user:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${PuppetEnterpriseURL+':4433/rbac-api/v1/users/'+user_id}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result: '${json_output}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token:
        x: 53
        'y': 87
      delete_user:
        x: 234
        'y': 89
        navigate:
          ee84e4bd-8ad8-1d52-2985-a802072de519:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 433
          'y': 93
