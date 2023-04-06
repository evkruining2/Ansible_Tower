namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: get_server_details
  inputs:
    - oneview_url: 'https://synergy.advantageinc.org'
    - server_uuid: 31323250-3933-4753-4832-333554543632
  workflow:
    - get_oneview_token:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_oneview_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_get
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${oneview_url+'/rest/server-hardware/'+server_uuid}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: |-
                ${'''Content-Type: application/json
                X-Api-Version: 4200
                Auth: '''+token}
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - server_details: '${json_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_oneview_token:
        x: 112
        'y': 135
      http_client_get:
        x: 285
        'y': 162
        navigate:
          795fc50d-7c1e-74b6-82fd-72dd0a08dea0:
            targetId: 3f7b896c-acf5-b665-7590-37502c8985a6
            port: SUCCESS
    results:
      SUCCESS:
        3f7b896c-acf5-b665-7590-37502c8985a6:
          x: 435
          'y': 138
