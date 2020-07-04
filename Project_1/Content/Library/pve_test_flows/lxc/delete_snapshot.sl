namespace: pve_test_flows.lxc
flow:
  name: delete_snapshot
  inputs:
    - node: pve2
    - vmid: '104'
    - snapname: snap
  workflow:
    - delete_snapshot_1:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.snapshot.delete_snapshot:
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
      delete_snapshot_1:
        x: 128
        'y': 255
        navigate:
          99a2c4f5-27cc-8e1d-7672-94d92d5c3c65:
            targetId: 22ec92cf-743d-1409-eacc-bcafe022b75f
            port: SUCCESS
    results:
      SUCCESS:
        22ec92cf-743d-1409-eacc-bcafe022b75f:
          x: 326
          'y': 90
