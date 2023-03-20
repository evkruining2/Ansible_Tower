namespace: io.cloudslang.testing
flow:
  name: install_python_module
  workflow:
    - install_module:
        do:
          io.cloudslang.testing.install_module: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      install_module:
        x: 280
        'y': 160
        navigate:
          409449c4-fe42-4a99-c94e-8ba01283a434:
            targetId: 4f522003-89f7-890a-1ebd-d96e2b77fae3
            port: SUCCESS
    results:
      SUCCESS:
        4f522003-89f7-890a-1ebd-d96e2b77fae3:
          x: 480
          'y': 240
