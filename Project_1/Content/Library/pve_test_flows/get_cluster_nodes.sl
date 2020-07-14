namespace: pve_test_flows
flow:
  name: get_cluster_nodes
  inputs:
    - pveURL: 'https://10.0.10.2:8006'
  workflow:
    - get_cluster_nodes:
        do:
          io.cloudslang.proxmox.pve.cluster.get_cluster_nodes:
            - pveURL: '${pveURL}'
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - clusterNodes
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - nodes: '${clusterNodes}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_cluster_nodes:
        x: 223
        'y': 142.5
        navigate:
          73b19130-98aa-c26d-babe-08f4621ba878:
            targetId: f64f7c88-f606-6bdf-15b7-c615d9955eab
            port: SUCCESS
    results:
      SUCCESS:
        f64f7c88-f606-6bdf-15b7-c615d9955eab:
          x: 447
          'y': 176
