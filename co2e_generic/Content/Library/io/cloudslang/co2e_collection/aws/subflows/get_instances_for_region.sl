########################################################################################################################
#!!
#! @input skipstatus: Skip instance when status is set to this value
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - proxy server password associated with the proxy_username
#!                        input value.
#!                        Default: ''
#!
#! @result SUCCESS_NO_INSTANCES: No instances found for region; continue processing
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.aws.subflows
flow:
  name: get_instances_for_region
  inputs:
    - aws_region: us-west-1
    - aws_accesskey: "${get_sp('io.cloudslang.co2e_collection.aws_accesskey')}"
    - aws_secretkey: "${get_sp('io.cloudslang.co2e_collection.aws_secretkey')}"
    - skipstatus:
        default: none
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
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
  workflow:
    - set_list_header:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - list: ' '
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: on_failure
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
            - endpoint: "${'https://ec2.'+aws_region+'.amazonaws.com'}"
            - identity: '${aws_accesskey}'
            - credential:
                value: '${aws_secretkey}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result
        navigate:
          - SUCCESS: convert_xml_to_json
          - FAILURE: on_failure
    - convert_xml_to_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${return_result}'
        publish:
          - master_json_result: '${return_result}'
        navigate:
          - SUCCESS: strip_json
          - FAILURE: on_failure
    - strip_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: $.DescribeInstancesResponse.reservationSet.item
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_reservation_ids
          - FAILURE: SUCCESS_NO_INSTANCES
    - get_details_per_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${reservation_ids}'
            - separator: ','
        publish:
          - reservation_id: '${result_string}'
        navigate:
          - HAS_MORE: get_instance_state
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_instance_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$.DescribeInstancesResponse.reservationSet.item.[?(@.reservationId == \"'+reservation_id+'\")].instancesSet.item'}"
        publish:
          - instance_json: '${return_result}'
        navigate:
          - SUCCESS: get_instance_id
          - FAILURE: on_failure
    - get_instance_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${master_json_result}'
            - json_path: "${'$.DescribeInstancesResponse.reservationSet.item.[?(@.reservationId == \"'+reservation_id+'\")].instancesSet.item.instanceState.name'}"
        publish:
          - instance_state: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: '${skipstatus}'
        navigate:
          - SUCCESS: get_details_per_instance
          - FAILURE: get_instance_details
    - get_instance_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instance_json}'
            - json_path: $..instanceId
        publish:
          - instance_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_instance_type
          - FAILURE: on_failure
    - get_reservation_ids:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $..reservationId
        publish:
          - reservation_ids: "${cs_replace(return_result.strip('[').strip(']'),'\"','')}"
        navigate:
          - SUCCESS: get_details_per_instance
          - FAILURE: on_failure
    - get_instance_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instance_json}'
            - json_path: $..instanceType
        publish:
          - instance_type: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_instance_name
          - FAILURE: on_failure
    - get_instance_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instance_json}'
            - json_path: $..tagSet.item.value
        publish:
          - instance_name: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: build_json_of_instance_details
          - FAILURE: on_failure
    - build_json_of_instance_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${list}'
            - text: "${'{'+\\\n'   \"aws_region\" : \"'+aws_region+'\",'+\\\n'   \"reservation_id\" : \"'+reservation_id+'\",'+\\\n'   \"instance_id\" : \"'+instance_id+'\",'+\\\n'   \"instance_type\" : \"'+instance_type+'\",'+\\\n'   \"instance_state\" : \"'+instance_state+'\",'+\\\n'   \"instance_name\" : \"'+instance_name+'\"'+\\\n'},'}"
        publish:
          - list: '${new_string}'
        navigate:
          - SUCCESS: get_details_per_instance
  outputs:
    - list_of_aws_instaces: '${list}'
  results:
    - SUCCESS
    - FAILURE
    - SUCCESS_NO_INSTANCES
extensions:
  graph:
    steps:
      get_instance_details:
        x: 440
        'y': 80
      describe_instances:
        x: 80
        'y': 200
      get_instance_name:
        x: 600
        'y': 240
      string_equals:
        x: 240
        'y': 80
      strip_json:
        x: 80
        'y': 520
        navigate:
          7550e569-2511-e12a-659b-0bb6c85df07f:
            targetId: 84ea3f8f-d742-4455-7bc8-10612c40a833
            port: FAILURE
      get_instance_state:
        x: 240
        'y': 280
      set_list_header:
        x: 80
        'y': 40
      convert_xml_to_json:
        x: 80
        'y': 360
      build_json_of_instance_details:
        x: 600
        'y': 440
      get_instance_type:
        x: 440
        'y': 240
      get_reservation_ids:
        x: 240
        'y': 440
      get_instance_id:
        x: 600
        'y': 80
      get_details_per_instance:
        x: 440
        'y': 480
        navigate:
          25aea9a7-494a-7617-c84d-b7b62e03866e:
            targetId: 613801e8-bddb-ec71-ee09-42e42fafd46f
            port: NO_MORE
    results:
      SUCCESS:
        613801e8-bddb-ec71-ee09-42e42fafd46f:
          x: 600
          'y': 600
      SUCCESS_NO_INSTANCES:
        84ea3f8f-d742-4455-7bc8-10612c40a833:
          x: 280
          'y': 600
