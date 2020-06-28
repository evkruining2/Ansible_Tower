namespace: pve_test_flows.qemu
flow:
  name: start_vm
  inputs:
    - node: pve2
    - vmid: '108'
  workflow:
    - start_vm:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.start_vm:
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
          - vmStatus
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result: '${result}'
    - vmStatus: '${vmStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      start_vm:
        x: 167
        'y': 161.5
        navigate:
          b96ea177-b8f4-2895-8ed3-194dd4c569f2:
            targetId: c998806e-9dc4-a290-93f6-4ea7f4a77781
            port: SUCCESS
    results:
      SUCCESS:
        c998806e-9dc4-a290-93f6-4ea7f4a77781:
          x: 384
          'y': 147
