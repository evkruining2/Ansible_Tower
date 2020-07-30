namespace: pe_test_flows.nodes.environments
flow:
  name: add_environment
  inputs:
    - envname: arie
  workflow:
    - add_environment:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.environments.add_environment:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - environment: '${envname}'
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_environment:
        x: 174
        'y': 147.5
        navigate:
          e2efdc38-aa74-086c-faa8-9cbf46995955:
            targetId: dc742988-dcc4-f8e0-32db-6171c4746f62
            port: SUCCESS
    results:
      SUCCESS:
        dc742988-dcc4-f8e0-32db-6171c4746f62:
          x: 418
          'y': 132
