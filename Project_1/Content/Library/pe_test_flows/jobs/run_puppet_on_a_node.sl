namespace: pe_test_flows.jobs
flow:
  name: run_puppet_on_a_node
  inputs:
    - node: pupnode1.museumhof.net
  workflow:
    - puppet_agent_run_on_a_node:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.jobs.puppet_agent_run_on_a_node:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: 'true'
            - HostnameVerify: allow_all
            - node: '${node}'
        publish:
          - job_number
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - job_number: '${job_number}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      puppet_agent_run_on_a_node:
        x: 115
        'y': 106
        navigate:
          5267ac31-c24d-729d-5dd5-500d68e96e1a:
            targetId: 428889be-06af-eb51-6ae3-70aebfc7a523
            port: SUCCESS
    results:
      SUCCESS:
        428889be-06af-eb51-6ae3-70aebfc7a523:
          x: 321
          'y': 105
