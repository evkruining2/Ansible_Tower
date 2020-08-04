namespace: pe_test_flows.nodes.environments
flow:
  name: add_environment
  inputs:
    - envname: arie
  workflow:
    - add_environment:
        do:
          io.cloudslang.puppet.puppet_enterprise.environments.add_environment:
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
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      add_environment:
        x: 114
        'y': 117
        navigate:
          a4dfa80c-d7d3-56c4-f7ce-1f3a16cafa48:
            targetId: dc742988-dcc4-f8e0-32db-6171c4746f62
            port: SUCCESS
    results:
      SUCCESS:
        dc742988-dcc4-f8e0-32db-6171c4746f62:
          x: 418
          'y': 132
