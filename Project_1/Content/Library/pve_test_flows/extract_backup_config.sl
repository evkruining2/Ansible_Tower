namespace: pve_test_flows
flow:
  name: extract_backup_config
  inputs:
    - node: pve2
    - volid: 'local:backup/vzdump-qemu-105-2020_07_03-12_05_22.vma'
  workflow:
    - extract_config:
        do:
          io.cloudslang.proxmox.pve.nodes.vzdump.extract_config:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - volid: '${volid}'
        publish:
          - config
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - config: '${config}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      extract_config:
        x: 138
        'y': 182
        navigate:
          aa3b6458-ce24-e248-2466-7ad26582ca25:
            targetId: e1b6e04b-133e-f932-9085-0d5bd951f62d
            port: SUCCESS
    results:
      SUCCESS:
        e1b6e04b-133e-f932-9085-0d5bd951f62d:
          x: 340
          'y': 188
