namespace: pve_test_flows.lxc
flow:
  name: rollback_snapshot
  inputs:
    - node: pve2
    - vmid: '104'
    - snapname: snap
  workflow:
    - rollback_snapshot_1:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.snapshot.rollback_snapshot:
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
      rollback_snapshot_1:
        x: 138
        'y': 273
        navigate:
          ca11eeea-8571-c2ca-c9a3-c3cd5a185717:
            targetId: 7cbb0649-d4f3-e078-0e7f-0e21a02baa3f
            port: SUCCESS
    results:
      SUCCESS:
        7cbb0649-d4f3-e078-0e7f-0e21a02baa3f:
          x: 369
          'y': 138
