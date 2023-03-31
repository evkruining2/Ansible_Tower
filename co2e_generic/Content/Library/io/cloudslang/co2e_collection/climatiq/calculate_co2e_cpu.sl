########################################################################################################################
#!!
#! @input provider: aws or azure
#! @input cpu_count: amount of cpu's
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.climatiq
flow:
  name: calculate_co2e_cpu
  inputs:
    - climatiq_url: "${get_sp('io.cloudslang.co2e_collection.climatiq_url')}"
    - climatiq_token: "${get_sp('io.cloudslang.co2e_collection.climatiq_token')}"
    - provider: aws
    - region: eu_west_1
    - cpu_count: '24'
    - cpu_load: '0.8'
  workflow:
    - climatiq_io_get_cpu:
        worker_group:
          value: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${climatiq_url+'/compute/'+provider+'/cpu'}"
            - proxy_host: "${get_sp('io.cloudslang.co2e_collection.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.co2e_collection.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.co2e_collection.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.co2e_collection.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
            - headers: "${'Authorization: Bearer '+climatiq_token}"
            - body: "${'{'+\\\n'\"cpu_count\": '+cpu_count+','+\\\n'\"region\": \"'+region+'\",'+\\\n'\"cpu_load\": '+cpu_load+','+\\\n'\"duration\": 24,'+\\\n'\"duration_unit\": \"h\"'+\\\n'}'}"
            - worker_group: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_extract_co2e
          - FAILURE: on_failure
    - json_path_extract_co2e:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.co2e
        publish:
          - co2e: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - co2e: '${co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      climatiq_io_get_cpu:
        x: 80
        'y': 80
      json_path_extract_co2e:
        x: 280
        'y': 80
        navigate:
          bc1c16a8-9698-c49e-f025-5b5febbe9128:
            targetId: 9cf1a507-2d60-db49-5d3c-a6c78597df86
            port: SUCCESS
    results:
      SUCCESS:
        9cf1a507-2d60-db49-5d3c-a6c78597df86:
          x: 480
          'y': 80
