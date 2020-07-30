namespace: pe_test_flows
flow:
  name: get_users
  inputs:
    - peurl: 'https://pemaster.museumhof.net'
    - peuser: admin
  workflow:
    - get_users:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.get_users:
            - PuppetEnterpriseURL: '${peurl}'
            - PuppetUsername: '${peuser}'
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_users
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pe_users: '${pe_users}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_users:
        x: 122
        'y': 141
        navigate:
          02f62070-c0f8-d63f-4fef-c863fdf95c06:
            targetId: 1bfd9fcb-5b3f-03f3-41fd-6423b5417c11
            port: SUCCESS
    results:
      SUCCESS:
        1bfd9fcb-5b3f-03f3-41fd-6423b5417c11:
          x: 298
          'y': 104
