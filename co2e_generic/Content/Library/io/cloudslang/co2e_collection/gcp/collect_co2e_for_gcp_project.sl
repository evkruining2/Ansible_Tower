namespace: io.cloudslang.co2e_collection.gcp
flow:
  name: collect_co2e_for_gcp_project
  workflow:
    - get_access_token:
        do:
          io.cloudslang.google.authentication.get_access_token: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_access_token:
        x: 120
        'y': 120
        navigate:
          0c76b5c0-a44c-9e7e-0fa5-d1aa4bea5bf3:
            targetId: afe5f3d8-ef48-2832-7678-e02d306a8bd0
            port: SUCCESS
    results:
      SUCCESS:
        afe5f3d8-ef48-2832-7678-e02d306a8bd0:
          x: 320
          'y': 120
