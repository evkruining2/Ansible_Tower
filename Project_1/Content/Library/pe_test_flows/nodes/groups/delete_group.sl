namespace: pe_test_flows.nodes.groups
flow:
  name: delete_group
  inputs:
    - group_id: 88a02402-c285-4a9c-bafa-36c8a172d28b
  workflow:
    - delete_group:
        do:
          io.cloudslang.puppet.puppet_enterprise.groups.delete_group:
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
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_group:
        x: 106
        'y': 117
        navigate:
          209cbb6e-0f1b-2030-0908-77db1923c548:
            targetId: 9999eb5d-0d23-5e69-7ab8-79edf2344243
            port: SUCCESS
    results:
      SUCCESS:
        9999eb5d-0d23-5e69-7ab8-79edf2344243:
          x: 285
          'y': 115
