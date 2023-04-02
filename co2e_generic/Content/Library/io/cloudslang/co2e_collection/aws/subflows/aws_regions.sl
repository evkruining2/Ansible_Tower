########################################################################################################################
#!!
#! @input identity: The Amazon Access Key ID
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input skipstatus: Skip instance when status is set to this value
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
  workflow:
    - describe_regions:
        do:
          io.cloudslang.amazon.aws.ec2.regions.describe_regions:
            - identity: '${identity}'
            - credential:
                value: '${credential}'
                sensitive: true
            - key_filters_string: endpoint
        publish:
          - xml_result: '${return_result}'
        navigate:
          - SUCCESS: convert_xml_to_json
          - FAILURE: on_failure
    - convert_xml_to_json:
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${xml_result}'
            - include_root_element: 'false'
            - include_attributes: 'false'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.regionInfo.item
        publish:
          - json_array: '${return_result}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${json_array}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: json_path_query_1
          - NO_MORE: do_nothing
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_string}'
            - json_path: $.regionEndpoint
        publish:
          - region_endpoint: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: json_path_query_1_1
          - FAILURE: on_failure
    - json_path_query_1_1:
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
        do:
          io.cloudslang.co2e_collection.aws.subflows.get_instances_for_region:
            - aws_region: '${aws_region}'
            - aws_accesskey: '${identity}'
            - aws_secretkey: '${credential}'
            - skipstatus: '${skipstatus}'
        publish:
          - list_of_aws_instaces
        navigate:
          - SUCCESS: append
          - FAILURE: on_failure
          - SUCCESS_NO_INSTANCES: array_iterator
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${get('all_ec2_instances', '\\n\\r')}"
            - text: '${list_of_aws_instaces}'
        publish:
          - all_ec2_instances: '${new_string}'
        navigate:
          - SUCCESS: array_iterator
    - do_nothing:
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
      json_path_query:
        x: 80
        'y': 200
      json_path_query_1_1:
        x: 240
        'y': 360
      describe_regions:
        x: 80
        'y': 40
      get_instances_for_region:
        x: 440
        'y': 360
      array_iterator:
        x: 240
        'y': 200
      json_path_query_1:
        x: 80
        'y': 360
      convert_xml_to_json:
        x: 240
        'y': 40
      do_nothing:
        x: 440
        'y': 40
        navigate:
          2ce90385-cc42-5743-25f4-ac998dc3616f:
            targetId: 0028d599-9929-7cfe-c659-8ee50cd44bec
            port: SUCCESS
      append:
        x: 440
        'y': 200
    results:
      SUCCESS:
        0028d599-9929-7cfe-c659-8ee50cd44bec:
          x: 600
          'y': 200
