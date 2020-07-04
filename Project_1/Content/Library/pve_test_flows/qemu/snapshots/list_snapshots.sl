namespace: pve_test_flows.qemu.snapshots
flow:
  name: list_snapshots
  inputs:
    - node: pve2
    - vmid: '108'
  workflow:
    - list_snapshots:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.snapshot.list_snapshots:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: 'true'
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - vmid: '${vmid}'
        publish:
          - Snapshots
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - SnapShots: '${Snapshots}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_snapshots:
        x: 126
        'y': 114
        navigate:
          f3e9dd8b-1292-8fc0-3e9a-a7f0a43ce4b5:
            targetId: 91d6f472-eaac-11cf-0c06-cdf2de9b9af4
            port: SUCCESS
    results:
      SUCCESS:
        91d6f472-eaac-11cf-0c06-cdf2de9b9af4:
          x: 338
          'y': 102
