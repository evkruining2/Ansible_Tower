namespace: pve_test_flows
flow:
  name: version
  inputs:
    - pveURL: 'https://pve2.museumhof.net:8006'
    - pveUsername: root@pam
    - pvePassword: opsware
    - TrustAllRoots: 'true'
    - HostnameVerify: allow_all
  workflow:
    - get_ticket:
        do:
          io.cloudslang.proxmox.pve.access.get_ticket:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword: '${pvePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pveTicket
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_version
    - get_version:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/version'}"
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
            - json_path: $.data.version
        publish:
          - version: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pveVersion: '${version}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ticket:
        x: 45
        'y': 87
      get_version:
        x: 231
        'y': 82
      json_path_query_1:
        x: 426
        'y': 81
        navigate:
          62053a2d-7bd6-80f4-b941-89b039fe5718:
            targetId: 62d58777-7508-fc70-1b42-21d01def9eff
            port: SUCCESS
    results:
      SUCCESS:
        62d58777-7508-fc70-1b42-21d01def9eff:
          x: 593
          'y': 96
