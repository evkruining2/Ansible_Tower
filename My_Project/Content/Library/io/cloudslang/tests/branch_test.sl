namespace: io.cloudslang.tests
flow:
  name: branch_test
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      do_nothing:
        x: 80
        'y': 160
        navigate:
          9237d259-cdf1-2c9f-8576-b3a9f23739d4:
            targetId: da3c2629-ffe1-7d2d-559f-7c8b4e45b389
            port: SUCCESS
    results:
      SUCCESS:
        da3c2629-ffe1-7d2d-559f-7c8b4e45b389:
          x: 320
          'y': 120
