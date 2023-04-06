namespace: io.cloudslang.carbon_footprint_project.oneview
flow:
  name: write_csv_with_dc_co2e
  inputs:
    - file_path
  workflow:
    - create_timestamp_flow:
        do:
          io.cloudslang.carbon_footprint_project.tools.create_timestamp_flow: []
        publish:
          - timestamp
        navigate:
          - SUCCESS: local_dc_co2e
          - FAILURE: on_failure
    - local_dc_co2e:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.local_dc_co2e:
            - timestamp: '${timestamp}'
        publish:
          - csv
          - date_of_sample
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - date_of_sample: '${date_of_sample}'
    - csv: '${csv}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_timestamp_flow:
        x: 70
        'y': 76
      local_dc_co2e:
        x: 259
        'y': 79
        navigate:
          e78f9ee0-0df6-12f4-7556-2bc3695fe731:
            targetId: aa243003-4d3d-ce3a-1c71-bf1644cd54fe
            port: SUCCESS
    results:
      SUCCESS:
        aa243003-4d3d-ce3a-1c71-bf1644cd54fe:
          x: 448
          'y': 78

