namespace: pe_test_flows.nodes.groups
flow:
  name: create_group
  inputs:
    - name: arie
    - parent: c54bc74a-0f3f-414f-92dc-e8f44b5c22a8
  workflow:
    - create_group:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.groups.create_group:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - name: '${name}'
            - parent: '${parent}'
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
      create_group:
        x: 144
        'y': 149.5
        navigate:
          7d51caa2-316f-e312-d898-99c7cc5a2c3b:
            targetId: 94b1fe84-2d49-72ae-2473-abf5c034a39f
            port: SUCCESS
    results:
      SUCCESS:
        94b1fe84-2d49-72ae-2473-abf5c034a39f:
          x: 335
          'y': 140
