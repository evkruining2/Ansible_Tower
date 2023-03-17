namespace: tests
flow:
  name: net_values
  inputs:
    - net0:
        default: 'name=eth0,ip=1.2.3.4'
        required: false
    - net1:
        default: 'name=eth1,ip=4.3.2.1'
        required: false
    - net2:
        required: false
    - net3:
        required: false
  workflow:
    - url_encode:
        do:
          tests.url_encode:
            - net0_0: '${net0}'
            - net1_1: '${net1}'
            - net2_2: '${net2}'
            - net3_3: '${net3}'
        publish:
          - net0
          - net1
          - net2
          - net3
        navigate:
          - SUCCESS: create_urlencoded_body_1
          - FAILURE: on_failure
    - create_urlencoded_body_1:
        do:
          io.cloudslang.proxmox.pve.tools.create_urlencoded_body_1:
            - param_ostemplate: ostemplate
            - param_password: password
            - param_storage: storage
            - param_net0: '${net0}'
            - param_net1: '${net1}'
            - param_net2: '${net2}'
            - param_net3: '${net3}'
        publish:
          - body: '${request}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - body: '${body}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      url_encode:
        x: 200
        'y': 160
      create_urlencoded_body_1:
        x: 440
        'y': 200
        navigate:
          984d38f8-da74-9edc-57fd-532a3539cd94:
            targetId: 7c63977d-a98a-86be-a722-05edf497dee1
            port: SUCCESS
    results:
      SUCCESS:
        7c63977d-a98a-86be-a722-05edf497dee1:
          x: 400
          'y': 440
