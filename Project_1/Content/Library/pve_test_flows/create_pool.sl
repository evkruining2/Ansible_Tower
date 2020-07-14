namespace: pve_test_flows
flow:
  name: create_pool
  inputs:
    - poolID: pool3
    - description: dit is pool 3
  workflow:
    - create_pool:
        do:
          io.cloudslang.proxmox.pve.pools.create_pool:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - poolID: '${poolID}'
            - description: '${description}'
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
      create_pool:
        x: 209
        'y': 156.5
        navigate:
          650b109d-5e52-1d8c-bc84-3476f07fde55:
            targetId: b5e1ac1f-5fca-1306-f30c-6e99bb4e439e
            port: SUCCESS
    results:
      SUCCESS:
        b5e1ac1f-5fca-1306-f30c-6e99bb4e439e:
          x: 410
          'y': 130
