namespace: pve_test_flows.lxc
flow:
  name: create_snapshot
  inputs:
    - node: pve2
    - vmid: '104'
    - snapname: snap2
  workflow:
    - create_snapshot:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.snapshot.create_snapshot:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - vmid: '${vmid}'
            - snapname: '${snapname}'
        publish:
          - TaskStatus
          - ExitStatus
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ExitStatus: '${ExitStatus}'
    - TaskStatus: '${TaskStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_snapshot:
        x: 118
        'y': 85
        navigate:
          d5657b31-0e7e-e08e-bc34-a933a71973d5:
            targetId: c6c87b3e-a106-cc00-6875-ed53cf653209
            port: SUCCESS
    results:
      SUCCESS:
        c6c87b3e-a106-cc00-6875-ed53cf653209:
          x: 265
          'y': 79
