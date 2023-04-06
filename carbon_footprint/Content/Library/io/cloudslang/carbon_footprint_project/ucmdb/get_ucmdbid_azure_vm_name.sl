namespace: io.cloudslang.carbon_footprint_project.ucmdb
flow:
  name: get_ucmdbid_azure_vm_name
  inputs:
    - topology: DCOE_ESG_Azure
  workflow:
    - get_topology:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.get_topology:
            - topology: '${topology}'
        publish:
          - ucmdbIds
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ucmdbids: '${ucmdbIds}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_topology:
        x: 68
        'y': 67
        navigate:
          d67de047-7f42-43a8-d71a-833842df4f8f:
            targetId: 6039541d-62fa-5c2a-398f-f77211f6586d
            port: SUCCESS
    results:
      SUCCESS:
        6039541d-62fa-5c2a-398f-f77211f6586d:
          x: 270
          'y': 188

