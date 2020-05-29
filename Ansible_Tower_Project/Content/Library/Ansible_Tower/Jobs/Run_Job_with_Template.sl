########################################################################################################################
#!!
#! @description: Launch the selected Job Template
#!
#! @input TemplateID: The id (integer) of the Job Template to launch
#!
#! @output JobID: id (integer) of the launched Job
#!!#
########################################################################################################################
namespace: Ansible_Tower.Jobs
flow:
  name: Run_Job_with_Template
  inputs:
    - TemplateID
  workflow:
    - Launch_Job_Template:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/job_templates/'+TemplateID+'/launch/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_Job_ID
          - FAILURE: on_failure
    - Get_new_Job_ID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - JobID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobID: '${JobID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Launch_Job_Template:
        x: 173
        'y': 128.5
      Get_new_Job_ID:
        x: 373
        'y': 131
        navigate:
          33aee7f1-dcdd-df48-2d3d-da8249f0964f:
            targetId: 5f8931d5-1ea8-a948-a3d6-37da6e44875f
            port: SUCCESS
    results:
      SUCCESS:
        5f8931d5-1ea8-a948-a3d6-37da6e44875f:
          x: 579
          'y': 130
