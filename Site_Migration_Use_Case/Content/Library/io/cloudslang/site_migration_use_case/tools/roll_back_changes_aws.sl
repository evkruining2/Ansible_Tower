########################################################################################################################
#!!
#! @input provider_sap: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                      Default: 'https://ec2.amazonaws.com'
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input region: The name of the region.
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.tools
flow:
  name: roll_back_changes_aws
  inputs:
    - provider_sap: 'https://ec2.amazonaws.com'
    - access_key_id: "${get_sp('site_migration.aws_key_id')}"
    - access_key:
        default: "${get_sp('site_migration.aws_key')}"
        sensitive: true
    - region: eu-west-1
    - AnsibleTowerURL: "${get_sp('site_migration.AnsibleTowerUrl')}"
    - AnsibleUsername: "${get_sp('site_migration.AnsibleUsername')}"
    - AnsiblePassword:
        default: "${get_sp('site_migration.AnsiblePassword')}"
        sensitive: true
    - TrustAllRoots: "${get_sp('site_migration.TrustAllRoots')}"
    - HostnameVerify: "${get_sp('site_migration.HostnameVerify')}"
  workflow:
    - read_stored_values:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: /var/tmp/site.csv
        publish:
          - read_text
        navigate:
          - SUCCESS: set_flow_variables
          - FAILURE: on_failure
    - set_flow_variables:
        do:
          io.cloudslang.site_migration_use_case.tools.set_flow_variables:
            - line: '${read_text}'
        publish:
          - hostid: '${a}'
          - vmid: '${b}'
          - ip_address: '${c}'
          - old_website: '${d}'
        navigate:
          - SUCCESS: modify_fw_rule
    - modify_fw_rule:
        do:
          io.cloudslang.site_migration_use_case.firewall.modify_fw_rule:
            - ip_address: '${old_website}'
            - rule_number: '999'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_host_from_awx
    - delete_rollback_data_file:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: /var/tmp/site.csv
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - delete_host_from_awx:
        do:
          io.cloudslang.redhat.ansible_tower.hosts.delete_host:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword:
                value: '${AnsiblePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - HostID: '${hostid}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: aws_undeploy_instance_v2
    - aws_undeploy_instance_v2:
        do:
          io.cloudslang.amazon.aws.ec2.aws_undeploy_instance_v2:
            - provider_sap: '${provider_sap}'
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - region: '${region}'
            - instance_id: '${vmid}'
        publish:
          - return_result
        navigate:
          - SUCCESS: delete_rollback_data_file
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_stored_values:
        x: 40
        'y': 120
      set_flow_variables:
        x: 40
        'y': 320
      modify_fw_rule:
        x: 40
        'y': 520
      delete_rollback_data_file:
        x: 440
        'y': 120
        navigate:
          5d4d278f-0dc8-6c7c-3438-1fe993e71e1d:
            targetId: e7592fcf-6bcd-409c-1fe8-812b2a132e61
            port: SUCCESS
      delete_host_from_awx:
        x: 240
        'y': 520
      aws_undeploy_instance_v2:
        x: 240
        'y': 320
    results:
      SUCCESS:
        e7592fcf-6bcd-409c-1fe8-812b2a132e61:
          x: 440
          'y': 320
