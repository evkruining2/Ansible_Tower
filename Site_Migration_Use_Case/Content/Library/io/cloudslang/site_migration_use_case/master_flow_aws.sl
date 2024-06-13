########################################################################################################################
#!!
#! @input endpoint: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                  Default: 'https://ec2.amazonaws.com'
#! @input access_key_id: The ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: The secret access key associated with your Amazon AWS account.
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
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case
flow:
  name: master_flow_aws
  inputs:
    - endpoint: 'https://ec2.amazonaws.com'
    - access_key_id: "${get_sp('site_migration.aws_key_id')}"
    - access_key:
        default: "${get_sp('site_migration.aws_key')}"
        sensitive: true
    - image_id: ami-0eb11ab33f229b26c
    - region: eu-west-1
    - key_pair_name: web
    - instance_type: t2.micro
    - security_group_id_list: sg-00668a8f1231cee1e
    - subnet_id: subnet-0cfcaf6c3785caa07
    - fw_hostname: "${get_sp('site_migration.fw_hostname')}"
    - fw_username: "${get_sp('site_migration.fw_username')}"
    - fw_password:
        default: "${get_sp('site_migration.fw_password')}"
        sensitive: true
    - TrustAllRoots: "${get_sp('site_migration.TrustAllRoots')}"
    - HostnameVerify: "${get_sp('site_migration.HostnameVerify')}"
  workflow:
    - create_aws_debian_instance:
        do:
          io.cloudslang.site_migration_use_case.aws.create_debian_instance:
            - image_id: '${image_id}'
            - region: '${region}'
            - key_pair_name: '${key_pair_name}'
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - instance_type: '${instance_type}'
            - security_group_id_list: '${security_group_id_list}'
            - subnet_id: '${subnet_id}'
            - endpoint: '${endpoint}'
        publish:
          - ip_address
          - public_dns_name
          - instance_state
          - instance_id
        navigate:
          - SUCCESS: set_root_password
          - FAILURE: on_failure
    - ansible_update_os_on_target_server_install_apache_db_php:
        do:
          io.cloudslang.site_migration_use_case.ansible.update_os_on_target_server:
            - AnsibleTowerURL: "${get_sp('site_migration.AnsibleTowerUrl')}"
            - AnsibleUsername: "${get_sp('site_migration.AnsibleUsername')}"
            - AnsiblePassword:
                value: "${get_sp('site_migration.AnsiblePassword')}"
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - HostName: '${ip_address}'
        publish:
          - HostID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: scp_payload
    - scp_payload:
        do:
          io.cloudslang.site_migration_use_case.ssh.scp_payload:
            - target: '${ip_address}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: db_populate_sql_db
    - db_populate_sql_db:
        do:
          io.cloudslang.site_migration_use_case.ssh.populate_sql_db:
            - target: '${ip_address}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: modify_fw_rule
    - modify_fw_rule:
        do:
          io.cloudslang.site_migration_use_case.firewall.modify_fw_rule:
            - firewall: '${fw_hostname}'
            - username: '${fw_username}'
            - password:
                value: '${fw_password}'
                sensitive: true
            - ip_address: '${ip_address}'
            - rule_number: '999'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_values_to_file
    - write_values_to_file:
        do:
          io.cloudslang.site_migration_use_case.tools.write_values_to_file:
            - hostid: '${HostID}'
            - vmid: '${instance_id}'
            - ip_address: '${ip_address}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - set_root_password:
        do:
          io.cloudslang.site_migration_use_case.ssh.set_root_password:
            - ip_address: '${ip_address}'
        navigate:
          - SUCCESS: ansible_update_os_on_target_server_install_apache_db_php
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
      set_root_password:
        x: 160
        'y': 400
      write_values_to_file:
        x: 760
        'y': 80
        navigate:
          68c1aa10-c804-232e-b326-cbf3fccb3faa:
            targetId: 2ece7d65-24f3-d98e-9743-fb9e2e3f43e7
            port: SUCCESS
      ansible_update_os_on_target_server_install_apache_db_php:
        x: 280
        'y': 80
      scp_payload:
        x: 400
        'y': 400
      db_populate_sql_db:
        x: 520
        'y': 80
      modify_fw_rule:
        x: 640
        'y': 400
      create_aws_debian_instance:
        x: 40
        'y': 80
    results:
      SUCCESS:
        2ece7d65-24f3-d98e-9743-fb9e2e3f43e7:
          x: 880
          'y': 400
