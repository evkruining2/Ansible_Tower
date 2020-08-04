namespace: pe_test_flows.tasks
flow:
  name: get_tasks
  workflow:
    - get_tasks:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.tasks.get_tasks:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_tasks
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pe_tasks: '${pe_tasks}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_tasks:
        x: 167
        'y': 210.5
        navigate:
          b179eb07-248d-6040-01d6-8e2904f8cc82:
            targetId: c9df440d-7e21-081c-8afe-8dffbeedcaa5
            port: SUCCESS
    results:
      SUCCESS:
        c9df440d-7e21-081c-8afe-8dffbeedcaa5:
          x: 397
          'y': 200
