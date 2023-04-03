########################################################################################################################
#!!
#! @input identity: The Amazon Access Key ID
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input skipstatus: Skip instance when status is set to this value
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - proxy server password associated with the proxy_username
#!                        input value.
#!                        Default: ''
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.aws.subflows
flow:
  name: aws_regions
  inputs:
    - identity: "${get_sp('io.cloudslang.co2e_collection.aws_accesskey')}"
    - credential:
        default: "${get_sp('io.cloudslang.co2e_collection.aws_secretkey')}"
        sensitive: true
    - skipstatus: none
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
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
  workflow:
    - describe_regions:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.regions.describe_regions:
            - identity: '${identity}'
            - credential:
                value: '${credential}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - key_filters_string: endpoint
        publish:
          - xml_result: '${return_result}'
        navigate:
          - SUCCESS: convert_xml_to_json
          - FAILURE: on_failure
    - convert_xml_to_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${xml_result}'
            - include_root_element: 'false'
            - include_attributes: 'false'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_all_aws_regions_from_json
          - FAILURE: on_failure
    - get_all_aws_regions_from_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.regionInfo.item
        publish:
          - json_array: '${return_result}'
        navigate:
          - SUCCESS: iterate_through_aws_regions
          - FAILURE: on_failure
    - iterate_through_aws_regions:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${json_array}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: get_aws_region_endpoint
          - NO_MORE: finalize_aws_instances_list
          - FAILURE: on_failure
    - get_aws_region_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_string}'
            - json_path: $.regionEndpoint
        publish:
          - region_endpoint: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: get_aws_region_name
          - FAILURE: on_failure
    - get_aws_region_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_string}'
            - json_path: $.regionName
        publish:
          - aws_region: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: get_instances_for_region
          - FAILURE: on_failure
    - get_instances_for_region:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.aws.subflows.get_instances_for_region:
            - aws_region: '${aws_region}'
            - aws_accesskey: '${identity}'
            - aws_secretkey: '${credential}'
            - skipstatus: '${skipstatus}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish:
          - list_of_aws_instaces
        navigate:
          - SUCCESS: contruct_aws_instances_list
          - FAILURE: on_failure
          - SUCCESS_NO_INSTANCES: iterate_through_aws_regions
    - contruct_aws_instances_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${get('all_ec2_instances', '\\n\\r')}"
            - text: '${list_of_aws_instaces}'
        publish:
          - all_ec2_instances: '${new_string}'
        navigate:
          - SUCCESS: iterate_through_aws_regions
    - finalize_aws_instances_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - input0: "${all_ec2_instances.strip(',')}"
        publish:
          - all_ec2_instances: "${cs_append(cs_prepend(input0,'['),']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - aws_regions: '${aws_regions}'
    - all_ec2_instances: '${all_ec2_instances}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      finalize_aws_instances_list:
        x: 440
        'y': 40
        navigate:
          2ce90385-cc42-5743-25f4-ac998dc3616f:
            targetId: 0028d599-9929-7cfe-c659-8ee50cd44bec
            port: SUCCESS
      describe_regions:
        x: 80
        'y': 40
      get_aws_region_name:
        x: 240
        'y': 360
      get_instances_for_region:
        x: 440
        'y': 360
      get_all_aws_regions_from_json:
        x: 80
        'y': 200
      get_aws_region_endpoint:
        x: 80
        'y': 360
      convert_xml_to_json:
        x: 240
        'y': 40
      contruct_aws_instances_list:
        x: 440
        'y': 200
      iterate_through_aws_regions:
        x: 240
        'y': 200
    results:
      SUCCESS:
        0028d599-9929-7cfe-c659-8ee50cd44bec:
          x: 600
          'y': 200
