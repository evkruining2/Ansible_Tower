namespace: pve_test_flows.qemu.snapshots
flow:
  name: delete_snapshot
  inputs:
    - node: pve2
    - vmid: '108'
    - snapname: fifth
  workflow:
    - delete_snapshot:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.snapshot.delete_snapshot:
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
          - upid
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - upid: '${upid}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_snapshot:
        x: 114
        'y': 80
        navigate:
          bee1a744-66e5-8ca0-afe4-97f3d27fa9e5:
            targetId: 22ec92cf-743d-1409-eacc-bcafe022b75f
            port: SUCCESS
    results:
      SUCCESS:
        22ec92cf-743d-1409-eacc-bcafe022b75f:
          x: 326
          'y': 90
