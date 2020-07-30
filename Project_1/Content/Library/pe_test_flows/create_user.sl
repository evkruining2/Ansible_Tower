namespace: pe_test_flows
flow:
  name: create_user
  workflow:
    - create_user:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.create_user:
            - PuppetEnterpriseURL: 'https://pemaster.museumhof.net'
            - PuppetUsername: admin
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - login: arie5
            - password:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - email: arie3@example.com
            - display_name: Arie Gaatje
            - role_id: '1'
        publish:
          - user_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - user_id: '${user_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_user:
        x: 120
        'y': 110
        navigate:
          b67a6b99-1ea5-8f3c-124f-cab6417fe0b8:
            targetId: 0817599e-354e-f35d-f931-3e4fae7e96ab
            port: SUCCESS
    results:
      SUCCESS:
        0817599e-354e-f35d-f931-3e4fae7e96ab:
          x: 309
          'y': 104
