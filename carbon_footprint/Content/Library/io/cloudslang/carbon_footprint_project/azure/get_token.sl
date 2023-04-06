namespace: io.cloudslang.carbon_footprint_project.azure
flow:
  name: get_token
  inputs:
    - azure_auth_url: 'https://login.microsoftonline.com'
    - tenant_id: 6002e264-31f7-43d3-a51e-9ed1ba9ca689
    - client_id: d25804a6-0404-488c-a0f9-40c1c4aea511
    - client_secret: qmi8Q~jB6r9nzC-iIgGCXyx7PTgUQNHoJd4Nxbq~
    - scope: 'https://management.azure.com/.default'
    - grant_type: client_credentials
    - worker_group:
        required: false
    - trust_all_roots:
        required: false
    - x_509_hostname_verifier:
        required: false
  workflow:
    - url_encoder:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${scope}'
        publish:
          - scope: '${result}'
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: on_failure
    - http_client_post:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${azure_auth_url+'/'+tenant_id+'/oauth2/v2.0/token'}"
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - body: "${'client_id='+client_id+'&scope='+scope+'&client_secret='+client_secret+'&grant_type='+grant_type}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.access_token
        publish:
          - token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - azure_token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      url_encoder:
        x: 80
        'y': 80
      http_client_post:
        x: 280
        'y': 80
      json_path_query:
        x: 480
        'y': 80
        navigate:
          2d82319f-b9e7-6bb9-f8a9-fdb64020ffca:
            targetId: 5b29e953-77f0-1365-a664-5b0f7c907e1d
            port: SUCCESS
    results:
      SUCCESS:
        5b29e953-77f0-1365-a664-5b0f7c907e1d:
          x: 640
          'y': 80
