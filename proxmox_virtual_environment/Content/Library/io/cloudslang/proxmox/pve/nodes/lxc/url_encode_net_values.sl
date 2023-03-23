namespace: io.cloudslang.proxmox.pve.nodes.lxc
flow:
  name: url_encode_net_values
  inputs:
    - net0_0
    - net1_1:
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
          - IS_NOT_NULL: search_and_replace_equals
    - is_null_1:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net1_1}'
        navigate:
          - IS_NULL: is_null_2
          - IS_NOT_NULL: search_and_replace_equals_1
    - is_null_2:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net2_2}'
        navigate:
          - IS_NULL: is_null_3
          - IS_NOT_NULL: search_and_replace_equals_2
    - is_null_3:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net3_3}'
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: search_and_replace_equals_3
    - search_and_replace_equals:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${net0_0}'
            - text_to_replace: =
            - replace_with: '%3D'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_comma
          - FAILURE: on_failure
    - search_and_replace_comma:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: ','
            - replace_with: '%2C'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_slash
          - FAILURE: on_failure
    - search_and_replace_slash:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: /
            - replace_with: '%2F'
        publish:
          - net0: '${replaced_string}'
        navigate:
          - SUCCESS: is_null_1
          - FAILURE: on_failure
    - search_and_replace_equals_1:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${net1_1}'
            - text_to_replace: =
            - replace_with: '%3D'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_comma_1
          - FAILURE: on_failure
    - search_and_replace_comma_1:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: ','
            - replace_with: '%2C'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_slash_1
          - FAILURE: on_failure
    - search_and_replace_slash_1:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: /
            - replace_with: '%2F'
        publish:
          - net1: '${replaced_string}'
        navigate:
          - SUCCESS: is_null_2
          - FAILURE: on_failure
    - search_and_replace_equals_2:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${net2_2}'
            - text_to_replace: =
            - replace_with: '%3D'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_comma_2
          - FAILURE: on_failure
    - search_and_replace_comma_2:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: ','
            - replace_with: '%2C'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_slash_2
          - FAILURE: on_failure
    - search_and_replace_slash_2:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: /
            - replace_with: '%2F'
        publish:
          - net2: '${replaced_string}'
        navigate:
          - SUCCESS: is_null_3
          - FAILURE: on_failure
    - search_and_replace_equals_3:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${net3_3}'
            - text_to_replace: =
            - replace_with: '%3D'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_comma_3
          - FAILURE: on_failure
    - search_and_replace_comma_3:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: ','
            - replace_with: '%2C'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: search_and_replace_slash_3
          - FAILURE: on_failure
    - search_and_replace_slash_3:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: /
            - replace_with: '%2F'
        publish:
          - net3: '${replaced_string}'
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
      search_and_replace_slash_1:
        x: 280
        'y': 600
      search_and_replace_slash_2:
        x: 480
        'y': 600
      search_and_replace_slash_3:
        x: 680
        'y': 600
        navigate:
          3e0b48cb-92a9-8f3c-bd0a-49566ec9e763:
            targetId: 83ee13a1-d30b-46a6-9223-8112441d80cc
            port: SUCCESS
      search_and_replace_equals:
        x: 80
        'y': 280
      search_and_replace_comma:
        x: 80
        'y': 440
      is_null_1:
        x: 280
        'y': 80
      is_null_2:
        x: 480
        'y': 80
      is_null_3:
        x: 680
        'y': 80
        navigate:
          62062d95-0f33-2c6a-fdb4-4aebc52d5250:
            targetId: 83ee13a1-d30b-46a6-9223-8112441d80cc
            port: IS_NULL
      search_and_replace_slash:
        x: 80
        'y': 600
      search_and_replace_equals_1:
        x: 280
        'y': 280
      search_and_replace_equals_2:
        x: 480
        'y': 280
      is_null:
        x: 80
        'y': 80
      search_and_replace_equals_3:
        x: 680
        'y': 280
      search_and_replace_comma_1:
        x: 280
        'y': 440
      search_and_replace_comma_2:
        x: 480
        'y': 440
      search_and_replace_comma_3:
        x: 680
        'y': 440
    results:
      SUCCESS:
        83ee13a1-d30b-46a6-9223-8112441d80cc:
          x: 880
          'y': 360

