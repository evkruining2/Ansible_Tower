namespace: pve_test_flows
flow:
  name: create_backup
  inputs:
    - node: pve2
    - vmid: '104'
    - storage: local
    - remove: '0'
    - compress: zstd
  workflow:
    - create_backup:
        do:
          io.cloudslang.proxmox.pve.nodes.vzdump.create_backup:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - vmid: '${vmid}'
            - storage: '${storage}'
            - remove: '${remove}'
            - compress: '${compress}'
        publish:
          - JobStatus
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${JobStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_backup:
        x: 114
        'y': 120
        navigate:
          f3d80e1f-ffbf-a0f3-b1ae-d9210649ea6e:
            targetId: fe961b50-e0dc-227a-3328-3e1517799768
            port: SUCCESS
    results:
      SUCCESS:
        fe961b50-e0dc-227a-3328-3e1517799768:
          x: 314
          'y': 111
