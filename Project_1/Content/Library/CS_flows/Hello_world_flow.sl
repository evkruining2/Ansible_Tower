namespace: CS_flows
flow:
  name: Hello_world_flow
  workflow:
    - Hello_world:
        do:
          CS_flows.Hello_world: []
        navigate:
          - SUCCESS: SUCCESS
          - WARNING: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Hello_world:
        x: 123
        'y': 155
        navigate:
          c97e9be4-8ca4-9170-6df0-b9f272b43bd8:
            targetId: ffc4e22f-c7fc-e65c-4e6a-1ad272c44663
            port: SUCCESS
          50bca227-c6d0-746d-2514-3f02caaa9098:
            targetId: ffc4e22f-c7fc-e65c-4e6a-1ad272c44663
            port: WARNING
    results:
      SUCCESS:
        ffc4e22f-c7fc-e65c-4e6a-1ad272c44663:
          x: 323
          'y': 135
