########################################################################################################################
#!!
#! @input tasmota_url: URL to which the call is made.
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.home_assistant
flow:
  name: get_switch_state
  inputs:
    - tasmota_url: 'http://tasmota1.museumhof.net/cm?cmnd=Power'
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${tasmota_url}'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.POWER
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
