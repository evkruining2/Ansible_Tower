namespace: tests
flow:
  name: OO_User
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://rpacore3:8443/oo/rest/v2/executions/'+run_id+'/summary'}"
            - username: admin
            - password:
                value: Cloud@123
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $..triggeredBy
        publish:
          - UserID: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - UserID: '${UserID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 144
        'y': 205
      json_path_query:
        x: 356
        'y': 153
        navigate:
          2a8b1bae-b0c1-4a01-d796-dd0e58d22ba9:
            targetId: 768c9465-e935-3776-9966-7879022b978f
            port: SUCCESS
    results:
      SUCCESS:
        768c9465-e935-3776-9966-7879022b978f:
          x: 526
          'y': 238
