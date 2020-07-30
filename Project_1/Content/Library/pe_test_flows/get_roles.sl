namespace: pe_test_flows
flow:
  name: get_roles
  workflow:
    - get_user_roles:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.get_user_roles:
            - PuppetEnterpriseURL: 'https://pemaster.museumhof.net'
            - PuppetUsername: admin
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_roles
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pe_roles: '${pe_roles}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_user_roles:
        x: 125
        'y': 151.5
        navigate:
          abaa41cb-8ff9-7438-3f4f-e743cd595826:
            targetId: 87153c4d-51dc-b38b-0484-870164161f98
            port: SUCCESS
    results:
      SUCCESS:
        87153c4d-51dc-b38b-0484-870164161f98:
          x: 357
          'y': 128
