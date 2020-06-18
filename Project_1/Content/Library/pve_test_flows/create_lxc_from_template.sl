namespace: pve_test_flows
flow:
  name: create_lxc_from_template
  inputs:
    - pveURL: 'https://pve2:8006'
    - pveUsername: root@pam
    - pvePassword:
        default: opsware
        sensitive: true
    - TrustAllRoots: 'true'
    - HostnameVerify: allow_all
    - node: pve2
    - vmid: '997'
    - ostemplate: 'pve_backup:vztmpl/centos-7-default_20190926_amd64.tar.xz'
    - containerpassword:
        default: opsware
        sensitive: true
    - memory:
        default: '1024'
        required: false
    - storage: local-fast
    - hostname: ct997
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
    - create_lxc_from_template:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.create_lxc_from_template:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - ostemplate: '${ostemplate}'
            - vmid: '${vmid}'
            - containerpassword: '${containerpassword}'
            - storage: '${storage}'
            - node: '${node}'
            - hostname: '${hostname}'
            - memory: '${memory}'
            - nameserver: '${nameserver}'
            - net0: '${net0}'
            - net1: '${net1}'
            - net2: '${net2}'
            - net3: '${net3}'
        publish:
          - JobStatus
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${JobStatus}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_lxc_from_template:
        x: 141
        'y': 116
        navigate:
          3e39a81b-3742-a310-18e0-b299a3c52cde:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 418
          'y': 116
