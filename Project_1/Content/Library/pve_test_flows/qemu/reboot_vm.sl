namespace: pve_test_flows.qemu
flow:
  name: reboot_vm
  inputs:
    - node: pve2
    - vmid: '108'
  workflow:
    - reboot_vm:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.reboot_vm:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - vmid: '${vmid}'
        publish:
          - result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result: '${result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      reboot_vm:
        x: 129
        'y': 158
        navigate:
          7e8e8d20-3c79-a371-9b4f-f31087f1acc0:
            targetId: 93bf24fe-0ef0-7af9-de9a-69162951e03f
            port: SUCCESS
    results:
      SUCCESS:
        93bf24fe-0ef0-7af9-de9a-69162951e03f:
          x: 549
          'y': 174.5
