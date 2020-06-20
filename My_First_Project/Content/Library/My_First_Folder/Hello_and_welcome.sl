namespace: My_First_Folder
flow:
  name: Hello_and_welcome
  workflow:
    - Hello_World:
        do:
          My_First_Folder.Hello_World: []
        navigate:
          - SUCCESS: SUCCESS
          - WARNING: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Hello_World:
        x: 117
        'y': 141
        navigate:
          08a682a9-b105-1b6d-d66e-744886778011:
            targetId: 09433400-d8d4-3ab3-7390-e223203375c1
            port: SUCCESS
          31acad1e-93dd-0531-6f23-0781eb725883:
            targetId: 09433400-d8d4-3ab3-7390-e223203375c1
            port: WARNING
    results:
      SUCCESS:
        09433400-d8d4-3ab3-7390-e223203375c1:
          x: 298
          'y': 134
