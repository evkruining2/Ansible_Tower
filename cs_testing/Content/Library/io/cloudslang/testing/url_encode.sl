namespace: io.cloudslang.testing
flow:
  name: url_encode
  inputs:
    - net0_0: 'name=eth0,bridge=vmbr0,ip=10.0.0.88/24,gw=10.0.0.1,firewall=0,tag=2'
    - net1_1:
        default: 'name=eth0,bridge=vmbr0,ip=10.0.0.89/24,gw=10.0.0.1,firewall=0,tag=2'
        required: false
    - net2_2:
        required: false
    - net3_3:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net0_0}'
        navigate:
          - IS_NULL: is_null_1
          - IS_NOT_NULL: url_encoder
    - url_encoder:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net0_0}'
        publish:
          - net0: '${result}'
        navigate:
          - SUCCESS: is_null_1
          - FAILURE: on_failure
    - is_null_1:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net1_1}'
        navigate:
          - IS_NULL: is_null_2
          - IS_NOT_NULL: url_encoder_1
    - is_null_2:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net2_2}'
        navigate:
          - IS_NULL: is_null_3
          - IS_NOT_NULL: url_encoder_2
    - is_null_3:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net3_3}'
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: url_encoder_3
    - url_encoder_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net1_1}'
        publish:
          - net1: '${result}'
        navigate:
          - SUCCESS: is_null_2
          - FAILURE: on_failure
    - url_encoder_2:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net2_2}'
        publish:
          - net2: '${result}'
        navigate:
          - SUCCESS: is_null_3
          - FAILURE: on_failure
    - url_encoder_3:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net3_3}'
        publish:
          - net3: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - net0: '${net0}'
    - net1: '${net1}'
    - net2: '${net2}'
    - net3: '${net3}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      url_encoder_3:
        x: 280
        'y': 560
        navigate:
          b0d378b3-3d83-ea81-5f81-ef75385d8db2:
            targetId: 83ee13a1-d30b-46a6-9223-8112441d80cc
            port: SUCCESS
      url_encoder:
        x: 280
        'y': 80
      is_null_1:
        x: 120
        'y': 240
      is_null_2:
        x: 120
        'y': 400
      is_null_3:
        x: 120
        'y': 560
        navigate:
          2fc1771a-9f3d-a4fa-e7cb-83937125f459:
            targetId: 83ee13a1-d30b-46a6-9223-8112441d80cc
            port: IS_NULL
      is_null:
        x: 120
        'y': 80
      url_encoder_1:
        x: 280
        'y': 240
      url_encoder_2:
        x: 280
        'y': 400
    results:
      SUCCESS:
        83ee13a1-d30b-46a6-9223-8112441d80cc:
          x: 200
          'y': 720
