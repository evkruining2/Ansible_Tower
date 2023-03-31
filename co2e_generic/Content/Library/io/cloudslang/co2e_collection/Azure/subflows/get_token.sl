namespace: io.cloudslang.co2e_collection.Azure.subflows
flow:
  name: get_token
  inputs:
    - azure_auth_url: "${get_sp('io.cloudslang.co2e_collection.azure_auth_url')}"
    - tenant_id: "${get_sp('io.cloudslang.co2e_collection.azure_tenant_id')}"
    - client_id: "${get_sp('io.cloudslang.co2e_collection.azure_client_id')}"
    - client_secret: "${get_sp('io.cloudslang.co2e_collection.azure_client_secret')}"
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
            - proxy_host: "${get_sp('io.cloudslang.co2e_collection.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.co2e_collection.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.co2e_collection.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.co2e_collection.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
            - body: "${'client_id='+client_id+'&scope='+scope+'&client_secret='+client_secret+'&grant_type='+grant_type}"
            - content_type: application/x-www-form-urlencoded
            - worker_group: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
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
