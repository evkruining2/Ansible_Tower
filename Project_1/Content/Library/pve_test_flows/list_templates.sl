namespace: pve_test_flows
flow:
  name: list_templates
  inputs:
    - node: pve2
    - storage: pve_backup
  workflow:
    - list_backups:
        do:
          io.cloudslang.proxmox.pve.storage.content.list_backups:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - storage: '${storage}'
        publish:
          - volids
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - flow_output_0: '${volids}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      list_backups:
        x: 154
        'y': 180
        navigate:
          c55ef5e1-3c07-5bd2-a85a-7beff8abb92b:
            targetId: 3436b88b-4225-d6c0-bb4e-a87f52a7465d
            port: SUCCESS
    results:
      SUCCESS:
        3436b88b-4225-d6c0-bb4e-a87f52a7465d:
          x: 338
          'y': 147
