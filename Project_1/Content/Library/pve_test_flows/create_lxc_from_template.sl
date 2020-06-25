namespace: pve_test_flows
flow:
  name: create_lxc_from_template
  inputs:
    - pveURL: "${get_sp('pveURL')}"
    - pveUsername: "${get_sp('pveUsername')}"
    - pvePassword:
        default: "${get_sp('pvePassword')}"
        sensitive: true
    - TrustAllRoots: "${get_sp('TrustAllRoots')}"
    - HostnameVerify: "${get_sp('HostnameVerify')}"
    - node: pve2
    - ostemplate: 'pve_backup:vztmpl/debian-10.0-standard_10.0-1_amd64.tar.gz'
    - containerpassword:
        default: opsware
        sensitive: true
    - memory:
        default: '1024'
        required: false
    - storage: local-fast
    - hostname:
        default: ctdeb
        required: false
    - nameserver:
        default: 192.168.2.20
        required: false
    - net0:
        default: 'name=eth0,bridge=vmbr0,ip=192.168.2.88/24,gw=192.168.2.1,firewall=0'
        required: false
    - net1:
        default: 'name=eth1,bridge=vmbr0,ip=dhcp,tag=1,firewall=0'
        required: false
    - net2:
        required: false
    - net3:
        required: false
  workflow:
    - generate_vmid:
        do:
          io.cloudslang.proxmox.pve.tools.generate_vmid:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - vmid
        navigate:
          - SUCCESS: create_lxc_from_template
          - FAILURE: on_failure
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
            - memory: '${memory}'
            - nameserver: '${nameserver}'
            - net0: '${net0}'
            - net1: '${net1}'
            - net2: '${net2}'
            - net3: '${net3}'
        publish:
          - JobStatus
          - TaskStatus
          - ExitStatus
        navigate:
          - SUCCESS: start_lxc
          - FAILURE: on_failure
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
    - vmid: '${vmid}'
    - JobStatus: '${JobStatus}'
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
    - result: '${result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_lxc_from_template:
        x: 204
        'y': 231
      generate_vmid:
        x: 62
        'y': 101
      start_lxc:
        x: 347
        'y': 189
        navigate:
          6c72d739-3c1c-0ddd-4260-abc20ad18807:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 377
          'y': 38
