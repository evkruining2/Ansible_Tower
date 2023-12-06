########################################################################################################################
#!!
#! @description: This flow will create a new host, inventory and job template in Ansible Tower. It will then run the new job template against the new inventory, containing the new host.
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input OrgID: Organization ID (Integer)
#! @input InventoryName: Name of the new inventory to create (string)
#! @input HostName: FQDN or ip address if the host to add (string)
#! @input HostDescription: Description of the host (optional)
#! @input CredentialID: Enter the Id of the credentials store (integer)
#! @input ProjectID: Enter the project ID number (integer)
#! @input TemplateName: Enter the name of the job template to create (string)
#! @input Playbook: Enter the name of the playbook to run (string)
#! @input ExtraVars: (optional) Enter extra vars (example: tipo: /ansible/prodotti/F_Tomcat-9)
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.samples
flow:
  name: add_host_and_run_playbook
  inputs:
    - AnsibleTowerURL: "${get_sp('io.cloudslang.redhat.ansible.ansible_url')}"
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.redhat.ansible.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.redhat.ansible.x509_hostname_verifier')}"
    - OrgID
    - InventoryName
    - HostName
    - HostDescription:
        default: ' '
        required: false
    - CredentialID
    - ProjectID
    - TemplateName
    - Playbook
    - ExtraVars:
        default: ' '
        required: false
  workflow:
    - Create_Inventory:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.redhat.ansible_tower.inventories.create_inventory:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - InventoryName: '${InventoryName}'
            - OrgID: '${OrgID}'
        publish:
          - InventoryID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Create_Job_Template
    - Create_Job_Template:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.redhat.ansible_tower.job_templates.create_job_template:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - TemplateName: '${TemplateName}'
            - ProjectID: '${ProjectID}'
            - Playbook: '${Playbook}'
            - InventoryID: '${InventoryID}'
            - ExtraVars: '${ExtraVars}'
        publish:
          - TemplateID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Attach_Credentials_to_Job_Template
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
    - Attach_Credentials_to_Job_Template:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.redhat.ansible_tower.job_templates.attach_credentials_to_job_template:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - TemplateID: '${TemplateID}'
            - CredentialID: '${CredentialID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Create_Host
  outputs:
    - InventoryID: '${InventoryID}'
    - JobID: '${JobID}'
    - JobStatus: '${JobStatus}'
    - TemplateID: '${TemplateID}'
    - HostID: '${HostID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_Inventory:
        x: 68
        'y': 84
      Create_Job_Template:
        x: 63
        'y': 262
      Create_Host:
        x: 294
        'y': 430
      Run_Job_with_Template:
        x: 293
        'y': 254
      Wait_for_final_job_result:
        x: 286
        'y': 79
        navigate:
          3afaf73f-f441-bbb7-e330-3f9e759cc487:
            targetId: 9f7dee26-ad4b-d780-a29f-682178d06d70
            port: SUCCESS
      Attach_Credentials_to_Job_Template:
        x: 59
        'y': 432
    results:
      SUCCESS:
        9f7dee26-ad4b-d780-a29f-682178d06d70:
          x: 486
          'y': 81
