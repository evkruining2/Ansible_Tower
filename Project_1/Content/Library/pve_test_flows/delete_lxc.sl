namespace: pve_test_flows
flow:
  name: delete_lxc
  inputs:
    - node: pve2
    - vmid: '9402'
  workflow:
    - delete_lxc:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.delete_lxc:
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
      delete_lxc:
        x: 197
        'y': 113
        navigate:
          cc4fada5-601e-000e-ac4a-4729e3fa236b:
            targetId: fbe620e9-a74e-3d60-a9df-7e30fde0db0a
            port: SUCCESS
    results:
      SUCCESS:
        fbe620e9-a74e-3d60-a9df-7e30fde0db0a:
          x: 365
          'y': 101
