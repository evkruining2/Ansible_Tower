namespace: pe_test_flows.nodes.groups
flow:
  name: get_group_by_id
  inputs:
    - group_id: 2117bb1c-c74d-4090-bf41-340d92b3b675
  workflow:
    - get_group_by_id:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.groups.get_group_by_id:
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
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_group_by_id:
        x: 131
        'y': 131.5
        navigate:
          7058171b-327b-ecdb-3946-1c5fe87d9b4d:
            targetId: 57f21b50-ad9c-147e-e503-58fb5d3c95ed
            port: SUCCESS
    results:
      SUCCESS:
        57f21b50-ad9c-147e-e503-58fb5d3c95ed:
          x: 326
          'y': 123
