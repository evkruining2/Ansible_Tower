namespace: pve_test_flows
flow:
  name: start_lxc
  inputs:
    - node: pve2
    - vmid: '9402'
  workflow:
    - start_lxc:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.start_lxc:
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
      start_lxc:
        x: 122
        'y': 113
        navigate:
          f7254c87-f399-81ac-00ef-093faa49d5d0:
            targetId: ef225cf1-af58-805b-5dff-70dde62e306a
            port: SUCCESS
    results:
      SUCCESS:
        ef225cf1-af58-805b-5dff-70dde62e306a:
          x: 389
          'y': 150
