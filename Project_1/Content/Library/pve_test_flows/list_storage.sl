namespace: pve_test_flows
flow:
  name: list_storage
  inputs:
    - node: pve
  workflow:
    - list_available_storage:
        do:
          io.cloudslang.proxmox.pve.nodes.storage.list_available_storage:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
        publish:
          - storage
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - storage: '${storage}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_available_storage:
        x: 163
        'y': 178.5
        navigate:
          537aa49a-87d4-e816-dc61-0f3f8219b3f2:
            targetId: 96ccf7c4-9491-883f-1a5d-587fa8f07be9
            port: SUCCESS
    results:
      SUCCESS:
        96ccf7c4-9491-883f-1a5d-587fa8f07be9:
          x: 373
          'y': 162
