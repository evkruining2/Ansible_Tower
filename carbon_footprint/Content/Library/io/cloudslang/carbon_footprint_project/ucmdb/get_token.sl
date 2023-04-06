namespace: io.cloudslang.carbon_footprint_project.ucmdb
flow:
  name: get_token
  inputs:
    - ucmdb_url: 'https://optic.advantageinc.org:443/ucmdb-server/rest-api/authenticate'
    - username: stefan.brie
    - password:
        default: MFS0ftware%
        sensitive: true
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - get_auth_token:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${ucmdb_url}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - body: "${'{'+\\\n'    \"password\":\"'+password+'\",'+\\\n'    \"username\":\"'+username+'\",'+\\\n'    \"clientContext\": 1'+\\\n'}'}"
            - content_type: application/json
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.token
        publish:
          - token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token: '${token}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token:
        x: 80
        'y': 80
      json_path_query:
        x: 280
        'y': 80
        navigate:
          4cd6b627-4081-2055-08a4-2271267db30f:
            targetId: 916d89a3-1a40-7c65-5b24-d7ddf674354a
            port: SUCCESS
    results:
      SUCCESS:
        916d89a3-1a40-7c65-5b24-d7ddf674354a:
          x: 560
          'y': 160

