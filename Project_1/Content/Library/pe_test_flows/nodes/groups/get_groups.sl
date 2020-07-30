namespace: pe_test_flows.nodes.groups
flow:
  name: get_groups
  workflow:
    - get_groups:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.groups.get_groups:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_groups
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_groups:
        x: 112
        'y': 115.5
        navigate:
          9a4bed0e-a918-a4ef-fb8a-e657b04639eb:
            targetId: 12076494-2ca5-8fd5-a991-8dac81ef8443
            port: SUCCESS
    results:
      SUCCESS:
        12076494-2ca5-8fd5-a991-8dac81ef8443:
          x: 327
          'y': 87
