namespace: io.cloudslang.co2e_collection.gcp.subflows
flow:
  name: get_co2e
  workflow:
    - for_future_release:
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
      for_future_release:
        x: 80
        'y': 80
        navigate:
          5c0536c2-8b4d-fcaf-8dee-15ce4e3b9e8e:
            targetId: 6ec22c28-8fbf-acd6-e3b5-af526ea4185b
            port: SUCCESS
    results:
      SUCCESS:
        6ec22c28-8fbf-acd6-e3b5-af526ea4185b:
          x: 240
          'y': 120
