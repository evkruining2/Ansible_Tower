namespace: tests
flow:
  name: url_encode
  inputs:
    - flow_input_0: 'erwin=van,kruining'
  workflow:
    - url_encoder:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${flow_input_0}'
        publish:
          - result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      url_encoder:
        x: 100
        'y': 125
        navigate:
          97a35a79-aff1-7781-34ae-22495c84159e:
            targetId: 83ee13a1-d30b-46a6-9223-8112441d80cc
            port: SUCCESS
    results:
      SUCCESS:
        83ee13a1-d30b-46a6-9223-8112441d80cc:
          x: 358
          'y': 147
