namespace: pe_test_flows.tasks
flow:
  name: sign_node_cert
  workflow:
    - sign_node_certificate:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.tasks.sign_node_certificate:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: pupnode1.museumhof.net
        publish:
          - job_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - job_id: '${job_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sign_node_certificate:
        x: 122
        'y': 190.5
        navigate:
          f3ca6a06-277b-c09e-69b9-e92dfa337aa8:
            targetId: c1736690-ad92-e917-edd1-f38acc4c0a63
            port: SUCCESS
    results:
      SUCCESS:
        c1736690-ad92-e917-edd1-f38acc4c0a63:
          x: 337
          'y': 178
