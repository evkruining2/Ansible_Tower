namespace: pe_test_flows.jobs
flow:
  name: puppet_agent_run_on_a_group
  inputs:
    - group_id: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
  workflow:
    - puppet_agent_run_on_a_group:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.jobs.puppet_agent_run_on_a_group:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: 'true'
            - HostnameVerify: allow_all
            - group_id: '${group_id}'
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
      puppet_agent_run_on_a_group:
        x: 140
        'y': 134.5
        navigate:
          13d50c61-6bfa-032c-d632-80938f607092:
            targetId: 0f942119-774a-5880-da0f-a11cd8041684
            port: SUCCESS
    results:
      SUCCESS:
        0f942119-774a-5880-da0f-a11cd8041684:
          x: 372
          'y': 120
