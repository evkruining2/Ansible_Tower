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
  name: create_linux_user
  inputs:
    - linux_host: mail.example.com
    - linux_username: oouser
    - linux_password:
        default: "${get_sp('onboarding.ad_password')}"
        sensitive: true
    - first_name
    - last_name
    - login_name
  workflow:
    - create_user_on_linux:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${linux_host}'
            - command: "${'sudo useradd '+login_name+' -c \"'+first_name+' '+last_name+'\" -s /bin/bash'}"
            - username: '${linux_username}'
            - password:
                value: '${linux_password}'
                sensitive: true
        navigate:
          - SUCCESS: set_user_password
          - FAILURE: on_failure
    - set_user_password:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${linux_host}'
            - command: "${'echo \"'+login_name+':Cloud@123\" | sudo chpasswd'}"
            - username: '${linux_username}'
            - password:
                value: '${linux_password}'
                sensitive: true
        navigate:
          - SUCCESS: send_welcome_email
          - FAILURE: on_failure
    - send_welcome_email:
        do:
          io.cloudslang.onboarding_new_user.email.send_email:
            - email_to: "${login_name+'@example.com'}"
            - subject: 'Welcome to the club!'
            - body: "${'Hello '+first_name+'\\n\\nThis message shows you that you able to login to the email system and receive messages.\\n\\nCongratulations!\\n\\nHave a nice day!\\n\\nBest regards,\\nYour system administrator.'}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_user_on_linux:
        x: 80
        'y': 160
      set_user_password:
        x: 280
        'y': 160
      send_welcome_email:
        x: 440
        'y': 160
        navigate:
          c7e2c9b9-e2b5-1cab-df4c-b2c2870bf966:
            targetId: d1755ce3-568a-d853-44de-0d106941dc6b
            port: SUCCESS
    results:
      SUCCESS:
        d1755ce3-568a-d853-44de-0d106941dc6b:
          x: 640
          'y': 160
