namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: get_aws_regions
  inputs:
    - climatiq_url: 'https://beta3.api.climatiq.io/compute'
    - climatiq_token: Y3Q5BATS8TM2ARKBB18Y8MN95HX1
  workflow:
    - http_client_get:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${climatiq_url}'
            - proxy_host: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_port')}"
            - headers: "${'Authorization: Bearer '+climatiq_token}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_aws_cpu_regions
          - FAILURE: on_failure
    - get_aws_cpu_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.aws.cpu_regions
        publish:
          - aws_cpu_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_aws_memory_regions
          - FAILURE: on_failure
    - get_aws_memory_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.aws.memory_regions
        publish:
          - aws_memory_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_aws_cpu_regions:
        x: 160
        'y': 240
      http_client_get:
        x: 123
        'y': 81
      get_aws_memory_regions:
        x: 296
        'y': 332
        navigate:
          6a4d7a84-c428-77c5-3a6e-ff9c9dcb59f2:
            targetId: b6371ffd-6c7c-7b71-d82a-b534a36aaee3
            port: SUCCESS
    results:
      SUCCESS:
        b6371ffd-6c7c-7b71-d82a-b534a36aaee3:
          x: 400
          'y': 160
