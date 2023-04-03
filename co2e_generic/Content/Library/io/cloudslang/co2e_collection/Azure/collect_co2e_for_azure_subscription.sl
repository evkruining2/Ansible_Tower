########################################################################################################################
#!!
#! @description: Main flow to query all running instances within an Azure subscription and calculate the average cumulative CO2e per 24hr and the average CO2e per 24hr per instance
#!
#! @input azure_url: Azure subscription API url
#! @input subscription_id: Azure Subscription ID
#! @input api_version: Azure API version
#! @input tenant_id: Azure Tenant ID
#! @input client_id: Azure Client ID
#! @input client_secret: Azure Client Secret
#! @input scope: Azure scope for authentication token
#! @input grant_type: Azure grant type for authentication token
#! @input worker_group: Optional - RAS worker group to use. Default: RAS_Operator_Path
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#!
#! @output all_azure_instances: List of all Azure instances and their CO2e details
#! @output total_co2e: Cumulative CO2e per 24h for all instances
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.Azure
flow:
  name: collect_co2e_for_azure_subscription
  inputs:
    - azure_url: "${get_sp('io.cloudslang.co2e_collection.azure_url')}"
    - subscription_id: "${get_sp('io.cloudslang.co2e_collection.azure_subscription_id')}"
    - api_version: '2022-11-01'
    - tenant_id: "${get_sp('io.cloudslang.co2e_collection.azure_tenant_id')}"
    - client_id: "${get_sp('io.cloudslang.co2e_collection.azure_client_id')}"
    - client_secret:
        default: "${get_sp('io.cloudslang.co2e_collection.azure_client_secret')}"
        sensitive: true
    - scope: 'https://management.azure.com/.default'
    - grant_type: client_credentials
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
    - trust_all_roots:
        default: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
        required: false
    - x_509_hostname_verifier:
        default: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
        required: false
    - proxy_host:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_host')}"
        required: false
    - proxy_port:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_port')}"
        required: false
    - proxy_username:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_username')}"
        required: false
    - proxy_password:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_password')}"
        required: false
        sensitive: true
  workflow:
    - get_azure_token:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.Azure.subflows.get_token:
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret: '${client_secret}'
            - scope: '${scope}'
            - grant_type: '${grant_type}'
            - worker_group: '${worker_group}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - azure_token
          - list: "${'servername,vmid,location,vmsize,cpus,memory,ip_address,fqdn,total_co2e'+'\\n\\r'}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: azure_get_vms
    - get_list_of_servers:
        worker_group: '${worker_group}'
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
            - url: "${azure_url+'/subscriptions/'+subscription_id+'/providers/Microsoft.Compute/virtualMachines?api-version='+api_version}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - master_json_result: '${return_result}'
        navigate:
          - SUCCESS: get_list_of_servers
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_public_interface_id
          - FAILURE: on_failure
    - get_public_interface_id:
        worker_group: '${worker_group}'
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
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://management.azure.com/'+pub_network_id+'?api-version='+api_version}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_ip
          - FAILURE: set_ip_and_fqdn_to_null
    - get_ip:
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.climatiq.translate_azure_regions:
            - az_region: '${location}'
            - worker_group: '${worker_group}'
        publish:
          - region
        navigate:
          - FAILURE: on_failure
          - SUCCESS: climatiq_azure_vm_instance
    - climatiq_azure_vm_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.climatiq.azure_vm_instance:
            - region: '${region}'
            - cpu_count: '${cpus}'
            - memory: '${memory}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - hostname_verifier: '${x_509_hostname_verifier}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish:
          - total_co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_co2e_value_to_total
    - add_vm_details_to_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${list}'
            - text: "${server+','+vmid+','+location+','+vmsize+','+cpus+','+memory+','+ip_address+','+fqdn+','+total_co2e+'\\n\\r'}"
        publish:
          - list: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
    - get_vm_id:
        worker_group: '${worker_group}'
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
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.Azure.subflows.check_if_vm_is_running:
            - server_id: '${id}'
            - azure_url: '${azure_url}'
            - subscription_id: '${subscription_id}'
            - api_version: '${api_version}'
            - azure_token: '${azure_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - worker_group: '${worker_group}'
        navigate:
          - FAILURE: list_iterator
          - SUCCESS: get_vmsize
    - query_vm_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.Azure.subflows.query_vm_details:
            - image_name: '${vmsize}'
        publish:
          - cpus
          - memory
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_network
    - add_co2e_value_to_total:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: "${get('co2e', '0')}"
            - value2: '${total_co2e}'
        publish:
          - co2e: '${result}'
        navigate:
          - SUCCESS: add_vm_details_to_list
          - FAILURE: on_failure
  outputs:
    - all_azure_instances: '${list}'
    - total_co2e: '${co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_azure_token:
        x: 40
        'y': 80
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
            vertices:
              - x: 680
                'y': 40
              - x: 800
                'y': 40
      get_ip:
        x: 360
        'y': 560
      add_co2e_value_to_total:
        x: 680
        'y': 240
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
        'y': 80
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
          x: 880
          'y': 80
