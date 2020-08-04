namespace: pe_test_flows.nodes.groups
flow:
  name: add_node_to_group
  inputs:
    - group_id: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
    - node: pemaster.museumhof.net
  workflow:
    - add_node_to_group:
        do:
          io.cloudslang.puppet.puppet_enterprise.groups.add_node_to_group:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - group_id: '${group_id}'
            - node: '${node}'
        publish:
          - json_output
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - json_output: '${json_output}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      add_node_to_group:
        x: 160
        'y': 145
        navigate:
          7a7b6cae-33fd-3bfe-a5cb-e2e564ebeee5:
            targetId: 31a00e87-f0c4-f223-acac-691d2d128603
            port: SUCCESS
    results:
      SUCCESS:
        31a00e87-f0c4-f223-acac-691d2d128603:
          x: 363
          'y': 130
