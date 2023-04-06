namespace: io.cloudslang.carbon_footprint_project.ucmdb
flow:
  name: get_ucmdbid
  inputs:
    - fqdn: esx21.advantageinc.org
    - topology: DCOE_ESG_ESX
  workflow:
    - get_topology:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.get_topology:
            - topology: '${topology}'
        publish:
          - ucmdbIds
        navigate:
          - SUCCESS: get_ucmdbid
          - FAILURE: on_failure
    - get_ucmdbid:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${ucmdbIds}'
            - json_path: "${'$.cis[?(@.properties.primary_dns_name== \"'+fqdn+'\")].ucmdbId'}"
        publish:
          - ucmdbid: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_global_id
          - FAILURE: on_failure
    - get_global_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${ucmdbIds}'
            - json_path: "${'$.cis[?(@.properties.primary_dns_name== \"'+fqdn+'\")].globalId'}"
        publish:
          - global_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ucmdbid: '${ucmdbid}'
    - global_id: '${global_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_topology:
        x: 68
        'y': 67
      get_ucmdbid:
        x: 69
        'y': 238
      get_global_id:
        x: 249
        'y': 240
        navigate:
          805dce39-09b3-9adb-23ee-1c028ef631a2:
            targetId: 6039541d-62fa-5c2a-398f-f77211f6586d
            port: SUCCESS
    results:
      SUCCESS:
        6039541d-62fa-5c2a-398f-f77211f6586d:
          x: 427
          'y': 247

