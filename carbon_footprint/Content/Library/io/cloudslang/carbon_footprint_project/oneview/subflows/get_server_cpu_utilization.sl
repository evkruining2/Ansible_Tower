namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: get_server_cpu_utilization
  inputs:
    - oneview_url: 'https://synergy.advantageinc.org'
    - server_uuid: 31323250-3933-4753-4832-333554543632
    - token: token
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${oneview_url+'/rest/server-hardware/'+server_uuid+'/utilization?fields=CpuUtilization&view=native'}"
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
          - cpu_utilization: "${return_result.partition(',')[2].strip(']')}"
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
    - cpu_utilization: '${cpu_utilization}'
    - date_of_sample: '${date_of_sample}'
    - epoch: '${epoch}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      convert_epoch_time_1:
        x: 374
        'y': 275
        navigate:
          d06d8737-242b-d7a2-e776-d43b237e87fc:
            targetId: 3f7b896c-acf5-b665-7590-37502c8985a6
            port: SUCCESS
      http_client_get:
        x: 141
        'y': 94
      get_latest_sample:
        x: 146
        'y': 275
    results:
      SUCCESS:
        3f7b896c-acf5-b665-7590-37502c8985a6:
          x: 369
          'y': 94

