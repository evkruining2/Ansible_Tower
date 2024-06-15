namespace: io.cloudslang.energy_project.tools
flow:
  name: get_smallest_number
  inputs:
    - tariff_list: '1,2,3,4,5'
  workflow:
    - get_smallest_number_in_list:
        do:
          io.cloudslang.energy_project.tools.get_smallest_number_in_list: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      get_smallest_number_in_list:
        x: 200
        'y': 200
        navigate:
          b4ec98e8-6bc8-92ed-37dc-ef8f308eec29:
            targetId: 64c34cfe-e18b-fe17-bb29-d96b8f56c96a
            port: SUCCESS
    results:
      SUCCESS:
        64c34cfe-e18b-fe17-bb29-d96b8f56c96a:
          x: 400
          'y': 240
