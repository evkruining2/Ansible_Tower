########################################################################################################################
#!!
#! @description: Calculates the average CO2e per 24hr based on the cloud provider, region and configured memory
#!
#! @input climatiq_url: Climatiq.io API URL. Example: https://beta3.api.climatiq.io
#! @input climatiq_token: Climatiq.io API access token
#! @input provider: Name of the cloud provider to use. Example: azure
#! @input region: Region of the cloud provider to use. Example: useast1
#! @input memory: Amount of memory (MB) to calculate the CO2e for
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.climatiq
flow:
  name: calculate_co2e_memory
  inputs:
    - climatiq_url: "${get_sp('io.cloudslang.co2e_collection.climatiq_url')}"
    - climatiq_token:
        default: "${get_sp('io.cloudslang.co2e_collection.climatiq_token')}"
        sensitive: true
    - provider: aws
    - region: eu_west_1
    - memory: '8'
    - data_unit: GB
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
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
    - trust_all_roots:
        default: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
        required: false
    - x_509_hostname_verifier:
        default: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
        required: false
  workflow:
    - climatiq_io_get_memory:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${climatiq_url+'/compute/'+provider+'/memory'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+climatiq_token}"
            - body: "${'{'+\\\n'\"data\": '+memory+','+\\\n'\"region\": \"'+region+'\",'+\\\n'\"data_unit\": \"'+data_unit+'\",'+\\\n'\"duration\": 24,'+\\\n'\"duration_unit\": \"h\"'+\\\n'}'}"
            - worker_group: '${worker_group}'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_extract_co2e
          - FAILURE: on_failure
    - json_path_extract_co2e:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.co2e
        publish:
          - co2e: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - co2e: '${co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      climatiq_io_get_memory:
        x: 80
        'y': 80
      json_path_extract_co2e:
        x: 280
        'y': 80
        navigate:
          bc1c16a8-9698-c49e-f025-5b5febbe9128:
            targetId: 9cf1a507-2d60-db49-5d3c-a6c78597df86
            port: SUCCESS
    results:
      SUCCESS:
        9cf1a507-2d60-db49-5d3c-a6c78597df86:
          x: 480
          'y': 80
