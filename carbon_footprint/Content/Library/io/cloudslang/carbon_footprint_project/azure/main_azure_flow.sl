namespace: io.cloudslang.carbon_footprint_project.azure
flow:
  name: main_azure_flow
  inputs:
    - timestamp
  workflow:
    - get_ucmdbid_azure_vm_name:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.get_ucmdbid_azure_vm_name: []
        publish:
          - ucmdbids
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_details
    - get_vm_details:
        do:
          io.cloudslang.carbon_footprint_project.azure.get_vm_details:
            - ucmdbids: '${ucmdbids}'
            - timestamp: '${timestamp}'
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
        x: 292
        'y': 89
        navigate:
          70702799-dc36-a8ad-27a6-e4910dd93e19:
            targetId: 76fdb7f8-5736-30e5-1e40-0a60056a7d6f
            port: SUCCESS
      get_ucmdbid_azure_vm_name:
        x: 78
        'y': 82
    results:
      SUCCESS:
        76fdb7f8-5736-30e5-1e40-0a60056a7d6f:
          x: 486
          'y': 83

