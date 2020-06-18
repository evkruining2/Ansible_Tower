namespace: pve_test_flows
flow:
  name: build_http_body
  inputs:
    - ostemplate: 'pre_backup:tmpl/centos.zip'
    - containerpassword: opsware
    - storage: local-fast
    - hostname: myct
    - nameserver:
        default: 192.168.2.20
        required: false
    - net0:
        default: 'name=eth0,bridge=vmbr0,ip=10.0.10.101/24,gw=192.168.2.175,firewall=0'
        required: false
    - net1:
        default: 'name=eth1,bridge=vmbr0,ip=dhcp,firewall=0'
        required: false
    - net2:
        default: 'name=eth2,bridge=vmbr0,ip=dhcp,firewall=0'
        required: false
    - net3:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${nameserver}'
        publish: []
        navigate:
          - IS_NULL: is_null_1
          - IS_NOT_NULL: append
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${'ostemplate='+ostemplate+'&hostname='+hostname+'&containerpassword='+containerpassword+'&storage='+storage}"
            - text: "${'&nameserver='+nameserver}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: is_null_1
    - is_null_1:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net0}'
        publish: []
        navigate:
          - IS_NULL: is_null_1_1
          - IS_NOT_NULL: url_encoder
    - append_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net0='+net0}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: is_null_1_1
    - url_encoder:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net0}'
        publish:
          - net0: '${result}'
        navigate:
          - SUCCESS: append_1
          - FAILURE: on_failure
    - is_null_1_1:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net1}'
        publish: []
        navigate:
          - IS_NULL: is_null_1_1_1
          - IS_NOT_NULL: url_encoder_1
    - url_encoder_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net1}'
        publish:
          - net1: '${result}'
        navigate:
          - SUCCESS: append_1_1
          - FAILURE: on_failure
    - append_1_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net1='+net1}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: is_null_1_1_1
    - is_null_1_1_1:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${net2}'
        publish: []
        navigate:
          - IS_NULL: is_null_1_1_2
          - IS_NOT_NULL: url_encoder_1_1
    - is_null_1_1_2:
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
          - SUCCESS: append_1_1_1
          - FAILURE: on_failure
    - append_1_1_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net2='+net2}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: is_null_1_1_2
    - url_encoder_1_1_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${net3}'
        publish:
          - net1: '${result}'
        navigate:
          - SUCCESS: append_1_1_1_1
          - FAILURE: on_failure
    - append_1_1_1_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${body}'
            - text: "${'&net3='+net3}"
        publish:
          - body: '${new_string}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - body: '${body}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null_1_1:
        x: 425
        'y': 118
      append_1_1_1_1:
        x: 943
        'y': 312
        navigate:
          f544e2de-f563-d6bd-ac4a-49527db481e3:
            targetId: 48e22588-9c64-3ed7-9a2d-7c0ad53c6e08
            port: SUCCESS
      url_encoder_1_1_1:
        x: 830
        'y': 311
      append_1:
        x: 285
        'y': 310
      url_encoder:
        x: 183
        'y': 309
      is_null_1:
        x: 246
        'y': 106
      append_1_1_1:
        x: 726
        'y': 309
      url_encoder_1_1:
        x: 615
        'y': 310
      is_null_1_1_1:
        x: 636
        'y': 126
      is_null_1_1_2:
        x: 847
        'y': 130
        navigate:
          a2f24d04-1b72-e6b4-ee81-2be42838a661:
            targetId: 48e22588-9c64-3ed7-9a2d-7c0ad53c6e08
            port: IS_NULL
      append:
        x: 74
        'y': 311
      is_null:
        x: 69
        'y': 107
      append_1_1:
        x: 504
        'y': 312
      url_encoder_1:
        x: 392
        'y': 312
    results:
      SUCCESS:
        48e22588-9c64-3ed7-9a2d-7c0ad53c6e08:
          x: 993
          'y': 171
