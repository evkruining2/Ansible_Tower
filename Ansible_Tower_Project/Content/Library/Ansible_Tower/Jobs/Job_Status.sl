########################################################################################################################
#!!
#! @description: Check the Job status, based on the job id.
#!               
#!               Possible values of JobStatus are:
#!               
#!               - Pending
#!               - Running
#!               - Failed
#!               - Successful
#!
#! @input JobID: The id (integer) of the job you want the check the status for
#!
#! @output JobStatus: The status of the job
#!!#
########################################################################################################################
namespace: Ansible_Tower.Jobs
flow:
  name: Job_Status
  inputs:
    - JobID
  workflow:
    - Get_information_for_JobID:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('AnsibleTowerURL')+'/jobs/'+JobID}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
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
