########################################################################################################################
#!!
#! @description: This flow will create a new host, add it to an existing inventory in Ansible Tower. It will then run the given job template against the set inventory, containing the new host.
#!
#! @input HostName: FQDN or ip address if the host to add (string)
#! @input InventoryID: ID of the inventory to add the host to (integer)
#! @input HostDescription: Description of the host (optional)
#! @input TemplateID: ID of the Job Template to execute (integer)
#!!#
########################################################################################################################
namespace: Ansible_Tower.Sample
flow:
  name: Add_new_Host_and_run_existing_Job_Template
  inputs:
    - HostName: localhost
    - InventoryID: '36'
    - HostDescription:
        default: target server
        required: false
    - TemplateID: '78'
  workflow:
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
