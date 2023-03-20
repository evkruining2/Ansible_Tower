namespace: io.cloudslang.testing
flow:
  name: view_installed_modules
  workflow:
    - view_python_packages:
        do:
          io.cloudslang.testing.view_python_packages: []
        publish:
          - installed_modules
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - installed_modules: '${installed_modules}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      view_python_packages:
        x: 120
        'y': 120
        navigate:
          c4d1c1ba-f6b0-56f4-e6b1-da1619d9c976:
            targetId: 560eec1a-69c2-3f43-71a2-a4551f9bd848
            port: SUCCESS
    results:
      SUCCESS:
        560eec1a-69c2-3f43-71a2-a4551f9bd848:
          x: 280
          'y': 160
