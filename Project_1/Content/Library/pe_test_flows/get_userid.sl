namespace: pe_test_flows
flow:
  name: get_userid
  inputs:
    - peurl: 'https://pemaster.museumhof.net'
    - login: admin
  workflow:
    - get_userid:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.get_userid:
            - PuppetEnterpriseURL: '${peurl}'
            - PuppetUsername: admin
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - login: '${login}'
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
      get_userid:
        x: 115
        'y': 80
        navigate:
          d1b3e237-91c0-08eb-2d00-0dc37472b1ad:
            targetId: cbef883a-c595-02a8-25cd-b24df1f71aeb
            port: SUCCESS
    results:
      SUCCESS:
        cbef883a-c595-02a8-25cd-b24df1f71aeb:
          x: 325
          'y': 68
