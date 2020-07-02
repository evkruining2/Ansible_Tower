namespace: pve_test_flows.qemu
flow:
  name: list_qemu_templates
  inputs:
    - node: pve2
  workflow:
    - list_qemu_templates:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.list_qemu_templates:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
        publish:
          - vmids
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - vmids: '${vmids}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      list_qemu_templates:
        x: 154
        'y': 166
        navigate:
          3f737ed5-1a4f-ea65-bd5c-6bebd14805c4:
            targetId: 9b737848-b3e4-20ef-3d77-0b535f9fb5ab
            port: SUCCESS
    results:
      SUCCESS:
        9b737848-b3e4-20ef-3d77-0b535f9fb5ab:
          x: 454
          'y': 195.5
