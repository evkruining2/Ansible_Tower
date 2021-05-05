########################################################################################################################
#!!
#! @description: Run ad-hoc Ansible playbooks using the Ansible-playbook cli over ssh
#!
#! @input ansible_host: Ansible control node fqdn or ip address
#! @input ansible_username: Ansible control node username. Example: root
#! @input ansible_password: Ansible control node user password
#! @input playbook: Playbook(s)
#! @input inventory: specify inventory host path or comma separated host list
#! @input subset: further limit selected hosts to an additional pattern
#! @input tags: only run plays and tasks tagged with these values
#! @input extra_vars: set additional variables as key=value or YAML/JSON, if filename prepend with @
#! @input additional_options: Add any additional options for the Ansible command. Example: -v for extra verbose output
#!!#
########################################################################################################################
namespace: Ansible_CLI
flow:
  name: Ansible_Playbook_CLI
  inputs:
    - ansible_host
    - ansible_username
    - ansible_password:
        sensitive: true
    - playbook: /var/lib/awx/projects/reboot.yaml
    - inventory:
        required: false
    - subset:
        required: false
    - tags:
        required: false
    - extra_vars:
        required: false
    - additional_options:
        default: '-v'
        required: false
  workflow:
    - contruct_ssh_command:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'ansible-playbook '
            - text: '${playbook}'
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_subset_var
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${ansible_host}'
            - command: '${ssh_command}'
            - username: '${ansible_username}'
            - password:
                value: '${ansible_password}'
                sensitive: true
            - timeout: '600000'
        publish:
          - output: '${return_result}'
          - command_return_code
        navigate:
          - SUCCESS: check_command_return_code
          - FAILURE: on_failure
    - check_command_return_code:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${command_return_code}'
            - value2: '0'
        navigate:
          - GREATER_THAN: something_went_wrong
          - EQUALS: SUCCESS
          - LESS_THAN: something_went_wrong
    - something_went_wrong:
        do:
          io.cloudslang.base.utils.do_nothing:
            - error_message: '${output}'
        publish:
          - error_message
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - check_subset_var:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${subset}'
        publish: []
        navigate:
          - IS_NULL: check_intentory_var
          - IS_NOT_NULL: append_subset
    - append_subset:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -l '+subset}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_intentory_var
    - check_intentory_var:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${inventory}'
        navigate:
          - IS_NULL: check_tags
          - IS_NOT_NULL: append_inventory
    - append_inventory:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -i '+inventory}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_tags
    - append_tags:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -t \"'+tags+'\"'}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_extra_vars
    - check_tags:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${tags}'
        navigate:
          - IS_NULL: check_extra_vars
          - IS_NOT_NULL: append_tags
    - check_extra_vars:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${extra_vars}'
        navigate:
          - IS_NULL: check_additional_options
          - IS_NOT_NULL: append_extra_vars
    - append_extra_vars:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -e \"'+extra_vars+'\"'}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_additional_options
    - check_additional_options:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${additional_options}'
        navigate:
          - IS_NULL: ssh_command
          - IS_NOT_NULL: append_additional_options
    - append_additional_options:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' '+additional_options+' '}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: ssh_command
  outputs:
    - error_message: '${error_message}'
    - stdout: '${output}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      append_extra_vars:
        x: 786
        'y': 80
      check_subset_var:
        x: 118
        'y': 242
      append_subset:
        x: 213
        'y': 75
      something_went_wrong:
        x: 301
        'y': 424
        navigate:
          6ec9b37e-fdb7-4fc1-a33c-2eb1a02be78e:
            targetId: e87f8329-f2ad-d5a2-046c-cc583d282bfe
            port: SUCCESS
      check_intentory_var:
        x: 303
        'y': 240
      append_additional_options:
        x: 885
        'y': 425
      check_tags:
        x: 480
        'y': 239
      check_command_return_code:
        x: 485
        'y': 424
        navigate:
          390a904f-acf3-8745-17a7-8e17774c9442:
            targetId: c03bc0a5-a290-a627-f56c-bc434ca4c253
            port: EQUALS
      check_extra_vars:
        x: 677
        'y': 240
      ssh_command:
        x: 682
        'y': 424
      append_inventory:
        x: 388
        'y': 75
      contruct_ssh_command:
        x: 37
        'y': 74
      check_additional_options:
        x: 885
        'y': 237
      append_tags:
        x: 574
        'y': 73
    results:
      SUCCESS:
        c03bc0a5-a290-a627-f56c-bc434ca4c253:
          x: 481
          'y': 609
      FAILURE:
        e87f8329-f2ad-d5a2-046c-cc583d282bfe:
          x: 296
          'y': 609
