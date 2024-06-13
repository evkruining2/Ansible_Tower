########################################################################################################################
#!!
#! @input username: Username to connect as.
#! @input password: Password of user.
#!                  Optional
#! @input target: Hostname or IP address.
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.ssh
flow:
  name: allow_ssh_root_login
  inputs:
    - username
    - password:
        sensitive: true
    - target
  workflow:
    - modify_sshd_config:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: localhost
            - command: /root/ssh_access.sh
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - arguments: '${target}'
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      modify_sshd_config:
        x: 160
        'y': 240
      sleep:
        x: 360
        'y': 240
        navigate:
          67f8fd02-537f-531f-b77b-0305cdc8ddb5:
            targetId: 4a344160-c35e-a391-a19f-40e0a900e3bd
            port: SUCCESS
    results:
      SUCCESS:
        4a344160-c35e-a391-a19f-40e0a900e3bd:
          x: 600
          'y': 240
