namespace: pve_test_flows.qemu
flow:
  name: create_and_start_vm_from_template
  inputs:
    - node: pve
    - cloneid: '401'
    - full:
        default: '1'
        required: false
    - name:
        default: ce2
        required: false
    - pool:
        required: false
    - storage:
        default: local-lvm
        required: false
    - target:
        required: false
  workflow:
    - create_and_start_vm_from_template:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.create_and_start_vm_from_template:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - cloneid: '${cloneid}'
            - storage: '${storage}'
            - name: '${name}'
            - pool: '${pool}'
            - target: '${target}'
            - full: '${full}'
        publish:
          - JobStatus
          - TaskStatus
          - ExitStatus
          - vmid
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${JobStatus}'
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
    - vmid: '${vmid}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_and_start_vm_from_template:
        x: 139
        'y': 139
        navigate:
          dacfafed-e184-b206-c76c-a30c2f854ab7:
            targetId: a749e56c-bbcf-2c4c-e959-145474e0a22c
            port: SUCCESS
    results:
      SUCCESS:
        a749e56c-bbcf-2c4c-e959-145474e0a22c:
          x: 366
          'y': 133
