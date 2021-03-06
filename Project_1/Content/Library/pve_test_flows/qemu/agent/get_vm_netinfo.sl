namespace: pve_test_flows.qemu.agent
flow:
  name: get_vm_netinfo
  inputs:
    - node: pve
    - vmid: '120'
  workflow:
    - get_vm_ip:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.agent.get_vm_ip:
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
          - netinfo
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - netinfo: '${netinfo}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_vm_ip:
        x: 162
        'y': 120
        navigate:
          d83ac84d-f544-34f1-587f-117cf0417069:
            targetId: 73c708e0-a126-71df-2f70-f4d9bfbf5bb1
            port: SUCCESS
    results:
      SUCCESS:
        73c708e0-a126-71df-2f70-f4d9bfbf5bb1:
          x: 373
          'y': 128
