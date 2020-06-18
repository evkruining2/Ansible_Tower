namespace: io.cloudslang.proxmox.pve.nodes.lxc
flow:
  name: build_http_body
  inputs:
    - ostemplate
    - containerpassword
    - storage
    - hostname
    - memory:
        required: false
    - nameserver:
        required: false
    - net0:
        required: false
    - net1:
        required: false
    - net2:
        required: false
    - net3:
        required: false
  workflow:
    - set_initial_body:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${'ostemplate='+ostemplate+'&hostname='+hostname+'&password='+containerpassword+'&storage='}"
            - text: '${storage}'
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: nameserver
    - nameserver:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${nameserver}'
        publish: []
        navigate:
          - IS_NULL: memory
          - IS_NOT_NULL: add_nameserver
    - add_nameserver:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&nameserver='+nameserver}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: memory
    - net0:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net0}'
        publish: []
        navigate:
          - IS_NULL: net1
          - IS_NOT_NULL: url_encoder
    - add_nic0:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net0='+net0}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: net1
    - url_encoder:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net0}'
        publish:
          - net0: '${result}'
        navigate:
          - SUCCESS: add_nic0
          - FAILURE: on_failure
    - net1:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net1}'
        publish: []
        navigate:
          - IS_NULL: net2
          - IS_NOT_NULL: url_encoder_1
    - url_encoder_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net1}'
        publish:
          - net1: '${result}'
        navigate:
          - SUCCESS: add_nic1
          - FAILURE: on_failure
    - add_nic1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net1='+net1}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: net2
    - net2:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net2}'
        publish: []
        navigate:
          - IS_NULL: net3
          - IS_NOT_NULL: url_encoder_1_1
    - net3:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net3}'
        publish: []
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: url_encoder_1_1_1
    - url_encoder_1_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net2}'
        publish:
          - net1: '${result}'
        navigate:
          - SUCCESS: add_nic2
          - FAILURE: on_failure
    - add_nic2:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net2='+net2}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: net3
    - url_encoder_1_1_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net3}'
        publish:
          - net1: '${result}'
        navigate:
          - SUCCESS: add_nic3
          - FAILURE: on_failure
    - add_nic3:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net3='+net3}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: SUCCESS
    - memory:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${memory}'
        publish: []
        navigate:
          - IS_NULL: net0
          - IS_NOT_NULL: add_memory
    - add_memory:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&memory='+memory}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: net0
  outputs:
    - body: '${body}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      memory:
        x: 260
        'y': 83
      url_encoder_1_1_1:
        x: 1160
        'y': 303
      add_nic0:
        x: 479
        'y': 323
      add_nic1:
        x: 729
        'y': 320
      add_nic2:
        x: 1002
        'y': 314
      add_nic3:
        x: 1352
        'y': 301
        navigate:
          f544e2de-f563-d6bd-ac4a-49527db481e3:
            targetId: 48e22588-9c64-3ed7-9a2d-7c0ad53c6e08
            port: SUCCESS
      url_encoder:
        x: 357
        'y': 329
      add_nameserver:
        x: 63
        'y': 339
      nameserver:
        x: 117
        'y': 78
      url_encoder_1_1:
        x: 863
        'y': 318
      net0:
        x: 483
        'y': 86
      net1:
        x: 679
        'y': 91
      net2:
        x: 907
        'y': 97
      net3:
        x: 1127
        'y': 98
        navigate:
          a2f24d04-1b72-e6b4-ee81-2be42838a661:
            targetId: 48e22588-9c64-3ed7-9a2d-7c0ad53c6e08
            port: IS_NULL
      set_initial_body:
        x: 16
        'y': 155
      url_encoder_1:
        x: 602
        'y': 322
      add_memory:
        x: 225
        'y': 324
    results:
      SUCCESS:
        48e22588-9c64-3ed7-9a2d-7c0ad53c6e08:
          x: 1353
          'y': 90
