namespace: pve_test_flows
flow:
  name: delete_vm
  inputs:
    - node: pve2
    - vmid: '109'
  workflow:
    - delete_vm:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.delete_vm:
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
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_vm:
        x: 138
        'y': 129.5
        navigate:
          c6bb263a-fc52-dae7-9bfc-aa35b99aef61:
            targetId: 9034769a-9c47-1038-f388-ef5047e694a5
            port: SUCCESS
    results:
      SUCCESS:
        9034769a-9c47-1038-f388-ef5047e694a5:
          x: 329
          'y': 114
