########################################################################################################################
#!!
#! @description: calculates the average CO2e per 24hr of an AWS instance based on instance_type and aws_region
#!
#! @input climatiq_url: Climatiq.io API url
#! @input climatiq_token: Climatic.io API access token
#! @input region: AWS region to query climatiq.io for
#! @input instance: AWS instance type to query
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
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.climatiq
flow:
  name: aws_vm_instance
  inputs:
    - climatiq_url: 'https://beta3.api.climatiq.io/compute/aws/instance'
    - climatiq_token: "${get_sp('io.cloudslang.co2e_collection.climatiq_token')}"
    - region: eu_west_1
    - instance: c3.8xlarge
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
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
  workflow:
    - http_client_post:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${climatiq_url}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+climatiq_token}"
            - body: "${'{'+\\\n'\"region\": \"'+region+'\",'+\\\n'\"instance\": \"'+instance+'\",'+\\\n'\"duration\": 24,'+\\\n'\"duration_unit\": \"h\"'+\\\n'}'}"
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
            - json_path: $.total_co2e
        publish:
          - total_co2e: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - total_co2e: '${total_co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 80
        'y': 80
      json_path_extract_co2e:
        x: 280
        'y': 80
        navigate:
          8b521afe-14cf-d008-d8ec-d5c5fd4816ca:
            targetId: 42fa9c5b-b02f-6be0-0a07-ee2671b4fd8c
            port: SUCCESS
    results:
      SUCCESS:
        42fa9c5b-b02f-6be0-0a07-ee2671b4fd8c:
          x: 480
          'y': 80
