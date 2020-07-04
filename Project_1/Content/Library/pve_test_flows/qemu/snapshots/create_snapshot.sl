namespace: pve_test_flows.qemu.snapshots
flow:
  name: create_snapshot
  inputs:
    - node: pve2
    - vmid: '108'
    - snapname: snapname2
  workflow:
    - create_snapshot:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.snapshot.create_snapshot:
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
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_snapshot:
        x: 126
        'y': 156
        navigate:
          f1fa7a06-e806-4035-de70-7a68f540423c:
            targetId: ffedaae7-7b9c-362e-01b0-eb30c502c41b
            port: SUCCESS
    results:
      SUCCESS:
        ffedaae7-7b9c-362e-01b0-eb30c502c41b:
          x: 349
          'y': 150
