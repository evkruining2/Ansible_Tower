namespace: pe_test_flows.nodes
flow:
  name: create_connection
  inputs:
    - node: pupnode1.museumhof.net
  workflow:
    - create_connection:
        do:
          io.cloudslang.puppet.puppet_enterprise.nodes.create_connection:
            - PuppetEnterpriseURL: "${get_sp('PuppetMasterURL')}"
            - PuppetUsername: "${get_sp('PuppetUsername')}"
            - PuppetPassword: "${get_sp('pvePassword')}"
            - TrustAllRoots: "${get_sp('TrustAllRoots')}"
            - HostnameVerify: "${get_sp('HostnameVerify')}"
            - certname: '${node}'
            - type: ssh
            - port: '22'
            - user: root
            - password:
                value: password
                sensitive: true
        publish:
          - connection_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - connection_id: '${connection_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_connection:
        x: 164
        'y': 149.5
        navigate:
          3ca379ac-2103-3061-cbd1-8ae9f8de2083:
            targetId: e189aa69-f912-67cd-f1c6-988a50142faa
            port: SUCCESS
    results:
      SUCCESS:
        e189aa69-f912-67cd-f1c6-988a50142faa:
          x: 385
          'y': 143
