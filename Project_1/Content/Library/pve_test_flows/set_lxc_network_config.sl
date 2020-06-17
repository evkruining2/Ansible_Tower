namespace: pve_test_flows
flow:
  name: set_lxc_network_config
  inputs:
    - pveURL: 'https://pve2:8006'
    - pveUsername: root@pam
    - pvePassword:
        default: opsware
        sensitive: true
    - TrustAllRoots: 'true'
    - HostnameVerify: allow_all
    - node: pve2
    - vmid: '994'
    - net0: name=arie0
  workflow:
    - set_lxc_network_config:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.set_lxc_network_config:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword: '${pvePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - vmid: '${vmid}'
            - node: '${node}'
            - net0: '${net0}'
        publish:
          - JobStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - JobStatus: '${JobStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_lxc_network_config:
        x: 196
        'y': 111
        navigate:
          fffea7fb-909b-3a70-89e9-6f60d676af36:
            targetId: 9d5800d6-aa03-974d-40e2-48c2d73cfd34
            port: SUCCESS
    results:
      SUCCESS:
        9d5800d6-aa03-974d-40e2-48c2d73cfd34:
          x: 401
          'y': 102
