namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: aws_vm_instance
  inputs:
    - climatiq_url: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_url')}"
    - climatiq_token: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_token')}"
    - region: eu_west_1
    - instance: c3.8xlarge
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${climatiq_url}'
            - headers: "${'Authorization: Bearer '+climatiq_token}"
            - body: "${'{'+\\\n'\"region\": \"'+region+'\",'+\\\n'\"instance\": \"'+instance+'\",'+\\\n'\"duration\": 24,'+\\\n'\"duration_unit\": \"h\"'+\\\n'}'}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_extract_co2e
          - FAILURE: on_failure
    - json_path_extract_co2e:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.total_co2e
        publish:
          - total_co2e: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - total_co2e: '${total_co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 80
        'y': 80
      json_path_extract_co2e:
        x: 280
        'y': 80
        navigate:
          8b521afe-14cf-d008-d8ec-d5c5fd4816ca:
            targetId: 42fa9c5b-b02f-6be0-0a07-ee2671b4fd8c
            port: SUCCESS
    results:
      SUCCESS:
        42fa9c5b-b02f-6be0-0a07-ee2671b4fd8c:
          x: 480
          'y': 80
