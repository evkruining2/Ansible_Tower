namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: get_server_uuid_from_name
  inputs:
    - oneview_url: 'https://synergy.advantageinc.org/rest/server-hardware?start=0&count=-1'
    - token
    - serverName
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - get_servers:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${oneview_url}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: |-
                ${'''Content-Type: application/json
                X-Api-Version: 4200
                Auth: '''+token}
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: "${'$..members[?(@.serverName == \"'+serverName+'\")].uuid'}"
        publish:
          - uuid: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - uuid: '${uuid}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 240
        'y': 80
        navigate:
          02fdd9a9-45f9-e289-1197-cee2df1b972d:
            targetId: 1599296f-7170-d20a-eb74-13f461594334
            port: SUCCESS
      get_servers:
        x: 80
        'y': 80
    results:
      SUCCESS:
        1599296f-7170-d20a-eb74-13f461594334:
          x: 400
          'y': 80
