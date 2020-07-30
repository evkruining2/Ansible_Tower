namespace: pe_test_flows.nodes
flow:
  name: delete_node
  inputs:
    - Certname: pupnode1.museumhof.net
  workflow:
    - delete_connection:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.delete_connection:
            - PuppetEnterpriseURL: 'https://pemaster.museumhof.net'
            - PuppetUsername: admin
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - Certname: '${Certname}'
        publish:
          - result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result: '${result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_connection:
        x: 116
        'y': 152
        navigate:
          827369e2-262e-f90f-ec5b-e13d56007728:
            targetId: d6cb3fde-cb4e-e1f5-f51e-1f09232a7870
            port: SUCCESS
    results:
      SUCCESS:
        d6cb3fde-cb4e-e1f5-f51e-1f09232a7870:
          x: 327
          'y': 132
