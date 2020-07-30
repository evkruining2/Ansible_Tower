########################################################################################################################
#!!
#! @description: Install the Puppet agent on a unix target
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input host: The hostname or ip address of the target node to install the PE agent. Example: pupnode1.example.com
#! @input username: The username to login to the target node. Example: root
#! @input password: Password for the user on the target node
#! @input port: SSH listening port. Default: 22
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.nodes
flow:
  name: install_agent_unix
  inputs:
    - PuppetEnterpriseURL
    - host
    - username
    - password:
        sensitive: true
    - port:
        default: '22'
        required: false
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - port: '${port}'
            - command: "${'curl -k '+PuppetEnterpriseURL+':8140/packages/current/install.bash | sudo bash'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - standard_out
          - standard_err
          - command_return_code
          - return_result
          - exception
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: command_return_code_zero
    - command_return_code_zero:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${command_return_code}'
            - second_string: '0'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - stderr: '${standard_err}'
    - stdout: '${standard_out}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 130
        'y': 97
        navigate:
          96b577c5-9015-c618-5434-9e69e47dab8e:
            targetId: 52a9b628-c770-9450-1cd1-f9c65a133161
            port: SUCCESS
      command_return_code_zero:
        x: 278
        'y': 260
        navigate:
          1cb7a859-0fc2-e7fc-a948-ded6869ae7bc:
            targetId: 52a9b628-c770-9450-1cd1-f9c65a133161
            port: SUCCESS
    results:
      SUCCESS:
        52a9b628-c770-9450-1cd1-f9c65a133161:
          x: 426
          'y': 91
