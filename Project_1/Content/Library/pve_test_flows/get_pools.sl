namespace: pve_test_flows
flow:
  name: get_pools
  workflow:
    - get_pools:
        do:
          io.cloudslang.proxmox.pve.pools.get_pools:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pools
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pools: '${pools}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_pools:
        x: 251
        'y': 421
        navigate:
          5284d1e9-48af-0423-70e5-0e30d0006f35:
            targetId: f64f7c88-f606-6bdf-15b7-c615d9955eab
            port: SUCCESS
    results:
      SUCCESS:
        f64f7c88-f606-6bdf-15b7-c615d9955eab:
          x: 447
          'y': 176
