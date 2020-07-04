namespace: pve_test_flows.lxc
flow:
  name: list_snapshots
  inputs:
    - node: pve2
    - vmid: '104'
  workflow:
    - list_snapshots_1:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.snapshot.list_snapshots:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
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
      list_snapshots_1:
        x: 126
        'y': 287
        navigate:
          382f65b2-546c-f0c2-19d3-e2d84c7cc232:
            targetId: 91d6f472-eaac-11cf-0c06-cdf2de9b9af4
            port: SUCCESS
    results:
      SUCCESS:
        91d6f472-eaac-11cf-0c06-cdf2de9b9af4:
          x: 338
          'y': 102
