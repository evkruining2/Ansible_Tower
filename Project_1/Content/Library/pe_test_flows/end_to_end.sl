namespace: pe_test_flows
flow:
  name: end_to_end
  inputs:
    - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
    - PuppetUsername: "${get_sp('PuppetUsername')}"
    - PuppetPassword: "${get_sp('pvePassword')}"
    - node: pupnode3.museumhof.net
    - user: root
    - password: password
    - type:
        default: ssh
        required: false
    - port:
        default: '22'
        required: false
    - group_id: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
    - TrustAllRoots: 'true'
    - HostnameVerify: allow_all
    - environment:
        default: production
        required: false
    - duplicate:
        default: replace
        required: false
    - connect_timeout:
        default: '600'
        required: false
  workflow:
    - create_connection:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.create_connection:
            - PuppetEnterpriseURL: '${PuppetEnterpriseURL}'
            - PuppetUsername: '${PuppetUsername}'
            - PuppetPassword: '${PuppetPassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - certname: '${node}'
            - type: '${type}'
            - port: '${port}'
            - user: '${user}'
            - password:
                value: '${password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - duplicates: '${duplicate}'
        publish:
          - connection_id
          - PuppetUsername
          - TrustAllRoots
          - HostnameVerify
          - PuppetEnterpriseURL
          - PuppetPassword
        navigate:
          - SUCCESS: pe_bootstrap
          - FAILURE: on_failure
    - pe_bootstrap:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.tasks.pe_bootstrap:
            - PuppetEnterpriseURL: '${PuppetEnterpriseURL}'
            - PuppetUsername: '${PuppetUsername}'
            - PuppetPassword: '${PuppetPassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - node: '${node}'
            - environment: '${environment}'
        publish:
          - job_number
        navigate:
          - SUCCESS: get_job_status
          - FAILURE: on_failure
    - get_job_status:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.jobs.get_job_status:
            - PuppetEnterpriseURL: '${PuppetEnterpriseURL}'
            - PuppetUsername: '${PuppetUsername}'
            - PuppetPassword: '${PuppetPassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - job_number: '${job_number}'
        publish:
          - job_status
        navigate:
          - SUCCESS: still_running
          - FAILURE: on_failure
    - sign_node_certificate:
        do:
          io.cloudslang.puppet.puppet_enterprise.orchestrator.tasks.sign_node_certificate:
            - PuppetEnterpriseURL: '${PuppetEnterpriseURL}'
            - PuppetUsername: '${PuppetUsername}'
            - PuppetPassword: '${PuppetPassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - node: '${node}'
            - environment: '${environment}'
        publish:
          - job_id
        navigate:
          - SUCCESS: add_node_to_group_1
          - FAILURE: on_failure
    - is_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: finished
        navigate:
          - SUCCESS: sign_node_certificate
          - FAILURE: on_failure
    - still_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: is_finished
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '5'
        navigate:
          - SUCCESS: get_job_status
          - FAILURE: on_failure
    - add_node_to_group_1:
        do:
          io.cloudslang.puppet.puppet_enterprise.groups.add_node_to_group:
            - PuppetEnterpriseURL: '${PuppetEnterpriseURL}'
            - PuppetUsername: '${PuppetUsername}'
            - PuppetPassword: '${PuppetPassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - group_id: '${group_id}'
            - node: '${node}'
        publish:
          - json_output
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_connection:
        x: 57
        'y': 67
      pe_bootstrap:
        x: 284
        'y': 70
      is_finished:
        x: 285
        'y': 392
      still_running:
        x: 58
        'y': 396
      add_node_to_group_1:
        x: 493
        'y': 226
        navigate:
          444f2ee1-874a-5801-4e15-f6024d841549:
            targetId: bbc4737d-ec1e-87d2-ea8f-1a580568961a
            port: SUCCESS
      sleep:
        x: 58
        'y': 219
      sign_node_certificate:
        x: 488
        'y': 397
      get_job_status:
        x: 285
        'y': 216
    results:
      SUCCESS:
        bbc4737d-ec1e-87d2-ea8f-1a580568961a:
          x: 485
          'y': 74
