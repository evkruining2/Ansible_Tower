namespace: pe_test_flows.nodes.environments
flow:
  name: delete_environment
  inputs:
    - envname: arie
  workflow:
    - delete_environment:
        do:
          io.cloudslang.puppet.puppet_enterprise.environments.delete_environment:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - environment: '${envname}'
        publish:
          - status_code
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_environment:
        x: 108
        'y': 108
        navigate:
          e6d72089-405e-e380-0892-38eb50a95522:
            targetId: d9f40c03-abfa-4055-1219-1094c5933374
            port: SUCCESS
    results:
      SUCCESS:
        d9f40c03-abfa-4055-1219-1094c5933374:
          x: 368
          'y': 110
