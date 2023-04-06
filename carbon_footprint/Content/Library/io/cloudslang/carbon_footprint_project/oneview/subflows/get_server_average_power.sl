namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: get_server_average_power
  inputs:
    - oneview_url: 'https://synergy.advantageinc.org'
    - server_uuid:
        default: '2323'
        required: true
    - token:
        default: erer
        required: true
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${oneview_url+'/rest/server-hardware/'+server_uuid+'/utilization?fields=AveragePower&view=native'}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: |-
                ${'''Content-Type: application/json
                X-Api-Version: 4200
                Auth: '''+token}
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_latest_sample
          - FAILURE: on_failure
    - get_latest_sample:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: '$.metricList..metricSamples[0]'
        publish:
          - power_consumption: "${return_result.partition(',')[2].strip(']')}"
          - epoch: "${return_result.partition(',')[0].strip('[')}"
        navigate:
          - SUCCESS: convert_epoch_time_1
          - FAILURE: on_failure
    - convert_epoch_time_1:
        do:
          io.cloudslang.base.utils.convert_epoch_time:
            - epoch_time: '${epoch}'
            - time_zone: '(UTC+08:00) Asia/Singapore'
        publish:
          - date_of_sample: '${date_format}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - current_power_consumption: '${power_consumption}'
    - date_of_sample: '${date_of_sample}'
    - epoch: '${epoch}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 274
        'y': 102
      get_latest_sample:
        x: 270
        'y': 311
      convert_epoch_time_1:
        x: 440
        'y': 320
        navigate:
          4896ea28-f26b-d493-7380-49f9283e3a95:
            targetId: 3f7b896c-acf5-b665-7590-37502c8985a6
            port: SUCCESS
    results:
      SUCCESS:
        3f7b896c-acf5-b665-7590-37502c8985a6:
          x: 450
          'y': 105

