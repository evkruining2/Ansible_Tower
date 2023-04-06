namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: read_from_file
  inputs:
    - file_path
  workflow:
    - read_from_file:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: '${file_path}'
        publish:
          - read_text
          - message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - read_text: '${read_text}'
    - message: '${message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_from_file:
        x: 152
        'y': 183
        navigate:
          01bf02a3-d8af-acff-ff2f-02fc07547c8c:
            targetId: 33b5a533-0da0-c07e-bde5-df695738ca0c
            port: SUCCESS
    results:
      SUCCESS:
        33b5a533-0da0-c07e-bde5-df695738ca0c:
          x: 370
          'y': 175

