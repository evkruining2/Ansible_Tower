namespace: pve_test_flows
flow:
  name: create_lxc_from_template
  inputs:
    - pveURL: 'https://pve2:8006'
    - pveUsername: root@pam
    - pvePassword:
        default: opsware
        sensitive: true
    - TrustAllRoots: 'true'
    - HostnameVerify: allow_all
    - ostemplate: 'pve_backup:vztmpl/centos-7-default_20190926_amd64.tar.xz'
    - vmid: '995'
    - containerpassword:
        default: opsware
        sensitive: false
    - storage: local-fast
    - node: pve2
    - hostname: centos995
    - net0: 'name=eth0,bridge=vmbr0,ip=dhcp'
  workflow:
    - create_lxc_from_template:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.create_lxc_from_template:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - ostemplate: '${ostemplate}'
            - vmid: '${vmid}'
            - containerpassword: '${containerpassword}'
            - storage: '${storage}'
            - node: '${node}'
            - hostname: '${hostname}'
            - net0: '${net0}'
        publish:
          - JobStatus
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${JobStatus}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_lxc_from_template:
        x: 176
        'y': 176
        navigate:
          3e39a81b-3742-a310-18e0-b299a3c52cde:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 434
          'y': 139
