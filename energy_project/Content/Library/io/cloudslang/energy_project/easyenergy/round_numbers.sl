namespace: io.cloudslang.energy_project.easyenergy
flow:
  name: round_numbers
  inputs:
    - list
    - lead: '*'
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${list}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: round_to_3_decimals
          - NO_MORE: do_nothing
          - FAILURE: on_failure
    - round_to_3_decimals:
        do:
          io.cloudslang.energy_project.tools.round_to_4_decimals:
            - input: '${result_string}'
        publish:
          - output
        navigate:
          - SUCCESS: add_element
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${lead}'
            - element: '${output}'
            - delimiter: ','
        publish:
          - lead: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - lead: '${lead}'
        publish:
          - tariff_list: '${cs_substring(lead,2)}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - tariff_list
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      list_iterator:
        x: 80
        'y': 80
      do_nothing:
        x: 280
        'y': 280
        navigate:
          00fe20ff-56b3-ec19-7f10-17402c989450:
            targetId: a7601524-c572-ffe6-45a2-83e9e6534e53
            port: SUCCESS
      add_element:
        x: 80
        'y': 480
      round_to_3_decimals:
        x: 80
        'y': 280
    results:
      SUCCESS:
        a7601524-c572-ffe6-45a2-83e9e6534e53:
          x: 480
          'y': 280
