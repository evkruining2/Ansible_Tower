########################################################################################################################
#!!
#! @description: Send a ping command to all configured targets
#!
#! @input host: Ansible control node fqdn or ip address
#! @input username: Ansible control node username. Example: root
#! @input password: Ansible control node user password
#! @input module: module name to execute
#!!#
########################################################################################################################
namespace: Ansible_CLI.Samples
flow:
  name: Ping_all_targets
  inputs:
    - host
    - username
    - password:
        sensitive: true
    - module: ping
  workflow:
    - Ansible_CLI:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          Ansible_CLI.Ansible_CLI:
            - ansible_host: '${host}'
            - ansible_username: '${username}'
            - ansible_password:
                value: '${password}'
                sensitive: true
            - pattern: all
            - ansible_module: '${module}'
            - additional_options: '-v'
        publish:
          - error_message
          - stdout
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - stdout: '${stdout}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Ansible_CLI:
        x: 97
        'y': 111
        navigate:
          a0619cbe-2353-c848-8b4b-d730d0c70967:
            targetId: 8c18e1fc-4f73-3b15-d783-387f27a1ff45
            port: SUCCESS
    results:
      SUCCESS:
        8c18e1fc-4f73-3b15-d783-387f27a1ff45:
          x: 345
          'y': 115
