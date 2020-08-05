namespace: tests
flow:
  name: create_lxc_add_to_puppet
  workflow:
    - create_lxc_from_template:
        do:
          pve_test_flows.create_lxc_from_template:
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - containerpassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
        publish:
          - vmid
          - JobStatus
          - TaskStatus
          - ExitStatus
          - result
          - containerpassword
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - add_new_node_to_puppet:
        do:
          io.cloudslang.puppet.puppet_enterprise.samples.add_new_node_to_puppet:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - node: 192.168.2.88
            - password:
                value: "${get_sp('pvePassword')}"
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
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '90'
        navigate:
          - SUCCESS: add_new_node_to_puppet
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_new_node_to_puppet:
        x: 366
        'y': 145
        navigate:
          b87bd266-3155-0bb5-f417-70c0ca9e17ff:
            targetId: 24ff608c-353f-17b4-93b4-47441d5c1133
            port: SUCCESS
      create_lxc_from_template:
        x: 141
        'y': 75
      sleep:
        x: 143
        'y': 298
    results:
      SUCCESS:
        24ff608c-353f-17b4-93b4-47441d5c1133:
          x: 543
          'y': 230
