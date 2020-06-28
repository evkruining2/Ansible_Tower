namespace: pve_test_flows.qemu
flow:
  name: resume_vm
  inputs:
    - node: pve2
    - vmid: '108'
  workflow:
    - resume_vm:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.resume_vm:
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
      resume_vm:
        x: 137
        'y': 151
        navigate:
          34d90476-2ff4-6413-f037-7afa8e75279d:
            targetId: c998806e-9dc4-a290-93f6-4ea7f4a77781
            port: SUCCESS
    results:
      SUCCESS:
        c998806e-9dc4-a290-93f6-4ea7f4a77781:
          x: 384
          'y': 147
