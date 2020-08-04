namespace: pe_test_flows.nodes.groups
flow:
  name: get_groupid_by_name
  inputs:
    - group_name: Testing
  workflow:
    - get_groupid_by_name:
        do:
          io.cloudslang.puppet.puppet_enterprise.groups.get_groupid_by_name:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - group_name: '${group_name}'
        publish:
          - group_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - group_id: '${group_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_groupid_by_name:
        x: 116
        'y': 123
        navigate:
          501e214b-9938-5801-3606-399247441d1b:
            targetId: ddddf809-4823-e195-abda-029771ecf67c
            port: SUCCESS
    results:
      SUCCESS:
        ddddf809-4823-e195-abda-029771ecf67c:
          x: 397
          'y': 129
