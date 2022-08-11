namespace: tests
flow:
  name: Lanes
  inputs:
    - loop: '1,2,3,4,5,6,7,8,9'
  workflow:
    - sleep:
        parallel_loop:
          for: n in loop
          do:
            io.cloudslang.base.utils.sleep:
              - seconds: '10'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      sleep:
        x: 167
        'y': 241
        navigate:
          ad06b91e-4534-91ed-f03e-4d3dfae93bb6:
            targetId: 7632ab50-f557-19e2-2c70-98094ef49f24
            port: SUCCESS
    results:
      SUCCESS:
        7632ab50-f557-19e2-2c70-98094ef49f24:
          x: 437
          'y': 237
