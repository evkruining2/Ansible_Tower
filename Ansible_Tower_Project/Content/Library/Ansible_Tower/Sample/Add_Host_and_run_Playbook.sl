########################################################################################################################
#!!
#! @description: This flow will create a new host, inventory and job template in Ansible Tower. It will then run the new job template against the new inventory, containing the new host.
#!
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
namespace: Ansible_Tower.Sample
flow:
  name: Add_Host_and_run_Playbook
  inputs:
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
        do:
          Ansible_Tower.Inventories.Create_Inventory:
            - InventoryName: '${InventoryName}'
            - OrgID: '${OrgID}'
        publish:
          - InventoryID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Create_Job_Template
    - Create_Job_Template:
        do:
          Ansible_Tower.Job_Templates.Create_Job_Template:
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
        do:
          Ansible_Tower.Hosts.Create_Host:
            - HostName: '${HostName}'
            - Inventory: '${InventoryID}'
            - HostDescription: '${HostDescription}'
        publish:
          - HostID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Run_Job_with_Template
    - Run_Job_with_Template:
        do:
          Ansible_Tower.Jobs.Run_Job_with_Template:
            - TemplateID: '${TemplateID}'
        publish:
          - JobID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Wait_for_final_job_result
    - Wait_for_final_job_result:
        do:
          Ansible_Tower.Jobs.Wait_for_final_job_result:
            - JobID: '${JobID}'
        publish:
          - JobStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - Attach_Credentials_to_Job_Template:
        do:
          Ansible_Tower.Job_Templates.Attach_Credentials_to_Job_Template:
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
