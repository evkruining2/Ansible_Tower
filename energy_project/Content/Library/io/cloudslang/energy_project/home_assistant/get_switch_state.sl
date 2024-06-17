namespace: io.cloudslang.energy_project.home_assistant
flow:
  name: get_switch_state
  inputs:
    - ha_url: "${get_sp('easyenergy_project.ha_api_url')}"
    - switch_id: switch.hombli_smart_socket_socket_1
    - ha_token: "${get_sp('easyenergy_project.ha_token')}"
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ha_url+'/states/'+switch_id}"
            - headers: "${'Authorization: Bearer '+ha_token}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.state
        publish:
          - power_state: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - power_state: '${power_state}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_get:
        x: 80
        'y': 80
      json_path_query:
        x: 280
        'y': 80
        navigate:
          fa2c9e58-fd5b-4aaa-c37c-fbefec608618:
            targetId: 16f1aaaa-5aab-46d2-f188-c7ce7c777121
            port: SUCCESS
    results:
      SUCCESS:
        16f1aaaa-5aab-46d2-f188-c7ce7c777121:
          x: 480
          'y': 80
