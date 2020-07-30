namespace: pe_test_flows.nodes.environments
flow:
  name: get_environments
  workflow:
    - get_environments:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.environments.get_environments:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_environments
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_environments:
        x: 129
        'y': 150.5
        navigate:
          a065fb19-79f4-8a92-1e72-70cd42db22da:
            targetId: 9dd2a1f9-2611-6b6e-8d9a-83db607b353b
            port: SUCCESS
    results:
      SUCCESS:
        9dd2a1f9-2611-6b6e-8d9a-83db607b353b:
          x: 348
          'y': 143
