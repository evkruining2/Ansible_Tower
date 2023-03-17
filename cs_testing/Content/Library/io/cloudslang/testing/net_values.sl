namespace: io.cloudslang.testing
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
    - url_encode_1:
        do:
          io.cloudslang.testing.url_encode: []
        publish:
          - net0
          - net1
          - net2
          - net3
        navigate:
          - SUCCESS: create_urlencoded_body_1_1
          - FAILURE: on_failure
    - create_urlencoded_body_1_1:
        do:
          io.cloudslang.testing.create_urlencoded_body_1:
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
      create_urlencoded_body_1_1:
        x: 160
        'y': 320
        navigate:
          92a57b9f-2a4b-69c0-803d-d8a359955427:
            targetId: 7c63977d-a98a-86be-a722-05edf497dee1
            port: SUCCESS
      url_encode_1:
        x: 160
        'y': 120
    results:
      SUCCESS:
        7c63977d-a98a-86be-a722-05edf497dee1:
          x: 400
          'y': 400
