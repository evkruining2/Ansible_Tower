########################################################################################################################
#!!
#! @description: Main flow to query all instances within an AWS account and calculate the average cumulative CO2e per 24hr and the average CO2e per 24hr per instance
#!
#! @input aws_accesskey: AWS Access Key
#! @input aws_secretkey: AWS Access Secret Key
#! @input my_aws_regions: Optional - comma-separated list of aws regions to search for instances. If left empty, the flow will search through all aws regions. Example: eu-west-1,us-east-2,us-west-1
#! @input skipstatus: Optional - Skip instance when status is set to this value. Example: stopped
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - proxy server password associated with the proxy_username
#!                        input value.
#!                        Default: ''
#! @input worker_group: Optional - RAS worker group to use. Default: RAS_Operator_Path
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!
#! @output total_co2e: Cumulative CO2e per 24h for all instances
#! @output all_aws_instances: List of all AWS instances and their CO2e details
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.aws
flow:
  name: collect_co2e_for_aws_subscription
  inputs:
    - aws_accesskey: "${get_sp('io.cloudslang.co2e_collection.aws_accesskey')}"
    - aws_secretkey: "${get_sp('io.cloudslang.co2e_collection.aws_secretkey')}"
    - my_aws_regions:
        required: false
    - skipstatus:
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
    - trust_all_roots:
        default: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
        required: false
    - x_509_hostname_verifier:
        default: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
        required: false
  workflow:
    - aws_get_all_instances_in_all_regions:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.aws.subflows.aws_regions:
            - identity: '${aws_accesskey}'
            - credential:
                value: '${aws_secretkey}'
                sensitive: true
            - my_aws_regions: '${my_aws_regions}'
            - skipstatus: '${skipstatus}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish:
          - all_ec2_instances
        navigate:
          - FAILURE: on_failure
          - SUCCESS: aws_get_co2e_for_all_instances
    - aws_get_co2e_for_all_instances:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.aws.subflows.get_co2e:
            - aws_instanes: '${all_ec2_instances}'
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
