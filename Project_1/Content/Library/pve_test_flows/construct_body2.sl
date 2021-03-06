namespace: pve_test_flows
flow:
  name: construct_body2
  inputs:
    - ostemplate: 'pve_backup:vztmpl/debian-10.0-standard_10.0-1_amd64.tar.gz'
    - containerpassword:
        default: opsware
        sensitive: true
    - storage: local-fast
    - hostname: ct997
    - memory:
        default: '1024'
        required: false
    - nameserver:
        default: 192.168.2.20
        required: false
    - net0:
        default: 'name=eth0,bridge=vmbr0,ip=192.168.2.88/24,gw=192.168.2.1,firewall=0'
        required: false
    - net1:
        default: 'name=eth1,bridge=vmbr0,ip=dhcp,tag=1,firewall=0'
        required: false
    - net2:
        required: false
    - net3:
        required: false
  workflow:
    - create_urlencoded_body:
        do:
          pve_test_flows.create_urlencoded_body:
            - param_ostemplate: '${ostemplate}'
            - param_containerpassword: '${containerpassword}'
            - param_memory: '${memory}'
            - param_storage: '${storage}'
            - param_hostname: '${hostname}'
            - param_nameserver: '${nameserver}'
            - param_net0: '${net0}'
            - param_net1: '${net1}'
            - param_net2: '${net2}'
            - param_net3: '${net3}'
        publish:
          - request
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - body_text: '${request}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      create_urlencoded_body:
        x: 97
        'y': 100
        navigate:
          7805abe1-9bf5-2e6c-e81f-35a73ae68463:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 312
          'y': 93
