namespace: pe_test_flows
flow:
  name: delete_user
  inputs:
    - user_id: e362997a-5772-416a-8864-bee20db4b8a2
  workflow:
    - delete_user:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.delete_user:
            - PuppetEnterpriseURL: 'https://pemaster.museumhof.net'
            - PuppetUsername: admin
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - user_id: '${user_id}'
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
      delete_user:
        x: 157
        'y': 105
        navigate:
          885b052f-b4a0-a845-5bfe-e1c14378987a:
            targetId: fbf4706c-ca2c-3d82-ab5b-08c93791ae63
            port: SUCCESS
    results:
      SUCCESS:
        fbf4706c-ca2c-3d82-ab5b-08c93791ae63:
          x: 359
          'y': 91
