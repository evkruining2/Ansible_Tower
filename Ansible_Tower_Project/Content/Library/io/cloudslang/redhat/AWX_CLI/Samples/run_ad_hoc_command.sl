########################################################################################################################
#!!
#! @description: Run an ad-hoc command to target servers in the specified inventory ID, using the specified credential ID
#!
#! @input awx_cli_host: Hostname of IP address of the host that has the AWX CLI tools installed. Example: awxcli.example.com
#! @input awx_cli_username: Username of the awx cli host. Example: root
#! @input awx_cli_password: Password for the (root) user on the awx cli host
#! @input awx_host: AWX/Tower URL. Example: http://awx.example.com
#! @input awx_username: AWX/Tower username. Example: admin
#! @input awx_password: AWX/Tower user password
#! @input inventory: Inventory ID
#! @input credential: Credentials ID
#! @input module_name: Module to run. (Valid options are: command,shell,yum,apt,apt_key,apt_repository,apt_rpm,service,group,user,mount,ping,selinux,setup,win_ping,win_service,win_updates,win_group,win_user)
#! @input module_args: Additional arguments for the module. Example: when using the command module, arguments could be something like "ping -c 3 localhost" (no quotes required)
#! @input subset: Further limit selected hosts to an additional pattern
#!
#! @output stdout: Output of the ad-hoc command
#! @output error_message: Error message if there is one
#! @output job_id: AWX job ID
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.AWX_CLI.Samples
flow:
  name: run_ad_hoc_command
  inputs:
    - awx_cli_host
    - awx_cli_username
    - awx_cli_password:
        sensitive: true
    - awx_host
    - awx_username
    - awx_password:
        sensitive: true
    - inventory
    - credential
    - module_name
    - module_args:
        required: false
    - subset:
        required: false
  workflow:
    - awx_get_token:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          AWX_CLI.awx_get_token:
            - awx_cli_host: '${awx_cli_host}'
            - awx_cli_username: '${awx_cli_username}'
            - awx_cli_password:
                value: '${awx_cli_password}'
                sensitive: true
            - awx_host: '${awx_host}'
            - awx_username: '${awx_username}'
            - awx_password:
                value: '${awx_password}'
                sensitive: true
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: contruct_ssh_command
    - contruct_ssh_command:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: awx
            - text: "${' --conf.host '+awx_host+' --conf.token '+token+' ad_hoc_commands create --inventory '+inventory+' --credential '+credential+' --module_name '+module_name}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_subset_var
    - check_subset_var:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${subset}'
        publish: []
        navigate:
          - IS_NULL: check_module_args
          - IS_NOT_NULL: append_subset
    - append_subset:
        worker_group: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' --limit '+subset}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_module_args
    - check_module_args:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${module_args}'
        navigate:
          - IS_NULL: run_ad_hoc_command
          - IS_NOT_NULL: append_module_args
    - append_module_args:
        worker_group: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' --module_args \"'+module_args+'\"'}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: run_ad_hoc_command
    - run_ad_hoc_command:
        worker_group: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${awx_cli_host}'
            - command: '${ssh_command}'
            - username: '${awx_cli_username}'
            - password:
                value: '${awx_cli_password}'
                sensitive: true
            - character_set: null
            - use_shell: null
            - remove_escape_sequences: 'true'
        publish:
          - job_id: '${cs_extract_number(cs_json_query(return_result,"$.id"),)}'
          - stdout: '${standard_out}'
          - error_message: '${standard_err}'
        navigate:
          - SUCCESS: get_job_status
          - FAILURE: on_failure
    - get_job_status:
        worker_group: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${awx_cli_host}'
            - command: "${'awx --conf.host '+awx_host+' --conf.token '+token+' ad_hoc_commands get '+job_id}"
            - username: '${awx_cli_username}'
            - password:
                value: '${awx_cli_password}'
                sensitive: true
            - character_set: null
            - use_shell: null
            - remove_escape_sequences: 'true'
        publish:
          - job_details: '${return_result}'
          - job_status: '${cs_substring(cs_json_query(return_result,"$.status"),2,-2)}'
        navigate:
          - SUCCESS: Is_status_successful
          - FAILURE: on_failure
    - Is_status_successful:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: successful
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_stdout
          - FAILURE: Is_status_failed
    - Is_status_failed:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: failed
            - ignore_case: 'true'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: Is_status_pending
    - Is_status_pending:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: pending
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: Is_status_runnning
    - Is_status_runnning:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_job_status
          - FAILURE: on_failure
    - get_stdout:
        worker_group: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${awx_cli_host}'
            - command: "${'awx --conf.host '+awx_host+' --conf.token '+token+' ad_hoc_commands stdout '+job_id+' -f human'}"
            - username: '${awx_cli_username}'
            - password:
                value: '${awx_cli_password}'
                sensitive: true
            - character_set: null
            - use_shell: null
            - remove_escape_sequences: 'true'
        publish:
          - stdout: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - stdout: '${stdout}'
    - error_message: '${error_message}'
    - job_id: '${job_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      run_ad_hoc_command:
        x: 211
        'y': 423
      check_subset_var:
        x: 414
        'y': 65
      append_subset:
        x: 597
        'y': 72
      append_module_args:
        x: 212
        'y': 248
      Is_status_runnning:
        x: 589
        'y': 593
      Is_status_successful:
        x: 415
        'y': 415
      awx_get_token:
        x: 39
        'y': 73
      get_stdout:
        x: 596
        'y': 244
        navigate:
          b29fd582-19f5-242c-3db2-bc7f99227190:
            targetId: 8948f088-0b38-969e-bedc-3b1eede33695
            port: SUCCESS
      Is_status_failed:
        x: 590
        'y': 416
        navigate:
          990842fa-1228-0de8-318d-76e5d790d7ed:
            targetId: 0c3af6a8-2954-88e2-6fea-b843ff5d0e28
            port: SUCCESS
      sleep:
        x: 422
        'y': 599
      check_module_args:
        x: 415
        'y': 242
      contruct_ssh_command:
        x: 213
        'y': 73
      get_job_status:
        x: 211
        'y': 598
      Is_status_pending:
        x: 800
        'y': 591
        navigate:
          2d0cb315-cf64-5c63-288d-8042a2e5448b:
            vertices:
              - x: 684
                'y': 730
              - x: 594
                'y': 728
            targetId: sleep
            port: SUCCESS
    results:
      SUCCESS:
        8948f088-0b38-969e-bedc-3b1eede33695:
          x: 798
          'y': 246
      FAILURE:
        0c3af6a8-2954-88e2-6fea-b843ff5d0e28:
          x: 799
          'y': 419
