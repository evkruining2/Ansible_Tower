########################################################################################################################
#!!
#! @input skipstatus: Skip instance when status is set to this value
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.aws
flow:
  name: collect_co2e_for_aws_subscription
  inputs:
    - aws_accesskey: "${get_sp('io.cloudslang.co2e_collection.aws_accesskey')}"
    - aws_secretkey: "${get_sp('io.cloudslang.co2e_collection.aws_secretkey')}"
    - skipstatus: none
  workflow:
    - aws_get_all_instances_in_all_regions:
        do:
          io.cloudslang.co2e_collection.aws.subflows.aws_regions:
            - identity: '${aws_accesskey}'
            - credential:
                value: '${aws_secretkey}'
                sensitive: true
            - skipstatus: '${skipstatus}'
        publish:
          - all_ec2_instances
        navigate:
          - FAILURE: on_failure
          - SUCCESS: aws_get_co2e_for_all_instances
    - aws_get_co2e_for_all_instances:
        do:
          io.cloudslang.co2e_collection.aws.subflows.get_co2e:
            - aws_instanes: '${all_ec2_instances}'
        publish:
          - total_co2e: '${co2e}'
          - all_aws_instances: '${instances}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - total_co2e: '${total_co2e}'
    - all_aws_instances: '${all_aws_instances}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      aws_get_all_instances_in_all_regions:
        x: 120
        'y': 80
      aws_get_co2e_for_all_instances:
        x: 320
        'y': 80
        navigate:
          dc432169-a862-c603-b80e-14b442baf890:
            targetId: 2e9ad66a-d39c-f331-5655-f51850c74aca
            port: SUCCESS
    results:
      SUCCESS:
        2e9ad66a-d39c-f331-5655-f51850c74aca:
          x: 520
          'y': 80
