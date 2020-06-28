namespace: pve_test_flows.qemu
flow:
  name: shutdown_vm
  inputs:
    - node: pve2
    - vmid: '108'
  workflow:
    - shutdown_vm:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.shutdown_vm:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: 'true'
            - HostnameVerify: allow_all
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
      shutdown_vm:
        x: 163
        'y': 192
        navigate:
          48a11f21-5cd4-a8b6-3efb-3aad11cc484c:
            targetId: 871f9f48-5176-ebbb-3cad-3f1623404568
            port: SUCCESS
    results:
      SUCCESS:
        871f9f48-5176-ebbb-3cad-3f1623404568:
          x: 454
          'y': 200.5
