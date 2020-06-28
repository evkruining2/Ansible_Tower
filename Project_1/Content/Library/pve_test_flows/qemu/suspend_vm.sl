namespace: pve_test_flows.qemu
flow:
  name: suspend_vm
  inputs:
    - node: pve2
    - vmid: '108'
  workflow:
    - suspend_vm:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.suspend_vm:
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
      suspend_vm:
        x: 154
        'y': 156
        navigate:
          04c262e3-8cd7-6dc2-52f1-c2506bcddf78:
            targetId: c998806e-9dc4-a290-93f6-4ea7f4a77781
            port: SUCCESS
    results:
      SUCCESS:
        c998806e-9dc4-a290-93f6-4ea7f4a77781:
          x: 384
          'y': 147
