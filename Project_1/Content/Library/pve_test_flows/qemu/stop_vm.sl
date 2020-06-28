namespace: pve_test_flows.qemu
flow:
  name: stop_vm
  inputs:
    - node: pve2
    - vmid: '108'
  workflow:
    - stop_vm:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.stop_vm:
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
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      stop_vm:
        x: 154
        'y': 126.5
        navigate:
          bc3e0013-ac8d-3782-4034-7c41b0e32cab:
            targetId: 47f65925-e46d-8095-cbea-06d630e364fd
            port: SUCCESS
    results:
      SUCCESS:
        47f65925-e46d-8095-cbea-06d630e364fd:
          x: 357
          'y': 114
