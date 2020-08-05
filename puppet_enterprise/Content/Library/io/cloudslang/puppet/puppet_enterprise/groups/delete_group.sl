########################################################################################################################
#!!
#! @description: Delete a group in Puppet Enterprise
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input group_id: ID of the Puppet Enterprise group to delete
#!
#! @output status_code: Status code (204 is success)
#! @output return_code: Return code (0 is success)
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.groups
flow:
  name: delete_group
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - group_id
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
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':4433/classifier-api/v1/groups/'+group_id}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - content_type: application/json
            - method: delete
        publish:
          - status_code
          - return_code
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - status_code: '${status_code}'
    - return_code: '${return_code}'
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
      http_client_action:
        x: 225
        'y': 109
        navigate:
          8c0b3246-d754-7e15-447a-69fc74bfa9a2:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 427
          'y': 109
