namespace: io.cloudslang.carbon_footprint_project.azure
flow:
  name: get_vm_details
  inputs:
    - azure_url: 'https://management.azure.com/subscriptions'
    - subscription_id: "${get_sp('io.cloudslang.carbon_footprint_project.azure_subscription_id')}"
    - api_version: '2022-11-01'
    - ucmdbids
    - timestamp
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - get_azure_token:
        do:
          io.cloudslang.carbon_footprint_project.azure.get_token: []
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
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
          - HAS_MORE: get_vmsize
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
    - query_vm_details:
        do:
          io.cloudslang.carbon_footprint_project.azure.query_vm_details:
            - image_name: '${vmsize}'
        publish:
          - cpus
          - memory
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_network
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
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
          - SUCCESS: get_ip_1
          - FAILURE: on_failure
    - get_ip_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.properties.dnsSettings.fqdn
        publish:
          - fqdn: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: translate_azure_regions
          - FAILURE: on_failure
    - translate_azure_regions:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.translate_azure_regions:
            - az_region: '${location}'
        publish:
          - region
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_disks
    - azure_vm_instance:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.azure_vm_instance:
            - region: '${region}'
            - cpu_count: '${cpus}'
            - memory: '${memory}'
            - storage_amount: '${disk_sizes}'
        publish:
          - total_co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_ucmdbid
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
    - odl_load_data:
        do:
          io.cloudslang.carbon_footprint_project.optic_data_lake.odl_load_data:
            - timestamp: '${timestamp}'
            - scope2_co2e: '0'
            - scope3_co2e: '${total_co2e}'
            - powerusage: '0'
            - cmdb_id: '${ucmdbid}'
            - cmdb_global_id: '${global_id}'
            - node_fqdn: '${fqdn}'
            - node_ip_address: '${ip_address}'
            - cloudvendor: Azure
            - cloudregion: '${location}'
        publish:
          - odl_result
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - get_ucmdbid:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${ucmdbids}'
            - json_path: "${'$.cis[?(@.properties.cloud_vm_display_name== \"'+server+'\")].ucmdbId'}"
        publish:
          - ucmdbid: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_global_id
          - FAILURE: on_failure
    - get_global_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${ucmdbids}'
            - json_path: "${'$.cis[?(@.properties.cloud_vm_display_name== \"'+server+'\")].globalId'}"
        publish:
          - global_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: update_ci
          - FAILURE: on_failure
    - update_ci:
        do:
          io.cloudslang.carbon_footprint_project.ucmdb.update_ci:
            - ucmdb_id: '${ucmdbid}'
            - scope3: '${total_co2e}'
            - region: '${location}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: odl_load_data
    - get_disks:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$..value[?(@.name == \"'+server+'\")]..diskSizeGB'}"
        publish:
          - disks: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_azure_disk_size
          - FAILURE: on_failure
    - get_azure_disk_size:
        do:
          io.cloudslang.carbon_footprint_project.azure.get_azure_disk_size:
            - disks: '${disks}'
        publish:
          - disk_sizes
        navigate:
          - FAILURE: on_failure
          - SUCCESS: azure_vm_instance
  outputs:
    - azure_server_list: '${list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_azure_token:
        x: 40
        'y': 40
      get_list_of_servers:
        x: 360
        'y': 40
      get_vmsize:
        x: 200
        'y': 200
      get_public_network:
        x: 200
        'y': 360
      get_ip_1:
        x: 360
        'y': 520
      azure_get_vms:
        x: 200
        'y': 40
      set_ip_and_fqdn_to_null:
        x: 360
        'y': 680
      get_network:
        x: 360
        'y': 360
      get_azure_disk_size:
        x: 840
        'y': 520
      get_pub_ip_and_fqdn:
        x: 40
        'y': 520
      get_disks:
        x: 680
        'y': 520
      azure_vm_instance:
        x: 1000
        'y': 520
      get_public_interface_id:
        x: 40
        'y': 360
      get_global_id:
        x: 840
        'y': 360
      get_ucmdbid:
        x: 1000
        'y': 360
      list_iterator:
        x: 520
        'y': 40
        navigate:
          a47cdb3f-74e6-05b8-aac1-5f880a0009b7:
            targetId: c01cab71-dfd0-f554-9dbb-6cda97d840d6
            port: NO_MORE
      get_ip:
        x: 200
        'y': 520
      query_vm_details:
        x: 520
        'y': 360
      get_vmid:
        x: 520
        'y': 200
      odl_load_data:
        x: 680
        'y': 200
      update_ci:
        x: 680
        'y': 360
      translate_azure_regions:
        x: 520
        'y': 520
      get_location:
        x: 360
        'y': 200
    results:
      SUCCESS:
        c01cab71-dfd0-f554-9dbb-6cda97d840d6:
          x: 803
          'y': 43
