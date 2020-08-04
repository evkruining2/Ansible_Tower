namespace: pe_test_flows.jobs
flow:
  name: get_job_status
  inputs:
    - job_number: '36'
  workflow:
    - get_job_status:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.jobs.get_job_status:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - job_number: '${job_number}'
        publish:
          - job_status
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - job_status: '${job_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_job_status:
        x: 122
        'y': 122.5
        navigate:
          13d0a903-21b4-17ff-0cb1-505aae428115:
            targetId: bfee2e0f-19c6-a797-3ea3-3e3ebbcdc3dd
            port: SUCCESS
    results:
      SUCCESS:
        bfee2e0f-19c6-a797-3ea3-3e3ebbcdc3dd:
          x: 354
          'y': 99
