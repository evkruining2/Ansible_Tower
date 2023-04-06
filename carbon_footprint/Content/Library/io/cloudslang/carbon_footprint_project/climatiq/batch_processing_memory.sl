namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: batch_processing_memory
  inputs:
    - climatiq_url: 'https://beta3.api.climatiq.io'
    - climatiq_token: Y3Q5BATS8TM2ARKBB18Y8MN95HX1
    - provider: gcp
    - memory: '128'
    - data_unit: GB
    - trust_all_roots:
        default: 'true'
        required: false
    - hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - http_client_get:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${climatiq_url+'/compute'}"
            - proxy_host: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_port')}"
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${hostname_verifier}'
            - headers: "${'Authorization: Bearer '+climatiq_token}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_provider_cpu_regions
          - FAILURE: on_failure
    - get_provider_cpu_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: "${'$.cloud_providers.'+provider+'.memory_regions'}"
        publish:
          - memory_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
          - new_string: '['
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${memory_regions}'
            - separator: ','
        publish:
          - location: '${result_string}'
        navigate:
          - HAS_MORE: append
          - NO_MORE: append_1
          - FAILURE: on_failure
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${new_string}'
            - text: "${'{'+\\\n'    \"region\": \"'+location+'\",'+\\\n'    \"data\": '+memory+','+\\\n'    \"data_unit\": \"'+data_unit+'\",'+\\\n'    \"duration\": 24,'+\\\n'    \"duration_unit\": \"h\"'+\\\n'    },'+\\\n''}"
        publish:
          - new_string
        navigate:
          - SUCCESS: list_iterator
    - append_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${new_string.strip(',')}"
            - text: ']'
        publish:
          - json_body: '${new_string}'
        navigate:
          - SUCCESS: climatiq_io_get_cpu
    - climatiq_io_get_cpu:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${climatiq_url+'/compute/'+provider+'/memory/batch'}"
            - proxy_host: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_port')}"
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${hostname_verifier}'
            - headers: "${'Authorization: Bearer '+climatiq_token}"
            - body: '${json_body}'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $..id
        publish:
          - ids: "${return_result.strip('[').strip(']')}"
          - list: "${'region,co2e'+'\\r\\n'}"
        navigate:
          - SUCCESS: list_iterator_1
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: "${'$..results[?(@.emission_factor.id=='+id+')].co2e'}"
        publish:
          - co2e: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: append_2
          - FAILURE: on_failure
    - list_iterator_1:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${ids}'
        publish:
          - id: '${result_string}'
        navigate:
          - HAS_MORE: json_path_query_1
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - append_2:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${list}'
            - text: "${id.strip('\"')+','+co2e+'\\r\\n'}"
        publish:
          - list: '${new_string}'
        navigate:
          - SUCCESS: list_iterator_1
  outputs:
    - co2e_results: '${list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_iterator_1:
        x: 440
        'y': 240
        navigate:
          245ed19b-5dbf-099c-6b91-71dbeeeb16d1:
            targetId: 23f6eac0-1314-f587-f91e-294328903d0a
            port: NO_MORE
      get_provider_cpu_regions:
        x: 40
        'y': 240
      json_path_query:
        x: 440
        'y': 40
      append_1:
        x: 240
        'y': 240
      append_2:
        x: 640
        'y': 40
      list_iterator:
        x: 40
        'y': 400
      json_path_query_1:
        x: 640
        'y': 240
      http_client_get:
        x: 40
        'y': 80
      append:
        x: 240
        'y': 400
      climatiq_io_get_cpu:
        x: 240
        'y': 40
    results:
      SUCCESS:
        23f6eac0-1314-f587-f91e-294328903d0a:
          x: 440
          'y': 440
