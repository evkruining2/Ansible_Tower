namespace: pe_test_flows.nodes
flow:
  name: install_agent_linux
  inputs:
    - host: pupnode1.museumhof.net
    - username: root
    - password: password
  workflow:
    - install_agent_linux:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.install_agent_linux:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_agent_linux:
        x: 163
        'y': 121.5
        navigate:
          7e7a9bc2-7cbc-fc26-44d6-4a62f3d45400:
            targetId: 3d8873c9-db79-861a-ded4-bb3e933299e4
            port: SUCCESS
    results:
      SUCCESS:
        3d8873c9-db79-861a-ded4-bb3e933299e4:
          x: 385
          'y': 114
