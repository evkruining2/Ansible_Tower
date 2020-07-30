namespace: pe_test_flows.nodes.groups
flow:
  name: delete_group
  inputs:
    - group_id: 88a02402-c285-4a9c-bafa-36c8a172d28b
  workflow:
    - delete_group:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.groups.delete_group:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - group_id: '${group_id}'
        publish:
          - status_code
          - return_code
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
      delete_group:
        x: 162
        'y': 149.5
        navigate:
          17082d1b-0964-0797-cf8d-b83045abb545:
            targetId: 9999eb5d-0d23-5e69-7ab8-79edf2344243
            port: SUCCESS
    results:
      SUCCESS:
        9999eb5d-0d23-5e69-7ab8-79edf2344243:
          x: 411
          'y': 134
