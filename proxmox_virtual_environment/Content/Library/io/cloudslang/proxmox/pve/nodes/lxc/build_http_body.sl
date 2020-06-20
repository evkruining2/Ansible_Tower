namespace: io.cloudslang.proxmox.pve.nodes.lxc
flow:
  name: build_http_body
  inputs:
    - ostemplate
    - containerpassword:
        sensitive: true
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
    - net1:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net1}'
        publish: []
        navigate:
          - IS_NULL: net2
          - IS_NOT_NULL: url_encoder_1
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
          - IS_NOT_NULL: url_encoder_2
    - net3:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net3}'
        publish: []
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: url_encoder_3
    - add_nic2:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net2='+net2}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: net3
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
    - url_encoder:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net0}'
            - safe: null
        publish:
          - net0: '${result}'
        navigate:
          - SUCCESS: add_nic0
          - FAILURE: on_failure
    - url_encoder_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net1}'
            - safe: null
        publish:
          - net1: '${result}'
        navigate:
          - SUCCESS: add_nic1
          - FAILURE: on_failure
    - url_encoder_2:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net2}'
            - safe: null
        publish:
          - net2: '${result}'
        navigate:
          - SUCCESS: add_nic2
          - FAILURE: on_failure
    - url_encoder_3:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net3}'
            - safe: null
        publish:
          - net3: '${result}'
        navigate:
          - SUCCESS: add_nic3
          - FAILURE: on_failure
  outputs:
    - body: '${body}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      url_encoder_3:
        x: 1075
        'y': 316
      memory:
        x: 269
        'y': 142
      add_nic0:
        x: 470
        'y': 531
      add_nic1:
        x: 662
        'y': 530
      add_nic2:
        x: 872
        'y': 527
      add_nic3:
        x: 1074
        'y': 526
        navigate:
          9f789459-0f6a-f8b1-d7f1-c208626dc973:
            targetId: 48e22588-9c64-3ed7-9a2d-7c0ad53c6e08
            port: SUCCESS
      url_encoder:
        x: 468
        'y': 318
      add_nameserver:
        x: 60
        'y': 565
      nameserver:
        x: 62
        'y': 341
      net0:
        x: 470
        'y': 137
      net1:
        x: 666
        'y': 136
      net2:
        x: 876
        'y': 135
      net3:
        x: 1073
        'y': 135
        navigate:
          be303ffd-ad36-6a75-5673-21644dbe063e:
            targetId: 48e22588-9c64-3ed7-9a2d-7c0ad53c6e08
            port: IS_NULL
      set_initial_body:
        x: 65
        'y': 142
      url_encoder_1:
        x: 666
        'y': 318
      add_memory:
        x: 263
        'y': 330
      url_encoder_2:
        x: 873
        'y': 315
    results:
      SUCCESS:
        48e22588-9c64-3ed7-9a2d-7c0ad53c6e08:
          x: 1215
          'y': 321
