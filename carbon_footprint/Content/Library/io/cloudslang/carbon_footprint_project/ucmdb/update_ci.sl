namespace: io.cloudslang.carbon_footprint_project.ucmdb
flow:
  name: update_ci
  inputs:
    - ucmdb_url: 'https://optic.advantageinc.org:443/ucmdb-server/rest-api/dataModel/ci/'
    - ucmdb_id: 4dece3251e736feab5bffd13006447e7
    - scope2: '0'
    - scope3: '0.05'
    - power_usage: '0'
    - region: ap_southeast_1
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - get_token:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.get_token: []
        publish:
          - token
        navigate:
          - SUCCESS: http_client_put
          - FAILURE: on_failure
    - http_client_put:
        do:
          io.cloudslang.base.http.http_client_put:
            - url: '${ucmdb_url}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+token}"
            - body: "${'[{'+\\\n'   \"ucmdbId\": \"'+ucmdb_id+'\",'+\\\n'   \"properties\": { '+\\\n'        \"dcoe_scope3_co2e\": '+scope3+','+\\\n'        \"dcoe_scope2_co2e\": '+scope2+','+\\\n'        \"dcoe_powerusage\": '+power_usage+','+\\\n'        \"region\": \"'+region+'\"'+\\\n'        }'+\\\n' }]'}"
            - content_type: application/json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 72
        'y': 83
      http_client_put:
        x: 266
        'y': 83
        navigate:
          ee78faff-67a2-0a14-74c1-bda781e61a7b:
            targetId: d20338f8-c8be-91b8-190e-adadb2d32cfb
            port: SUCCESS
    results:
      SUCCESS:
        d20338f8-c8be-91b8-190e-adadb2d32cfb:
          x: 460
          'y': 88

