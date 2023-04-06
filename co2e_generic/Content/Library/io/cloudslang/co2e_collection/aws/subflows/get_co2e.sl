########################################################################################################################
#!!
#! @input aws_instanes: JSON list of all AWS instances for the account
#! @input server_list: Header for the output server list (optional)
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
namespace: io.cloudslang.co2e_collection.aws.subflows
flow:
  name: get_co2e
  inputs:
    - aws_instanes: |-
        [ {   "aws_region" : "eu-west-1",   "reservation_id" : "r-06b42653f85a99108",   "instance_id" : "i-0e6c694b93889a7a0",   "instance_type" : "t2.micro",   "instance_state" : "stopped",   "instance_name" : "myvm"},{   "aws_region" : "eu-west-1",   "reservation_id" : "r-0a2b1fcf08a063ff0",   "instance_id" : "i-0f0a59fe6070a5447",   "instance_type" : "t2.micro",   "instance_state" : "stopped",   "instance_name" : "myvm2"},

         {   "aws_region" : "us-east-1",   "reservation_id" : "r-0980c9c73125ccfd8",   "instance_id" : "i-0b3370c7a2e5daef2",   "instance_type" : "t2.micro",   "instance_state" : "running",   "instance_name" : "myVM4"},

         {   "aws_region" : "us-west-1",   "reservation_id" : "r-0efd6ed343f1a53a3",   "instance_id" : "i-073ab686837457b35",   "instance_type" : "t2.micro",   "instance_state" : "running",   "instance_name" : "myVM3"}]
    - server_list:
        default: "${'aws_region,reservation_id,instance_id,instance_type,instance_state,instance_name,total_co2e'+'\\n\\r'}"
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
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
  workflow:
    - convert_json_array_to_instances_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${aws_instanes}'
            - json_path: $..instance_id
        publish:
          - instances_list: "${return_result.strip('[').strip(']').strip('\"')}"
          - index: '0'
        navigate:
          - SUCCESS: check_for_instances
          - FAILURE: on_failure
    - set_flow_variables:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.co2e_collection.tools.set_flow_variables:
            - json_list: '${aws_instanes}'
            - index: '${index}'
        publish:
          - reservation_id
          - instance_id
          - instance_type
          - instance_state
          - instance_name
          - aws_region
        navigate:
          - SUCCESS: translate_aws_regions
    - aws_vm_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.climatiq.aws_vm_instance:
            - region: '${region}'
            - instance: '${instance_type}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - worker_group: '${worker_group}'
        publish:
          - total_co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_co2e_value_to_total
    - add_co2e_value_to_total:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: "${get('co2e', '0')}"
            - value2: '${total_co2e}'
        publish:
          - co2e: '${result}'
        navigate:
          - SUCCESS: build_instance_list
          - FAILURE: on_failure
    - build_instance_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${server_list}'
            - text: "${aws_region+','+reservation_id+','+instance_id+','+instance_type+','+instance_state+','+instance_name+','+total_co2e+'\\n\\r'}"
        publish:
          - server_list: '${new_string}'
        navigate:
          - SUCCESS: increase_index_number
    - translate_aws_regions:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.climatiq.translate_aws_regions:
            - aws_region: '${aws_region}'
            - worker_group: '${worker_group}'
        publish:
          - region
        navigate:
          - FAILURE: on_failure
          - SUCCESS: aws_vm_instance
    - iterate_through_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${instances_list}'
            - index: '${index}'
        publish:
          - instance: '${result_string}'
        navigate:
          - HAS_MORE: set_flow_variables
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - increase_index_number:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${index}'
            - value2: '1'
        publish:
          - index: '${result}'
        navigate:
          - SUCCESS: iterate_through_instances
          - FAILURE: on_failure
    - check_for_instances:
        do:
          io.cloudslang.base.strings.length:
            - origin_string: '${instances_list}'
        publish:
          - length
        navigate:
          - SUCCESS: instances_greater_than_zero
    - instances_greater_than_zero:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${length}'
            - value2: '0'
        navigate:
          - GREATER_THAN: iterate_through_instances
          - EQUALS: SUCCESS
          - LESS_THAN: SUCCESS
  outputs:
    - co2e: '${co2e}'
    - instances: '${server_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      instances_greater_than_zero:
        x: 480
        'y': 40
        navigate:
          c0031753-4c0f-43cd-c010-67d44d420911:
            targetId: 10b29c3d-071c-f03d-5b8a-f900f9a6531b
            port: EQUALS
          d65c4299-1600-63f3-b668-be04e20aae1b:
            targetId: 10b29c3d-071c-f03d-5b8a-f900f9a6531b
            port: LESS_THAN
      set_flow_variables:
        x: 80
        'y': 400
      translate_aws_regions:
        x: 80
        'y': 560
      add_co2e_value_to_total:
        x: 480
        'y': 560
      check_for_instances:
        x: 280
        'y': 40
      convert_json_array_to_instances_list:
        x: 80
        'y': 40
      increase_index_number:
        x: 280
        'y': 400
      build_instance_list:
        x: 480
        'y': 400
      aws_vm_instance:
        x: 280
        'y': 560
      iterate_through_instances:
        x: 280
        'y': 240
        navigate:
          d39e287a-06da-3e65-b064-302be4c17701:
            targetId: 10b29c3d-071c-f03d-5b8a-f900f9a6531b
            port: NO_MORE
    results:
      SUCCESS:
        10b29c3d-071c-f03d-5b8a-f900f9a6531b:
          x: 480
          'y': 240
