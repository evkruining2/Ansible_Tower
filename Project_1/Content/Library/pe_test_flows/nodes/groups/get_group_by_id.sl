namespace: pe_test_flows.nodes.groups
flow:
  name: get_group_by_id
  inputs:
    - group_id: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
  workflow:
    - get_group_by_id:
        do:
          io.cloudslang.puppet.puppet_enterprise.groups.get_group_by_id:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - group_id: '${group_id}'
        publish:
          - pe_group
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_group_by_id:
        x: 116
        'y': 136
        navigate:
          38273302-9771-e3f5-6498-c55e26a66543:
            targetId: 57f21b50-ad9c-147e-e503-58fb5d3c95ed
            port: SUCCESS
    results:
      SUCCESS:
        57f21b50-ad9c-147e-e503-58fb5d3c95ed:
          x: 326
          'y': 123
