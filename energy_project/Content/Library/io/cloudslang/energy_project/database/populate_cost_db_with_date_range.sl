namespace: io.cloudslang.energy_project.database
flow:
  name: populate_cost_db_with_date_range
  inputs:
    - date_range: '2023-05-08'
  workflow:
    - put_cost_in_db:
        loop:
          for: i in date_range
          do:
            io.cloudslang.energy_project.database.put_cost_in_db:
              - date: '${i}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      put_cost_in_db:
        x: 120
        'y': 160
        navigate:
          d099f18b-3520-0e7b-b330-25027b4b545e:
            targetId: ffd0036c-d244-ed74-845e-91b6a8e5dac4
            port: SUCCESS
    results:
      SUCCESS:
        ffd0036c-d244-ed74-845e-91b6a8e5dac4:
          x: 360
          'y': 240
