########################################################################################################################
#!!
#! @description: Run a job template, identified by the template ID and wait for it to finish
#!
#! @input awx_cli_host: Hostname of IP address of the host that has the AWX CLI tools installed. Example: awxcli.example.com
#! @input awx_cli_username: Username of the awx cli host. Example: root
#! @input awx_cli_password: Password for the (root) user on the awx cli host
#! @input awx_host: AWX/Tower URL. Example: http://awx.example.com
#! @input awx_username: AWX/Tower username. Example: admin
#! @input awx_password: AWX/Tower user password
#! @input template: Template ID
#!
#! @output job_id: The AWX job ID
#! @output stdout: Output from the target servers
#! @output job_details: Full job details in JSON format
#! @output job_status: Status of the job
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.AWX_CLI.Samples
flow:
  name: run_job_template
  inputs:
    - awx_cli_host
    - awx_cli_username
    - awx_cli_password:
        sensitive: true
    - awx_host
    - awx_username
    - awx_password:
        sensitive: true
    - template
  workflow:
    - awx_get_token:
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
          - SUCCESS: launch_job_template
    - launch_job_template:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${awx_cli_host}'
            - command: "${'awx --conf.host '+awx_host+' --conf.token '+token+' job_templates launch '+template}"
            - username: '${awx_cli_username}'
            - password:
                value: '${awx_cli_password}'
                sensitive: true
            - character_set: null
            - use_shell: null
            - remove_escape_sequences: 'true'
        publish:
          - job_id: '${cs_extract_number(cs_json_query(return_result,"$.id"),)}'
        navigate:
          - SUCCESS: get_job_status
          - FAILURE: on_failure
    - get_job_status:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${awx_cli_host}'
            - command: "${'awx --conf.host '+awx_host+' --conf.token '+token+' jobs get '+job_id}"
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
    - get_stdout:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${awx_cli_host}'
            - command: "${'awx --conf.host '+awx_host+' --conf.token '+token+' jobs stdout '+job_id}"
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
  outputs:
    - job_id: '${job_id}'
    - stdout: '${stdout}'
    - job_details: '${job_details}'
    - job_status: '${job_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      launch_job_template:
        x: 214
        'y': 74
      Is_status_runnning:
        x: 794
        'y': 275
      Is_status_successful:
        x: 392
        'y': 264
      awx_get_token:
        x: 41
        'y': 76
      get_stdout:
        x: 389
        'y': 456
        navigate:
          9a3838c8-d356-b9c3-f462-55cd96a0ee4c:
            targetId: ca0f2697-593d-a271-a16c-fb27d8c51410
            port: SUCCESS
      Is_status_failed:
        x: 599
        'y': 456
        navigate:
          a7182614-59b0-fa47-ca78-212c57906367:
            targetId: 6e5cd0b4-70b4-5820-df00-195b84731f06
            port: SUCCESS
      sleep:
        x: 592
        'y': 90
      get_job_status:
        x: 387
        'y': 75
      Is_status_pending:
        x: 597
        'y': 273
    results:
      SUCCESS:
        ca0f2697-593d-a271-a16c-fb27d8c51410:
          x: 392
          'y': 641
      FAILURE:
        6e5cd0b4-70b4-5820-df00-195b84731f06:
          x: 597
          'y': 624
