namespace: io.cloudslang.co2e_collection.aws.subflows
flow:
  name: get_co2e
  inputs:
    - aws_instanes: |-
        [ {   "aws_region" : "eu-west-1",   "reservation_id" : "r-06b42653f85a99108",   "instance_id" : "i-0e6c694b93889a7a0",   "instance_type" : "t2.micro",   "instance_state" : "stopped",   "instance_name" : "myvm"},{   "aws_region" : "eu-west-1",   "reservation_id" : "r-0a2b1fcf08a063ff0",   "instance_id" : "i-0f0a59fe6070a5447",   "instance_type" : "t2.micro",   "instance_state" : "stopped",   "instance_name" : "myvm2"},

         {   "aws_region" : "us-east-1",   "reservation_id" : "r-0980c9c73125ccfd8",   "instance_id" : "i-0b3370c7a2e5daef2",   "instance_type" : "t2.micro",   "instance_state" : "running",   "instance_name" : "myVM4"},

         {   "aws_region" : "us-west-1",   "reservation_id" : "r-0efd6ed343f1a53a3",   "instance_id" : "i-073ab686837457b35",   "instance_type" : "t2.micro",   "instance_state" : "running",   "instance_name" : "myVM3"}]
    - server_list: "${'aws_region,reservation_id,instance_id,instance_type,instance_state,instance_name,total_co2e'+'\\n\\r'}"
  workflow:
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${aws_instanes}'
        publish:
          - array0: "${'['+result_string+']'}"
        navigate:
          - HAS_MORE: set_flow_variables
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - set_flow_variables:
        do:
          io.cloudslang.co2e_collection.tools.set_flow_variables:
            - json_list: '${array0}'
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
        do:
          io.cloudslang.co2e_collection.climatiq.aws_vm_instance:
            - region: '${region}'
            - instance: '${instance_type}'
        publish:
          - total_co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers
    - add_numbers:
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
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${server_list}'
            - text: "${aws_region+','+reservation_id+','+instance_id+','+instance_type+','+instance_state+','+instance_name+','+total_co2e+'\\n\\r'}"
        publish:
          - server_list: '${new_string}'
        navigate:
          - SUCCESS: array_iterator
    - translate_aws_regions:
        do:
          io.cloudslang.co2e_collection.climatiq.translate_aws_regions:
            - aws_region: '${aws_region}'
        publish:
          - region
        navigate:
          - FAILURE: on_failure
          - SUCCESS: aws_vm_instance
  outputs:
    - co2e: '${co2e}'
    - instances: '${server_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      build_instance_list:
        x: 360
        'y': 200
      array_iterator:
        x: 160
        'y': 40
        navigate:
          ba650137-2ba8-81d1-9e85-5f53ec859bf0:
            targetId: 10b29c3d-071c-f03d-5b8a-f900f9a6531b
            port: NO_MORE
      set_flow_variables:
        x: 40
        'y': 200
      aws_vm_instance:
        x: 200
        'y': 400
      add_numbers:
        x: 360
        'y': 400
      translate_aws_regions:
        x: 40
        'y': 400
    results:
      SUCCESS:
        10b29c3d-071c-f03d-5b8a-f900f9a6531b:
          x: 360
          'y': 40
