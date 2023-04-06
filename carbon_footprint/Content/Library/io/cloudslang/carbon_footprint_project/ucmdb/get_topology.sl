namespace: io.cloudslang.carbon_footprint_project.ucmdb
flow:
  name: get_topology
  inputs:
    - ucmdb_api: 'https://optic.advantageinc.org:443/ucmdb-server/rest-api/topology'
    - topology: DCOE_ESG_AWS
  workflow:
    - get_token:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.get_token: []
        publish:
          - token
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: on_failure
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${ucmdb_api}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'Authorization: Bearer '+token}"
            - body: '${topology}'
            - content_type: application/json
        publish:
          - ucmdbids: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ucmdbIds: '${ucmdbids}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_token:
        x: 120
        'y': 80
      http_client_post:
        x: 356
        'y': 74
        navigate:
          3287d4e7-2aca-cf2e-367d-e5d7dabc7bb4:
            targetId: ff7282ef-2d07-0b54-afcc-e1c141e7cb02
            port: SUCCESS
    results:
      SUCCESS:
        ff7282ef-2d07-0b54-afcc-e1c141e7cb02:
          x: 461
          'y': 222

