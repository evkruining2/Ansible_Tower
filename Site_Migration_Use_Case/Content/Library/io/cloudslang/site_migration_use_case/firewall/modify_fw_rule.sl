########################################################################################################################
#!!
#! @input firewall: Hostname or IP address
#! @input username: Username to connect as
#! @input password: Password of user
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.firewall
flow:
  name: modify_fw_rule
  inputs:
    - firewall: 192.168.2.175
    - username: admin
    - password:
        default: "${get_sp('site_migration.pvePassword')}"
        sensitive: true
    - ip_address
    - rule_number
  workflow:
    - modify_fw_port_forward_rule:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${firewall}'
            - command: "${'/home/admin/fw_script.sh '+rule_number+' '+ip_address}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      modify_fw_port_forward_rule:
        x: 160
        'y': 120
        navigate:
          016a702d-2714-204d-4fa2-10fa6c925c41:
            targetId: 96219a5e-1fe0-e8f0-3d65-df57f82fc561
            port: SUCCESS
    results:
      SUCCESS:
        96219a5e-1fe0-e8f0-3d65-df57f82fc561:
          x: 400
          'y': 120
