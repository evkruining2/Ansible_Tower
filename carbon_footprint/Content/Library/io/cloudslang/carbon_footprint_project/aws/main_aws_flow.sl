namespace: io.cloudslang.carbon_footprint_project.aws
flow:
  name: main_aws_flow
  inputs:
    - timestamp
  workflow:
    - get_topology:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.get_topology:
            - topology: DCOE_ESG_AWS
        publish:
          - ucmdbIds
        navigate:
          - SUCCESS: get_vm_details
          - FAILURE: on_failure
    - get_vm_details:
        do:
          io.cloudslang.carbon_footprint_project.aws.get_vm_details:
            - timestamp: '${timestamp}'
            - ucmdb_json: '${ucmdbIds}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_vm_details:
        x: 272
        'y': 95
        navigate:
          45f91128-d7f5-4a7a-f041-03274f4addd7:
            targetId: 2c792f2b-0cc0-21c3-0417-685c3a120fd2
            port: SUCCESS
      get_topology:
        x: 75
        'y': 87
    results:
      SUCCESS:
        2c792f2b-0cc0-21c3-0417-685c3a120fd2:
          x: 477
          'y': 94

