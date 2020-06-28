namespace: pve_test_flows.qemu
flow:
  name: current_vm_status
  inputs:
    - vmid: '120'
    - node: pve2
  workflow:
    - current_vm_status:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.current_vm_status:
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
          - vmStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - vmStatus: '${vmStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      current_vm_status:
        x: 246
        'y': 166.5
        navigate:
          62d62171-ff1e-89f5-758b-7629b87db6d2:
            targetId: e91479d6-71da-82d0-3de4-a3f4034dced3
            port: SUCCESS
    results:
      SUCCESS:
        e91479d6-71da-82d0-3de4-a3f4034dced3:
          x: 456
          'y': 153
