########################################################################################################################
#!!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input HostName: FQDN or ip address if the host to add (string)
#! @input InventoryID: ID of the inventory to add the host to (integer)
#! @input HostDescription: Description of the host (optional)
#! @input TemplateID: ID of the Job Template to execute (integer)
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.ansible
flow:
  name: update_os_on_target_server
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots
    - HostnameVerify
    - HostName
    - InventoryID: '4'
    - HostDescription: New web server
    - TemplateID: '23'
  workflow:
    - create_host:
        do:
          io.cloudslang.redhat.ansible_tower.hosts.create_host:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword:
                value: '${AnsiblePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - HostName: '${HostName}'
            - Inventory: '${InventoryID}'
            - HostDescription: '${HostDescription}'
        publish:
          - HostID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: sleep
    - run_job_with_template:
        do:
          io.cloudslang.redhat.ansible_tower.jobs.run_job_with_template:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword:
                value: '${AnsiblePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - TemplateID: '${TemplateID}'
        publish:
          - JobID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: wait_for_final_job_result
    - wait_for_final_job_result:
        do:
          io.cloudslang.redhat.ansible_tower.jobs.wait_for_final_job_result:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword:
                value: '${AnsiblePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - JobID: '${JobID}'
            - Loops: '50'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: run_job_with_template_1
          - FAILURE: on_failure
    - run_job_with_template_1:
        do:
          io.cloudslang.redhat.ansible_tower.jobs.run_job_with_template:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword:
                value: '${AnsiblePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - TemplateID: '20'
        publish:
          - JobID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: wait_for_final_job_result_1
    - wait_for_final_job_result_1:
        do:
          io.cloudslang.redhat.ansible_tower.jobs.wait_for_final_job_result:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword:
                value: '${AnsiblePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - JobID: '${JobID}'
            - Loops: '50'
        navigate:
          - FAILURE: run_job_with_template
          - SUCCESS: run_job_with_template
  outputs:
    - HostID: '${HostID}'
    - JobID: '${JobID}'
    - JobStatus: '${JobStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_host:
        x: 80
        'y': 80
      run_job_with_template:
        x: 600
        'y': 360
      wait_for_final_job_result:
        x: 400
        'y': 360
        navigate:
          9c9917c7-2308-a6b0-9239-75537117ac13:
            targetId: d4d2fe47-4d5c-9a50-c765-3864ac848d71
            port: SUCCESS
      sleep:
        x: 280
        'y': 80
      run_job_with_template_1:
        x: 440
        'y': 80
      wait_for_final_job_result_1:
        x: 600
        'y': 120
    results:
      SUCCESS:
        d4d2fe47-4d5c-9a50-c765-3864ac848d71:
          x: 400
          'y': 600
