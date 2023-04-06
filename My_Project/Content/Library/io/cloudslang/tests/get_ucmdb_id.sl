namespace: io.cloudslang.tests
flow:
  name: get_ucmdb_id
  inputs:
    - azure_url: 'https://management.azure.com/subscriptions'
    - subscription_id: 4d08f192-8c63-49fa-a461-5cdd32ce42dc
    - api_version: '2022-11-01'
  workflow:
    - create_timestamp_flow:
        worker_group:
          value: RAS_Operator_Path
          override: true
        do:
          io.cloudslang.carbon_footprint_project.tools.create_timestamp_flow: []
        publish:
          - timestamp
        navigate:
          - SUCCESS: get_ucmdbid_azure_vm_name
          - FAILURE: on_failure
    - get_ucmdbid_azure_vm_name:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.get_ucmdbid_azure_vm_name: []
        publish:
          - ucmdbids
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_token
    - get_ucmdbid:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${ucmdbids}'
            - json_path: "${'$.cis[?(@.properties.cloud_vm_display_name== \"'+server+'\")].ucmdbId'}"
            - input_0: '${server}'
        publish:
          - ucmdbid: "${return_result.strip('[').strip(']').strip('\"')}"
          - output_0: '${input_0}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - get_token:
        do:
          io.cloudslang.carbon_footprint_project.azure.get_token: []
        publish:
          - azure_token
          - list: "${'servername,vmid,location,vmsize,cpus,memory,ip_address,fqdn,total_co2e,cmdb_id,cmdb_global_id'+'\\n\\r'}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_get
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${azure_url+'/'+subscription_id+'/providers/Microsoft.Compute/virtualMachines?api-version='+api_version}"
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
        publish:
          - master_json_result: '${return_result}'
        navigate:
          - SUCCESS: get_list_of_servers
          - FAILURE: on_failure
    - get_list_of_servers:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: '$.value[*].name'
        publish:
          - servers: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${servers}'
            - separator: ','
        publish:
          - server: '${result_string}'
        navigate:
          - HAS_MORE: get_ucmdbid
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_timestamp_flow:
        x: 50
        'y': 89
      get_ucmdbid_azure_vm_name:
        x: 249
        'y': 84
      get_ucmdbid:
        x: 455
        'y': 215
      get_token:
        x: 82
        'y': 287
      http_client_get:
        x: 220
        'y': 306
      get_list_of_servers:
        x: 378
        'y': 382
      list_iterator:
        x: 554
        'y': 430
        navigate:
          016564ab-9240-f4ea-e551-b51af4a5ffb3:
            targetId: 43979991-6f3d-c1d7-84b1-75bbe46285d2
            port: NO_MORE
    results:
      SUCCESS:
        43979991-6f3d-c1d7-84b1-75bbe46285d2:
          x: 721
          'y': 234

