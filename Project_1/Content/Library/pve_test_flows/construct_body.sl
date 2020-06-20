namespace: pve_test_flows
flow:
  name: construct_body
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
            - ostemplate: "${get('ostemplate')}"
            - containerpassword: "${get('containerpassword')}"
            - storage: "${get('storage')}"
            - memory: "${get('memory')}"
            - hostname: "${get('hostname')}"
            - nameserver: "${get('nameserver')}"
            - net1: "${get('net1')}"
            - net2: "${get('net2')}"
            - net3: "${get('net3')}"
            - net0: "${get('net0')}"
        publish:
          - request: "${request.replace('$','&')}"
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
        x: 151
        'y': 162
        navigate:
          56289db7-4550-7f38-c12a-3d9cd525057b:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 418
          'y': 116
