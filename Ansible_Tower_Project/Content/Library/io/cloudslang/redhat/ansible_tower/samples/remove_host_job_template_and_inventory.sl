########################################################################################################################
#!!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input JobID: Id (integer) of the Job to delete
#! @input InventoryID: Id (integer) of the Inventory to delete
#! @input TemplateID: Id (integer) of the Job Template to delete
#! @input HostID: Id (integer) of the Host to delete
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.samples
flow:
  name: remove_host_job_template_and_inventory
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
    - JobID
    - InventoryID
    - TemplateID
    - HostID
  workflow:
    - Delete_Host:
        do:
          io.cloudslang.redhat.ansible_tower.hosts.delete_host:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - HostID: '${HostID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Delete_Job_Template
    - Delete_Job_Template:
        do:
          io.cloudslang.redhat.ansible_tower.job_templates.delete_job_template:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - TemplateID: '${TemplateID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Delete_Inventory
    - Delete_Inventory:
        do:
          io.cloudslang.redhat.ansible_tower.inventories.delete_inventory:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - InventoryID: '${InventoryID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Remove_Job
    - Remove_Job:
        do:
          io.cloudslang.redhat.ansible_tower.jobs.remove_job:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword: '${AnsiblePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - JobID: '${JobID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Delete_Host:
        x: 51
        'y': 78
      Delete_Job_Template:
        x: 225
        'y': 83
      Delete_Inventory:
        x: 416
        'y': 84
      Remove_Job:
        x: 594
        'y': 89
        navigate:
          7efc3a82-e3a6-383b-cb1a-273aae4392ef:
            targetId: d07b125f-d315-af3c-906d-19c62dc2197a
            port: SUCCESS
    results:
      SUCCESS:
        d07b125f-d315-af3c-906d-19c62dc2197a:
          x: 591
          'y': 335
