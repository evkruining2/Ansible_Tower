namespace: pve_test_flows
flow:
  name: start_lxc
  inputs:
    - node: pve2
    - vmid: '997'
  workflow:
    - suspend_lxc:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.suspend_lxc:
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
      suspend_lxc:
        x: 147
        'y': 140
        navigate:
          dcab5abc-1644-cdbb-5437-229072fb0b85:
            targetId: ef225cf1-af58-805b-5dff-70dde62e306a
            port: SUCCESS
    results:
      SUCCESS:
        ef225cf1-af58-805b-5dff-70dde62e306a:
          x: 389
          'y': 150
