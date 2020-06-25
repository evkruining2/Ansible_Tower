namespace: pve_test_flows
flow:
  name: get_lxc_status
  inputs:
    - node: pve2
    - vmid: '997'
  workflow:
    - get_lxc_status:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.get_lxc_status:
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
          - lxc_status
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - lxc_status: '${lxc_status}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_lxc_status:
        x: 154
        'y': 163
        navigate:
          049e7059-2da8-ea5b-9ff2-171519fe0420:
            targetId: 472e3847-855c-459e-81e7-8b7f660021c9
            port: SUCCESS
    results:
      SUCCESS:
        472e3847-855c-459e-81e7-8b7f660021c9:
          x: 432
          'y': 158.5
