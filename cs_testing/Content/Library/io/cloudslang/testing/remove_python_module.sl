namespace: io.cloudslang.testing
flow:
  name: remove_python_module
  workflow:
    - remove_module:
        do:
          io.cloudslang.testing.remove_module: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      remove_module:
        x: 280
        'y': 200
        navigate:
          0c84d490-fd42-f7a3-fe5e-0b7f4d7cab7f:
            targetId: 4f522003-89f7-890a-1ebd-d96e2b77fae3
            port: SUCCESS
    results:
      SUCCESS:
        4f522003-89f7-890a-1ebd-d96e2b77fae3:
          x: 480
          'y': 240
