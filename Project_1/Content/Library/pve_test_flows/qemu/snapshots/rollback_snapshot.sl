namespace: pve_test_flows.qemu.snapshots
flow:
  name: rollback_snapshot
  inputs:
    - node: pve2
    - vmid: '108'
    - snapname: snap
  workflow:
    - rollback_snapshot:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.snapshot.rollback_snapshot:
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
      rollback_snapshot:
        x: 140
        'y': 131
        navigate:
          b8bcc96f-b0b5-52d8-baba-2180313bccd2:
            targetId: 7cbb0649-d4f3-e078-0e7f-0e21a02baa3f
            port: SUCCESS
    results:
      SUCCESS:
        7cbb0649-d4f3-e078-0e7f-0e21a02baa3f:
          x: 369
          'y': 138
