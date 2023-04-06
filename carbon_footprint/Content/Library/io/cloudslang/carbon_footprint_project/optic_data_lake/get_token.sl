namespace: io.cloudslang.carbon_footprint_project.optic_data_lake
flow:
  name: get_token
  inputs:
    - odl_url: 'https://optic.advantageinc.org/idm-service/v3.0/tokens'
    - username: carbon_int
    - password:
        default: MFS0ftware#
        sensitive: true
    - tenantname: Provider
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${odl_url}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - body: "${'{'+\\\n'  \"passwordCredentials\" : {'+\\\n'    \"username\" : \"'+username+'\",'+\\\n'    \"password\" : \"'+password+'\"'+\\\n'  },'+\\\n'  \"tenantName\" : \"'+tenantname+'\"'+\\\n'}'}"
            - content_type: application/json
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.token.id
        publish:
          - token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token: '${token}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_post:
        x: 160
        'y': 80
      json_path_query:
        x: 360
        'y': 80
        navigate:
          ac72ba2a-53a1-6565-349c-3970a62d13c4:
            targetId: 313290e2-e3ff-f8f6-aa5a-9f330f6f253a
            port: SUCCESS
    results:
      SUCCESS:
        313290e2-e3ff-f8f6-aa5a-9f330f6f253a:
          x: 560
          'y': 160

