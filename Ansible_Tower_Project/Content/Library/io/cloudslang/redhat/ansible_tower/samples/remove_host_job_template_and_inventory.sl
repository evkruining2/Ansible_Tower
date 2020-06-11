########################################################################################################################
#!!
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
    - JobID
    - InventoryID
    - TemplateID
    - HostID
  workflow:
    - Delete_Host:
        do:
          io.cloudslang.redhat.ansible_tower.hosts.delete_host:
            - HostID: '${HostID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Delete_Job_Template
    - Delete_Job_Template:
        do:
          io.cloudslang.redhat.ansible_tower.job_templates.delete_job_template:
            - TemplateID: '${TemplateID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Delete_Inventory
    - Delete_Inventory:
        do:
          io.cloudslang.redhat.ansible_tower.inventories.delete_inventory:
            - InventoryID: '${InventoryID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Remove_Job
    - Remove_Job:
        do:
          io.cloudslang.redhat.ansible_tower.ansible_tower.jobs.remove_job:
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
