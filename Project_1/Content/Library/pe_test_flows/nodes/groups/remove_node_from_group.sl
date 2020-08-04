namespace: pe_test_flows.nodes.groups
flow:
  name: remove_node_from_group
  inputs:
    - group_id: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
    - node: pupnode4.museumhof.net
  workflow:
    - remove_node_from_group:
        do:
          io.cloudslang.puppet.puppet_enterprise.groups.remove_node_from_group:
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
      remove_node_from_group:
        x: 123
        'y': 140
        navigate:
          5798993c-0e4c-b0ca-27b8-5a6ff2746432:
            targetId: 69b192ce-de0b-f607-1b8c-fefcada9c5a8
            port: SUCCESS
    results:
      SUCCESS:
        69b192ce-de0b-f607-1b8c-fefcada9c5a8:
          x: 350
          'y': 122
