namespace: pe_test_flows.nodes.environments
flow:
  name: get_environments
  workflow:
    - get_environments_1:
        do:
          io.cloudslang.puppet.puppet_enterprise.environments.get_environments:
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
      get_environments_1:
        x: 75
        'y': 92
        navigate:
          12289ffe-4743-ad18-3cfa-ae2c7077a0b3:
            targetId: 9dd2a1f9-2611-6b6e-8d9a-83db607b353b
            port: SUCCESS
    results:
      SUCCESS:
        9dd2a1f9-2611-6b6e-8d9a-83db607b353b:
          x: 271
          'y': 87
