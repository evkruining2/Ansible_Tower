namespace: pve_test_flows
flow:
  name: get_nodes
  inputs:
    - pveURL: 'https://pve.example.com:8006'
    - pveUsername: root@pam
    - pvePassword:
        default: opsware
        sensitive: true
    - TrustAllRoots: 'true'
    - HostnameVerify: allow_all
  workflow:
    - get_ticket:
        do:
          io.cloudslang.proxmox.pve.access.get_ticket:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pveTicket
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_nodes
    - get_nodes:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: "${'Cookie:PVEAuthCookie='+pveTicket}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query_1
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: '$.data[*].node'
        publish:
          - nodes: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pveNodes: '${nodes}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_ticket:
        x: 133
        'y': 196
      get_nodes:
        x: 331
        'y': 204
      json_path_query_1:
        x: 511
        'y': 201
        navigate:
          561f1969-8083-9a27-c5d6-4fcbe2367e70:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 673
          'y': 189
