namespace: io.cloudslang.testing
flow:
  name: install_python_module
  workflow:
    - view_installed_modules_1:
        do:
          io.cloudslang.testing.view_installed_modules: []
        navigate:
          - SUCCESS: install_module
    - install_module:
        do:
          io.cloudslang.testing.install_module: []
        navigate:
          - SUCCESS: view_installed_modules
    - view_installed_modules:
        do:
          io.cloudslang.testing.view_installed_modules: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      view_installed_modules_1:
        x: 120
        'y': 160
      install_module:
        x: 280
        'y': 160
      view_installed_modules:
        x: 480
        'y': 80
        navigate:
          004a6b01-22fe-ce33-eead-0c6a90ad094d:
            targetId: 4f522003-89f7-890a-1ebd-d96e2b77fae3
            port: SUCCESS
    results:
      SUCCESS:
        4f522003-89f7-890a-1ebd-d96e2b77fae3:
          x: 680
          'y': 240
