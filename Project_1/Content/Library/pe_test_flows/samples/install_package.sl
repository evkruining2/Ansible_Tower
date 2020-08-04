namespace: pe_test_flows.samples
flow:
  name: install_package
  workflow:
    - install_package_on_a_node:
        do:
          io.cloudslang.puppet.puppet_enterprise.samples.install_package_on_a_node:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - payload: "${'{'+\\\n'  \"environment\" : \"production\",'+\\\n'  \"task\" : \"package\",'+\\\n'  \"params\" : {'+\\\n'    \"action\" : \"install\",'+\\\n'    \"name\" : \"screen\"'+\\\n'  },'+\\\n'  \"scope\" : {'+\\\n'    \"nodes\" : [\"pupnode2.museumhof.net\",\"pupnode3.museumhof.net\"]'+\\\n'  }'+\\\n'}'}"
        publish:
          - job_number
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_package_on_a_node:
        x: 150
        'y': 114.5
        navigate:
          d9045a2c-7ce5-c9fb-0662-e09800a50e00:
            targetId: 0a2d99e0-aaa5-ccd4-a00b-fceceead40e0
            port: SUCCESS
    results:
      SUCCESS:
        0a2d99e0-aaa5-ccd4-a00b-fceceead40e0:
          x: 356
          'y': 113
