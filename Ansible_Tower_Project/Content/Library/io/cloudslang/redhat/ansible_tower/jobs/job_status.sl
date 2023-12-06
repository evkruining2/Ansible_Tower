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
#!
#! @output JobStatus: The status of the job. Possible values: Pending, Running, Failed, Successful
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.jobs
flow:
  name: job_status
  inputs:
    - AnsibleTowerURL: "${get_sp('io.cloudslang.redhat.ansible.ansible_url')}"
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.redhat.ansible.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.redhat.ansible.x509_hostname_verifier')}"
    - JobID
  workflow:
    - Get_information_for_JobID:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('AnsibleTowerURL')+'/jobs/'+JobID}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Extract_status_from_JSON
          - FAILURE: on_failure
    - Extract_status_from_JSON:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.status
        publish:
          - status: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_information_for_JobID:
        x: 63
        'y': 92
      Extract_status_from_JSON:
        x: 306
        'y': 97
        navigate:
          c9d9758d-6c23-0e02-3492-2e197e1854e9:
            targetId: 8ebb9e4e-6057-7dd1-a67a-a81f4a40147f
            port: SUCCESS
    results:
      SUCCESS:
        8ebb9e4e-6057-7dd1-a67a-a81f4a40147f:
          x: 538
          'y': 104
