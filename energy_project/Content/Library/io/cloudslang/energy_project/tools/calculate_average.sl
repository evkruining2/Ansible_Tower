namespace: io.cloudslang.energy_project.tools
flow:
  name: calculate_average
  inputs:
    - list:
        required: false
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
          - SUCCESS: divide_numbers
          - FAILURE: on_failure
    - divide_numbers:
        do:
          io.cloudslang.base.math.divide_numbers:
            - value1: '${sum}'
            - value2: '24'
        publish:
          - average: '${round(float(result),3)}'
        navigate:
          - ILLEGAL: SUCCESS
          - SUCCESS: SUCCESS
  outputs:
    - average: '${average}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      add_numbers:
        x: 120
        'y': 80
      divide_numbers:
        x: 280
        'y': 80
        navigate:
          1f576857-0cd1-2d13-08ce-63f9f722357b:
            targetId: 650e23d3-8e83-5e67-bc03-4b8ecdaeb568
            port: SUCCESS
          ffdca746-f6c7-9768-a9ff-d61ea66d8520:
            targetId: 650e23d3-8e83-5e67-bc03-4b8ecdaeb568
            port: ILLEGAL
    results:
      SUCCESS:
        650e23d3-8e83-5e67-bc03-4b8ecdaeb568:
          x: 440
          'y': 80
