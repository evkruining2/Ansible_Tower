namespace: pe_test_flows.nodes
flow:
  name: install_agent_windows
  workflow:
    - install_agent_windows:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.install_agent_windows:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - host: pupnode4.museumhof.net
            - username: administrator
            - password:
                value: admin@123
                sensitive: true
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - return_result
          - script_exit_code
          - stderr
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_agent_windows:
        x: 138
        'y': 104
        navigate:
          34743869-bac0-569d-384a-d4f6b4a51256:
            targetId: 5aacf409-c06e-bd9f-39e3-66fe1261d4bb
            port: SUCCESS
    results:
      SUCCESS:
        5aacf409-c06e-bd9f-39e3-66fe1261d4bb:
          x: 371
          'y': 81
