########################################################################################################################
#!!
#! @description: Check the Job status, based on the job id.
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input JobID: The id (integer) of the job you want the check the status for
#!!#
########################################################################################################################

namespace: io.cloudslang.redhat.ansible_tower.jobs
flow:
  name: remove_job
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
    - JobID
  workflow:
    - http_client_delete:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get('AnsibleTowerURL')+'/jobs/'+JobID+'/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_delete:
        x: 148
        'y': 150
        navigate:
          6e46e9d9-9477-15a1-8868-d738d214edfb:
            targetId: f0c9c7ae-abde-909c-a748-c6be20c3d84b
            port: SUCCESS
    results:
      SUCCESS:
        f0c9c7ae-abde-909c-a748-c6be20c3d84b:
          x: 353
          'y': 147
