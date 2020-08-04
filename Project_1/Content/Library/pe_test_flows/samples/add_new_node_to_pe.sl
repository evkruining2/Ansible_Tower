namespace: pe_test_flows.samples
flow:
  name: add_new_node_to_pe
  inputs:
    - node: pupnode4.museumhof.net
  workflow:
    - add_new_node_to_puppet:
        do:
          io.cloudslang.puppet.puppet_enterprise.samples.add_new_node_to_puppet:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - group_id: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
            - node: '${node}'
            - type: winrm
            - port: '5985'
            - user: administrator
            - password:
                value: admin@123
                sensitive: true
        publish:
          - connection_id
          - job_number
          - job_status
          - signing_job_id
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_new_node_to_puppet:
        x: 116
        'y': 132.5
        navigate:
          89a095a1-2882-5eda-3ad8-3253cc563d36:
            targetId: c3a825c4-0fe3-b1b1-47c3-d3fe3d184786
            port: SUCCESS
    results:
      SUCCESS:
        c3a825c4-0fe3-b1b1-47c3-d3fe3d184786:
          x: 337
          'y': 117
