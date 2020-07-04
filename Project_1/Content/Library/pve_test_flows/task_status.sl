namespace: pve_test_flows
flow:
  name: task_status
  inputs:
    - node: pve2
    - upid: 'UPID:pve2:00006322:08D12D41:5EFF02E2:vzdump:105:root@pam:'
  workflow:
    - get_task_status:
        do:
          io.cloudslang.proxmox.pve.nodes.tasks.get_task_status:
            - pveURL: "${get_sp('pveURL')}"
            - pveUsername: "${get_sp('pveUsername')}"
            - pvePassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
            - upid: '${upid}'
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
        x: 144
        'y': 173
        navigate:
          aed803fa-1a73-6c10-dcca-663cbe09e908:
            targetId: 4c740c67-0415-8576-e42a-0a8b9334af98
            port: SUCCESS
    results:
      SUCCESS:
        4c740c67-0415-8576-e42a-0a8b9334af98:
          x: 429
          'y': 165.5
