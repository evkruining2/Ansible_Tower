namespace: pe_test_flows.tasks
flow:
  name: get_task_details
  inputs:
    - PuppetEnterpriseTaskID: 'https://pemaster.museumhof.net:8143/orchestrator/v1/tasks/service/init'
  workflow:
    - get_task_details:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.tasks.get_task_details:
            - PuppetEnterpriseTaskId: '${PuppetEnterpriseTaskID}'
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_task_details
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pe_taks_details: '${pe_task_details}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_task_details:
        x: 138
        'y': 150.5
        navigate:
          c75a2159-80f5-be8c-6694-bc0d94a6561c:
            targetId: 9cbded42-f2bb-5585-d58f-e46cc935046a
            port: SUCCESS
    results:
      SUCCESS:
        9cbded42-f2bb-5585-d58f-e46cc935046a:
          x: 354
          'y': 155
