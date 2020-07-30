namespace: pe_test_flows
flow:
  name: get_token
  inputs:
    - peurl: 'https://pemaster.museumhof.net'
    - peuser: admin
    - pepassword: "${get_sp('pvePassword')}"
  workflow:
    - get_auth_token:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.get_auth_token:
            - PuppetEnterpriseURL: '${peurl}'
            - PuppetUsername: '${peuser}'
            - PuppetPassword: '${pepassword}'
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
        publish:
          - pe_token
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pe_token: '${pe_token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_auth_token:
        x: 134
        'y': 188.5
        navigate:
          d516317a-f15d-9a10-dd66-b27151e56e65:
            targetId: 804dcbe5-16c6-898d-1f8d-86a32a4ea86a
            port: SUCCESS
    results:
      SUCCESS:
        804dcbe5-16c6-898d-1f8d-86a32a4ea86a:
          x: 354
          'y': 174
