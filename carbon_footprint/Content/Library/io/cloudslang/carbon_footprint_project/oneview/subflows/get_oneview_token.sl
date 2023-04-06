namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: get_oneview_token
  inputs:
    - oneview_url: 'https://synergy.advantageinc.org/rest/login-sessions'
    - username: administrator
    - password:
        default: 'MFS0ftware%'
        sensitive: true
    - trust_all_roots: 'true'
    - x_509_hostname_verifier: allow_all
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${oneview_url}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: 'X-Api-Version:4200'
            - body: "${'{'+\\\n'    \"password\":\"'+password+'\",'+\\\n'    \"userName\":\"'+username+'\",'+\\\n'    \"loginMsgAck\": \"true\"'+\\\n'}'}"
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
            - json_path: $.sessionID
        publish:
          - token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 81
        'y': 89
      json_path_query:
        x: 249
        'y': 88
        navigate:
          e17d6398-270e-8584-d8ed-6d7e08323eef:
            targetId: f6fc9f69-79f4-9362-4fde-0e4846d2bd33
            port: SUCCESS
    results:
      SUCCESS:
        f6fc9f69-79f4-9362-4fde-0e4846d2bd33:
          x: 391
          'y': 91
