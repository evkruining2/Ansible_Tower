namespace: io.cloudslang.co2e_collection.Azure
flow:
  name: collect_co2e_for_azure_subscription
  inputs:
    - azure_url: 'https://management.azure.com/subscriptions'
    - subscription_id: "${get_sp('io.cloudslang.co2e_collection.azure_subscription_id')}"
    - api_version: '2022-11-01'
  workflow:
    - get_token:
        do:
          io.cloudslang.co2e_collection.Azure.subflows.get_token:
            - worker_group: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
            - trust_all_roots: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
        publish:
          - azure_token
          - list: "${'servername,vmid,location,vmsize,cpus,memory,ip_address,fqdn,total_co2e,cmdb_id,cmdb_global_id'+'\\n\\r'}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: azure_get_vms
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
    - azure_get_vms:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${azure_url+'/'+subscription_id+'/providers/Microsoft.Compute/virtualMachines?api-version='+api_version}"
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
          - SUCCESS: get_list_of_servers
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${servers}'
            - separator: ','
        publish:
          - server: '${result_string}'
        navigate:
          - HAS_MORE: get_vm_id
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_vmsize:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$..value[?(@.name == \"'+server+'\")].properties.hardwareProfile.vmSize'}"
        publish:
          - vmsize: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_location
          - FAILURE: on_failure
    - get_location:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$..value[?(@.name == \"'+server+'\")].location'}"
        publish:
          - location: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_vmid
          - FAILURE: on_failure
    - get_vmid:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$..value[?(@.name == \"'+server+'\")].properties.vmId'}"
        publish:
          - vmid: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: query_vm_details
          - FAILURE: on_failure
    - get_network:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$..value[?(@.name == \"'+server+'\")].properties.networkProfile.networkInterfaces..id'}"
        publish:
          - network_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_public_network
          - FAILURE: on_failure
    - get_public_network:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://management.azure.com/'+network_id+'?api-version='+api_version}"
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
            - worker_group: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_public_interface_id
          - FAILURE: on_failure
    - get_public_interface_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: "${'$..[?(@.name == \"'+server+'\")].properties.publicIPAddress.id'}"
        publish:
          - pub_network_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_pub_ip_and_fqdn
          - FAILURE: on_failure
    - get_pub_ip_and_fqdn:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://management.azure.com/'+pub_network_id+'?api-version='+api_version}"
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
            - worker_group: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_ip
          - FAILURE: set_ip_and_fqdn_to_null
    - get_ip:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.properties.ipAddress
        publish:
          - ip_address: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_fqdn
          - FAILURE: on_failure
    - get_fqdn:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.properties.dnsSettings.fqdn
        publish:
          - fqdn: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: translate_azure_regions
          - FAILURE: on_failure
    - set_ip_and_fqdn_to_null:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: '${server}'
        publish:
          - ip_address: 127.0.0.1
          - fqdn: '${input_0}'
        navigate:
          - SUCCESS: translate_azure_regions
          - FAILURE: on_failure
    - translate_azure_regions:
        do:
          io.cloudslang.co2e_collection.climatiq.translate_azure_regions:
            - az_region: '${location}'
        publish:
          - region
        navigate:
          - FAILURE: on_failure
          - SUCCESS: climatiq_azure_vm_instance
    - climatiq_azure_vm_instance:
        do:
          io.cloudslang.co2e_collection.climatiq.azure_vm_instance:
            - region: '${region}'
            - cpu_count: '${cpus}'
            - memory: '${memory}'
        publish:
          - total_co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_vm_details_to_list
    - add_vm_details_to_list:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${list}'
            - text: "${server+','+vmid+','+location+','+vmsize+','+cpus+','+memory+','+ip_address+','+fqdn+','+total_co2e+'\\n\\r'}"
        publish:
          - list: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
    - get_vm_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$..value[?(@.name == \"'+server+'\")].id'}"
        publish:
          - id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: check_if_vm_is_running
          - FAILURE: on_failure
    - check_if_vm_is_running:
        do:
          io.cloudslang.co2e_collection.Azure.subflows.check_if_vm_is_running:
            - server_id: '${id}'
            - azure_token: '${azure_token}'
        navigate:
          - FAILURE: list_iterator
          - SUCCESS: get_vmsize
    - query_vm_details:
        do:
          io.cloudslang.co2e_collection.Azure.subflows.query_vm_details:
            - image_name: '${vmsize}'
        publish:
          - cpus
          - memory
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_network
  outputs:
    - azure_server_list: '${list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_list_of_servers:
        x: 360
        'y': 80
      get_vmsize:
        x: 360
        'y': 240
      get_public_network:
        x: 40
        'y': 400
      azure_get_vms:
        x: 200
        'y': 80
      set_ip_and_fqdn_to_null:
        x: 440
        'y': 720
      get_network:
        x: 200
        'y': 400
      check_if_vm_is_running:
        x: 200
        'y': 240
      get_pub_ip_and_fqdn:
        x: 200
        'y': 560
      get_public_interface_id:
        x: 40
        'y': 560
      list_iterator:
        x: 520
        'y': 80
        navigate:
          a47cdb3f-74e6-05b8-aac1-5f880a0009b7:
            targetId: c01cab71-dfd0-f554-9dbb-6cda97d840d6
            port: NO_MORE
      get_ip:
        x: 360
        'y': 560
      get_token:
        x: 40
        'y': 80
      query_vm_details:
        x: 360
        'y': 400
      climatiq_azure_vm_instance:
        x: 680
        'y': 400
      get_vm_id:
        x: 40
        'y': 240
      get_vmid:
        x: 520
        'y': 400
      add_vm_details_to_list:
        x: 680
        'y': 240
      translate_azure_regions:
        x: 680
        'y': 560
      get_fqdn:
        x: 520
        'y': 560
      get_location:
        x: 520
        'y': 240
    results:
      SUCCESS:
        c01cab71-dfd0-f554-9dbb-6cda97d840d6:
          x: 680
          'y': 80
