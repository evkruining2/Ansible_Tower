namespace: io.cloudslang.co2e_collection.Azure.subflows
flow:
  name: check_if_vm_is_running
  inputs:
    - server_id: /subscriptions/4d08f192-8c63-49fa-a461-5cdd32ce42dc/resourceGroups/MERLION/providers/Microsoft.Compute/virtualMachines/hcmxsaas98341
    - azure_url: "${get_sp('io.cloudslang.co2e_collection.azure_url')}"
    - subscription_id: "${get_sp('io.cloudslang.co2e_collection.azure_subscription_id')}"
    - api_version: '2022-11-01'
    - azure_token
  workflow:
    - azure_get_vm_details:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${azure_url+'/'+server_id+'?$expand=InstanceView&api-version='+api_version}"
            - proxy_host: "${get_sp('io.cloudslang.co2e_collection.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.co2e_collection.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.co2e_collection.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.co2e_collection.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
        publish:
          - master_json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: $.properties.instanceView.statuses..displayStatus
        publish:
          - return_result
        navigate:
          - SUCCESS: string_occurrence_counter
          - FAILURE: on_failure
    - string_occurrence_counter:
        do:
          io.cloudslang.base.strings.string_occurrence_counter:
            - string_in_which_to_search: '${return_result}'
            - string_to_find: running
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      azure_get_vm_details:
        x: 80
        'y': 80
      string_occurrence_counter:
        x: 440
        'y': 80
        navigate:
          03e0f0b9-4d56-e8d5-8dce-aac6520ab26c:
            targetId: 3a289b04-8c03-b7f5-89db-e9dd694193b9
            port: SUCCESS
      json_path_query:
        x: 280
        'y': 80
    results:
      SUCCESS:
        3a289b04-8c03-b7f5-89db-e9dd694193b9:
          x: 440
          'y': 280
