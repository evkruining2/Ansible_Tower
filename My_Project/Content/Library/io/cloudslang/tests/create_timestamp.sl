namespace: io.cloudslang.tests
flow:
  name: create_timestamp
  workflow:
    - create_timestamp_1:
        do:
          io.cloudslang.tools.create_timestamp: []
        publish:
          - timestamp
        navigate:
          - SUCCESS: convert_epoch_time
    - convert_epoch_time:
        do:
          io.cloudslang.base.utils.convert_epoch_time:
            - epoch_time: '${timestamp}'
            - time_zone: '(UTC+08:00) Asia/Singapore'
        publish:
          - date_format
          - time_zone
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - timestamp: '${timestamp}'
    - date_format: '${date_format}'
    - time_zone: '${time_zone}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_timestamp_1:
        x: 120
        'y': 120
      convert_epoch_time:
        x: 280
        'y': 120
        navigate:
          c9b95b31-cfdd-e418-0f8f-9670cc30f6a8:
            targetId: 5a2bd92e-33f8-de2f-ef93-4fced66ee764
            port: SUCCESS
    results:
      SUCCESS:
        5a2bd92e-33f8-de2f-ef93-4fced66ee764:
          x: 440
          'y': 120
