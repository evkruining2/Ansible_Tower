namespace: io.cloudslang.energy_project.tools
flow:
  name: calculate_sum
  inputs:
    - list:
        required: true
    - sum: '0'
  workflow:
    - add_numbers:
        loop:
          for: i in list
          do:
            io.cloudslang.base.math.add_numbers:
              - value1: '${i}'
              - value2: '${sum}'
          break:
            - FAILURE
          publish:
            - sum: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - sum_cost: '${sum}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      add_numbers:
        x: 120
        'y': 80
        navigate:
          27a2f024-e40d-7cb1-8234-b2729c58460f:
            targetId: 650e23d3-8e83-5e67-bc03-4b8ecdaeb568
            port: SUCCESS
    results:
      SUCCESS:
        650e23d3-8e83-5e67-bc03-4b8ecdaeb568:
          x: 440
          'y': 80
