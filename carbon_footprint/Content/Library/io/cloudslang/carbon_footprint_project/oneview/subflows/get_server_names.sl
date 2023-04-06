namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: get_server_names
  inputs:
    - oneview_url: 'https://synergy.advantageinc.org/rest/server-hardware?start=0&count=-1'
    - trust_all_roots:
        default: 'true'
        required: false
    - x_508_hostname_verfier:
        default: allow_all
        required: false
  workflow:
    - get_oneview_token:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_oneview_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_get
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${oneview_url}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_508_hostname_verfier}'
            - headers: |-
                ${'''Content-Type: application/json
                X-Api-Version: 4200
                Auth: '''+token}
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.members..serverName
        publish:
          - server_names: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - server_names: '${server_names}'
    - token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_oneview_token:
        x: 87
        'y': 140
      http_client_get:
        x: 221
        'y': 178
      json_path_query:
        x: 392
        'y': 142
        navigate:
          bbd93363-4787-a0cb-df90-1d387be807de:
            targetId: dbb96715-3738-9373-038b-0ba448d948b8
            port: SUCCESS
    results:
      SUCCESS:
        dbb96715-3738-9373-038b-0ba448d948b8:
          x: 541
          'y': 171

