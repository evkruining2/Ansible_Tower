########################################################################################################################
#!!
#! @description: Get a job status, identified by the job ID
#!
#! @input awx_cli_host: Hostname of IP address of the host that has the AWX CLI tools installed. Example: awxcli.example.com
#! @input awx_cli_username: Username of the awx cli host. Example: root
#! @input awx_cli_password: Password for the (root) user on the awx cli host
#! @input awx_host: AWX/Tower URL. Example: http://awx.example.com
#! @input awx_username: AWX/Tower username. Example: admin
#! @input awx_password: AWX/Tower user password
#! @input job_id: Job ID
#!!#
########################################################################################################################
namespace: AWX_CLI
flow:
  name: get_job_status
  inputs:
    - awx_cli_host
    - awx_cli_username
    - awx_cli_password:
        sensitive: true
    - awx_host
    - awx_username
    - awx_password:
        sensitive: true
    - job_id
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
          - SUCCESS: get_job_status
    - get_job_status:
        worker_group: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
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
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - job_details: '${job_details}'
    - job_status: '${job_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      awx_get_token:
        x: 134
        'y': 121.5
      get_job_status:
        x: 341
        'y': 124
        navigate:
          747208f5-8f40-5c4f-72df-793a101c5143:
            targetId: ca0f2697-593d-a271-a16c-fb27d8c51410
            port: SUCCESS
    results:
      SUCCESS:
        ca0f2697-593d-a271-a16c-fb27d8c51410:
          x: 506
          'y': 110.5
