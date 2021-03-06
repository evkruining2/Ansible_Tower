namespace: pve_test_flows
flow:
  name: get_nodes
  workflow:
    - get_nodes:
        do:
          io.cloudslang.proxmox.pve.nodes.get_nodes:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pveNodes
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pveNodes: '${pveNodes}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_nodes:
        x: 147
        'y': 143
        navigate:
          6e3ff4e6-922f-f8f2-3bd7-cb5bde6210de:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 392
          'y': 137
