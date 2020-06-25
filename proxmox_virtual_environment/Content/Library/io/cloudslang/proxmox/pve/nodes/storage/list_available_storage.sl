namespace: io.cloudslang.proxmox.pve.nodes.storage
flow:
  name: list_available_storage
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - node
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
          - pveToken
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_storage
    - get_storage:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/storage'}"
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
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: '$.data..[?(@.enabled==1)].storage'
        publish:
          - storage: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - storage: '${storage}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_ticket:
        x: 67
        'y': 84
      get_storage:
        x: 246
        'y': 87
      json_path_query:
        x: 417
        'y': 87
        navigate:
          0a266a5f-9d32-dc9a-f9b3-0a38c91c58c2:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 589
          'y': 88
