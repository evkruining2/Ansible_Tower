namespace: pe_test_flows.tasks
flow:
  name: pe_bootstrap
  inputs:
    - node: pupnode1.museumhof.net
  workflow:
    - pe_bootstrap:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.tasks.pe_bootstrap:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: '${node}'
        publish:
          - job_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - job_id: '${job_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      pe_bootstrap:
        x: 128
        'y': 137.5
        navigate:
          ffe705c8-9735-0e5d-d36a-3acee2611050:
            targetId: bc3dafe8-d503-8c5c-6008-5aba3894e830
            port: SUCCESS
    results:
      SUCCESS:
        bc3dafe8-d503-8c5c-6008-5aba3894e830:
          x: 345
          'y': 117
