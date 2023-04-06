namespace: io.cloudslang.tests
flow:
  name: test_lane
  inputs:
    - flow_input_0:
        default: 'een,twee,drie,4,5,6,7,8,9'
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${flow_input_0}'
        navigate:
          - IS_NULL: do_nothing_2
          - IS_NOT_NULL: list_iterator
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - output_0: output_0
        navigate:
          - SUCCESS: add_numbers
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${flow_input_0}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: do_nothing
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - do_nothing_2:
        do:
          io.cloudslang.base.utils.do_nothing: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: "${get('number', '0')}"
            - value2: '1'
        publish:
          - number: '${result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
  outputs:
    - number: '${number}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 120
        'y': 280
      do_nothing:
        x: 320
        'y': 240
      do_nothing_2:
        x: 440
        'y': 480
        navigate:
          257465f1-96f9-6938-0ccc-721da0d4984a:
            targetId: 1d36f5da-4b19-0293-4205-82a8efe14cc8
            port: SUCCESS
      list_iterator:
        x: 200
        'y': 80
        navigate:
          c6ba740b-70ea-b97c-9d19-9145e47d3b17:
            targetId: 1d36f5da-4b19-0293-4205-82a8efe14cc8
            port: NO_MORE
      add_numbers:
        x: 480
        'y': 160
    results:
      SUCCESS:
        1d36f5da-4b19-0293-4205-82a8efe14cc8:
          x: 640
          'y': 40
