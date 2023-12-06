########################################################################################################################
#!!
#! @description: This flow will create a new host, add it to an existing inventory in Ansible Tower. It will then run the given job template against the set inventory, containing the new host.
#!
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
namespace: io.cloudslang.redhat.ansible_tower.samples
flow:
  name: add_new_host_and_run_existing_job_template
  inputs:
    - AnsibleTowerURL: "${get_sp('io.cloudslang.redhat.ansible.ansible_url')}"
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.redhat.ansible.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.redhat.ansible.x509_hostname_verifier')}"
    - HostName: localhost
    - InventoryID: '36'
    - HostDescription:
        default: target server
        required: false
    - TemplateID: '78'
  workflow:
    - Create_Host:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.redhat.ansible_tower.hosts.create_host:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - HostName: '${HostName}'
            - Inventory: '${InventoryID}'
            - HostDescription: '${HostDescription}'
        publish:
          - HostID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Run_Job_with_Template
    - Run_Job_with_Template:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.redhat.ansible_tower.jobs.run_job_with_template:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - TemplateID: '${TemplateID}'
        publish:
          - JobID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Wait_for_final_job_result
    - Wait_for_final_job_result:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.redhat.ansible_tower.jobs.wait_for_final_job_result:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - JobID: '${JobID}'
        publish:
          - JobStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
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
      Create_Host:
        x: 72
        'y': 88
      Run_Job_with_Template:
        x: 269
        'y': 87
      Wait_for_final_job_result:
        x: 467
        'y': 95
        navigate:
          ac297ad7-24d4-bf59-2548-22be3485d19d:
            targetId: a242faa9-045a-0cf9-b29c-f13214ea7857
            port: SUCCESS
    results:
      SUCCESS:
        a242faa9-045a-0cf9-b29c-f13214ea7857:
          x: 470
          'y': 283
