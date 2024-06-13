########################################################################################################################
#!!
#! @input image_id: The ID of the AMI, which you can get by calling <DescribeImages>.For more information go to:
#!                  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html
#!                  Example: "ami-abcdef12"
#! @input region: The region where to deploy the instance. To select a specific region, you either mention the endpoint
#!                corresponding to that region or provide a value to region input. In case both serviceEndpoint and
#!                region are specified, the serviceEndpoint will be used and region will be ignored.
#!                Examples: us-east-1, us-east-2, us-west-1, us-west-2, ca-central-1, eu-west-1, eu-central-1,
#!                eu-west-2, ap-northeast-1, ap-northeast-2, ap-southeast-1, ap-southeast-2, ap-south-1, sa-east-1
#! @input key_pair_name: The name of the key pair. You can create a key pair using <CreateKeyPair> or <ImportKeyPair>.
#!                       Important: If you do not specify a key pair, you can't connect to the instance unless you choose
#!                       an AMI that is configured to allow users another way to log in.
#!                       Default: ''
#!                       Optional
#! @input access_key_id: The ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: The secret access key associated with your Amazon AWS account.
#! @input instance_type: Instance type. For more information, see Instance Types in the Amazon Elastic Compute Cloud
#!                       User Guide.
#!                       Valid values: t1.micro | t2.nano | t2.micro | t2.small | t2.medium | t2.large | m1.small |
#!                       m1.medium | m1.large | m1.xlarge | m3.medium | m3.large | m3.xlarge | m3.2xlarge |
#!                       m4.large | m4.xlarge | m4.2xlarge | m4.4xlarge | m4.10xlarge | m2.xlarge |
#!                       m2.2xlarge | m2.4xlarge | cr1.8xlarge | r3.large | r3.xlarge | r3.2xlarge |
#!                       r3.4xlarge | r3.8xlarge | x1.4xlarge | x1.8xlarge | x1.16xlarge | x1.32xlarge |
#!                       i2.xlarge | i2.2xlarge | i2.4xlarge | i2.8xlarge | hi1.4xlarge | hs1.8xlarge |
#!                       c1.medium | c1.xlarge | c3.large | c3.xlarge | c3.2xlarge | c3.4xlarge | c3.8xlarge |
#!                       c4.large | c4.xlarge | c4.2xlarge | c4.4xlarge | c4.8xlarge | cc1.4xlarge |
#!                       cc2.8xlarge | g2.2xlarge | g2.8xlarge | cg1.4xlarge | d2.xlarge | d2.2xlarge |
#!                       d2.4xlarge | d2.8xlarge
#!                       Default: 't2.micro'
#!                       Optional
#! @input security_group_id_list: IDs of the security groups for the instance.
#!                                Example: "sg-01234567"
#! @input subnet_id: String that contains one or more subnet IDs. If you launch into EC2 Classic then supply values for
#!                   this input and don't supply values for Private IP Addresses string. [EC2-VPC] The ID of the subnet
#!                   to launch the instance into.
#! @input endpoint: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                  Default: 'https://ec2.amazonaws.com'
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.aws
flow:
  name: create_debian_instance
  inputs:
    - image_id: ami-0eb11ab33f229b26c
    - region: eu-west-1
    - key_pair_name: web
    - access_key_id: "${get_sp('site_migration.aws_key_id')}"
    - access_key:
        default: "${get_sp('site_migration.aws_key')}"
        sensitive: true
    - instance_type: t2.micro
    - security_group_id_list: sg-00668a8f1231cee1e
    - subnet_id: subnet-0cfcaf6c3785caa07
    - endpoint: 'https://ec2.amazonaws.com'
  workflow:
    - aws_deploy_instance_v6:
        do:
          io.cloudslang.amazon.aws.ec2.aws_deploy_instance_v6:
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - region: '${region}'
            - image_id: '${image_id}'
            - subnet_id: '${subnet_id}'
            - instance_name_prefix: web
            - instance_type: '${instance_type}'
            - key_pair_name: '${key_pair_name}'
            - security_group_id_list: '${security_group_id_list}'
            - business_unit: Sales
            - product_id: web123
            - product_name: web
            - environment: testing
        publish:
          - ip_address
          - public_dns_name
          - instance_state
          - instance_id
        navigate:
          - SUCCESS: sleep_some_more
          - FAILURE: on_failure
    - sleep_some_more:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ip_address: '${ip_address}'
    - public_dns_name: '${public_dns_name}'
    - instance_state: '${instance_state}'
    - instance_id: '${instance_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      aws_deploy_instance_v6:
        x: 120
        'y': 120
      sleep_some_more:
        x: 240
        'y': 360
        navigate:
          35374d07-def4-ed5d-f2b8-77beb48e9937:
            targetId: 07b5925f-905e-d486-13e1-1b2bce3972b8
            port: SUCCESS
    results:
      SUCCESS:
        07b5925f-905e-d486-13e1-1b2bce3972b8:
          x: 440
          'y': 160
