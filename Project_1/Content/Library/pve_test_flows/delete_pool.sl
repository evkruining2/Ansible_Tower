namespace: pve_test_flows
flow:
  name: delete_pool
  inputs:
    - poolID: pool3
  workflow:
    - delete_pool:
        do:
          io.cloudslang.proxmox.pve.pools.delete_pool:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - poolID: '${poolID}'
        publish:
          - result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result: '${result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_pool:
        x: 168
        'y': 148.5
        navigate:
          978d41c0-1315-5c64-18d4-9c8f4c6ab939:
            targetId: 10cec04c-b417-c725-58a8-faf6a9b57db2
            port: SUCCESS
    results:
      SUCCESS:
        10cec04c-b417-c725-58a8-faf6a9b57db2:
          x: 344
          'y': 141
