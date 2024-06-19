namespace: io.cloudslang.energy_project.database
flow:
  name: create_list_of_dates
  inputs:
    - date: '2023-05-09'
    - today: '2023-12-31'
  workflow:
    - parse_date:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${date}'
            - date_format: YYYY-MM-dd
            - out_format: YYYY-MM-dd
        publish:
          - output
          - list: '${output}'
        navigate:
          - SUCCESS: offset_time_by
          - FAILURE: on_failure
    - offset_time_by:
        do:
          io.cloudslang.base.datetime.offset_time_by:
            - date: '${output}'
            - offset: '86400'
        publish:
          - output
        navigate:
          - SUCCESS: parse_date_1
          - FAILURE: on_failure
    - parse_date_1:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${output}'
            - out_format: YYYY-MM-dd
        publish:
          - dd: '${output}'
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${list}'
            - element: '${dd}'
            - delimiter: ','
        publish:
          - list: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${dd}'
            - second_string: '${today}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: offset_time_by
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      parse_date:
        x: 80
        'y': 40
      offset_time_by:
        x: 80
        'y': 240
      parse_date_1:
        x: 240
        'y': 120
      add_element:
        x: 240
        'y': 280
      string_equals:
        x: 240
        'y': 440
        navigate:
          b05bb08f-d85c-9935-a8c2-c3d3bbe66197:
            targetId: 9f241bc6-b4ff-060a-184f-172fa50ecb27
            port: SUCCESS
    results:
      SUCCESS:
        9f241bc6-b4ff-060a-184f-172fa50ecb27:
          x: 480
          'y': 440
