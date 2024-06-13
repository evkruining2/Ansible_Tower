########################################################################################################################
#!!
#! @input host: Hostname or IP address.
#! @input username: Username to connect as.
#! @input password: Password of user.
#!                  Optional
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.ssh
flow:
  name: set_root_password
  inputs:
    - host: localhost
    - username: root
    - password:
        default: "${get_sp('site_migration.pvePassword')}"
        sensitive: true
    - ip_address
  workflow:
    - set_root_password:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'/root/chpasswd.sh '+ip_address}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: enable_ssh_root_access
          - FAILURE: on_failure
    - enable_ssh_root_access:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'/root/enable_ssh.sh '+ip_address}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_root_password:
        x: 80
        'y': 120
      enable_ssh_root_access:
        x: 280
        'y': 120
        navigate:
          d43eb583-54f3-6cdc-1b2c-c9b7063c2cf4:
            targetId: dcf905a4-5415-da5b-d825-5f22154199ad
            port: SUCCESS
    results:
      SUCCESS:
        dcf905a4-5415-da5b-d825-5f22154199ad:
          x: 480
          'y': 120
