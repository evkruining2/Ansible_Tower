namespace: pve_test_flows
flow:
  name: create_vm_from_template
  inputs:
    - node: pve
    - cloneid: '100'
    - full:
        required: false
    - name:
        required: false
    - pool:
        required: false
    - storage:
        required: false
    - target:
        required: false
  workflow:
    - create_vm_from_template:
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.create_vm_from_template:
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
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_vm_from_template:
        x: 148
        'y': 159.5
        navigate:
          2f6e9c20-fca0-41be-e0be-2cf3277b3737:
            targetId: a749e56c-bbcf-2c4c-e959-145474e0a22c
            port: SUCCESS
    results:
      SUCCESS:
        a749e56c-bbcf-2c4c-e959-145474e0a22c:
          x: 366
          'y': 133
