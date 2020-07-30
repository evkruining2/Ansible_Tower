namespace: pe_test_flows.nodes
flow:
  name: get_connections
  workflow:
    - get_connections:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.get_connections:
            - PuppetEnterpriseURL: 'https://pemaster.museumhof.net'
            - PuppetUsername: admin
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_connections
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pe_connections: '${pe_connections}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_connections:
        x: 127
        'y': 165.5
        navigate:
          a9096dc1-001a-0dcf-59eb-598671b036bd:
            targetId: dde262dd-61ab-62b6-e82c-67dbd2eea461
            port: SUCCESS
    results:
      SUCCESS:
        dde262dd-61ab-62b6-e82c-67dbd2eea461:
          x: 329
          'y': 153
