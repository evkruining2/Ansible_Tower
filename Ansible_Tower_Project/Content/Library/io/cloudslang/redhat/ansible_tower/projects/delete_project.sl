########################################################################################################################
#!!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input ProjectID: The id (integer) of the Project to delete
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.projects
flow:
  name: delete_project
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
    - ProjectID
  workflow:
    - Delete_Project:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get_sp('AnsibleTowerURL')+'/projects/'+ProjectID+'/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Delete_Project:
        x: 85
        'y': 79
        navigate:
          74804904-02f4-ef09-6abe-63c4c06d0e39:
            targetId: 981d4b12-5e7d-e856-ca53-3eb4619daa0e
            port: SUCCESS
    results:
      SUCCESS:
        981d4b12-5e7d-e856-ca53-3eb4619daa0e:
          x: 339
          'y': 77