namespace: pve_test_flows
flow:
  name: get_task_status
  inputs:
    - node: pve2
    - upid: 'UPID:pve2:000073D0:09101CCC:5EFFA400:qmsnapshot:108:root@pam:'
    - pveURL: 'https://pve2:8006'
    - pveUsername: root@pam
    - pvePassword:
        default: opsware
        sensitive: true
    - TrustAllRoots: 'true'
    - HostnameVerify: allow_all
  workflow:
    - get_task_status:
        do:
          io.cloudslang.proxmox.pve.nodes.tasks.get_task_status:
            - node: '${node}'
            - upid: '${upid}'
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword: '${pvePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - TaskStatus
          - ExitStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_task_status:
        x: 150.79998779296875
        'y': 178.8000030517578
        navigate:
          6494f554-ee34-3f5a-df26-ac73b2b3cb04:
            targetId: 06d8a696-d00b-cd7e-0f3f-c5fd72fb3707
            port: SUCCESS
    results:
      SUCCESS:
        06d8a696-d00b-cd7e-0f3f-c5fd72fb3707:
          x: 371
          'y': 215
