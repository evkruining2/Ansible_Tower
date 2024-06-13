########################################################################################################################
#!!
#! @input linux_host: Hostname or IP address.
#! @input linux_username: Username to connect as.
#! @input linux_password: Password of user.
#!                        Optional
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user.application_server
flow:
  name: delete_linux_user
  inputs:
    - linux_host: mail.example.com
    - linux_username: oouser
    - linux_password:
        default: "${get_sp('onboarding.ad_password')}"
        sensitive: true
    - login_name
  workflow:
    - remove_user_from_linux:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${linux_host}'
            - command: "${'sudo userdel -r '+login_name}"
            - username: '${linux_username}'
            - password:
                value: '${linux_password}'
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
      remove_user_from_linux:
        x: 80
        'y': 160
        navigate:
          9649c227-7b19-dd5d-4041-8cfbc29ce479:
            targetId: d1755ce3-568a-d853-44de-0d106941dc6b
            port: SUCCESS
    results:
      SUCCESS:
        d1755ce3-568a-d853-44de-0d106941dc6b:
          x: 480
          'y': 160
