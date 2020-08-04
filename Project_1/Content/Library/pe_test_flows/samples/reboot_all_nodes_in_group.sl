namespace: pe_test_flows.samples
flow:
  name: reboot_all_nodes_in_group
  inputs:
    - grouo_id: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
  workflow:
    - reboot_all_nodes_in_a_group:
        do:
          io.cloudslang.puppet.puppet_enterprise.samples.reboot_all_nodes_in_a_group:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - group_id: '${grouo_id}'
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
      reboot_all_nodes_in_a_group:
        x: 153
        'y': 142.5
        navigate:
          af60b37c-5df8-0146-7b7b-e027cd25f8f9:
            targetId: a2afe490-848a-5719-d170-9e3f623a4703
            port: SUCCESS
    results:
      SUCCESS:
        a2afe490-848a-5719-d170-9e3f623a4703:
          x: 355
          'y': 120
