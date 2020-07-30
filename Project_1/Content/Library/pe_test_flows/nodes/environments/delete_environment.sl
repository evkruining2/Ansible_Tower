namespace: pe_test_flows.nodes.environments
flow:
  name: delete_environment
  inputs:
    - envname: arie
  workflow:
    - delete_environment:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.environments.delete_environment:
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
      delete_environment:
        x: 153
        'y': 114.5
        navigate:
          13dfc212-3c8e-7240-0a44-3bc2d6c98d3c:
            targetId: d9f40c03-abfa-4055-1219-1094c5933374
            port: SUCCESS
    results:
      SUCCESS:
        d9f40c03-abfa-4055-1219-1094c5933374:
          x: 368
          'y': 110
