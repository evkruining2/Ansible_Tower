########################################################################################################################
#!!
#! @input row_number: select a number between 1 and 10
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user
flow:
  name: master_flow
  inputs:
    - row_number: '1'
  workflow:
    - read_xls_data:
        do:
          io.cloudslang.onboarding_new_user.xls_processing.read_xls_data:
            - row_number: '${row_number}'
        publish:
          - first_name
          - last_name
          - login_name
          - email_address
          - employee_id
          - phone_number
        navigate:
          - FAILURE: send_email_on_error
          - SUCCESS: create_user_in_hrm
    - create_ad_user:
        do:
          io.cloudslang.onboarding_new_user.active_directory.create_ad_user:
            - first_name: '${first_name}'
            - last_name: '${last_name}'
            - login_name: '${login_name}'
            - email_address: '${email_address}'
            - employee_id: '${employee_id}'
            - phone_number: '${phone_number}'
        navigate:
          - SUCCESS: create_linux_user_and_mailbox
          - FAILURE: send_email_on_error
    - send_email_to_admin:
        do:
          io.cloudslang.onboarding_new_user.email.send_email:
            - email_to: oouser@example.com
            - first_name: '${first_name}'
            - last_name: '${last_name}'
            - login_name: '${login_name}'
            - email_address: '${email_address}'
            - phone_number: '${phone_number}'
            - employee_id: '${employee_id}'
            - subject: A new user hase been created on the system
            - body: "${'Dear OO User,\\n\\nCongratulations! A new user has just successfully been created on our system.\\n\\nThis is what happened:\\n\\nFirst Name:        '+first_name+'\\nLast Name:      '+last_name+'\\nFull Name:       '+first_name+' '+last_name+'\\nLogin Name:       '+login_name+'\\nEmail Address:      '+email_address+'\\nPhone Number:        '+phone_number+'\\nEmployee ID:       '+employee_id+'\\n\\nHave a nice day!\\n\\nBest regards,\\nYour system administrator\\n'}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - create_linux_user_and_mailbox:
        do:
          io.cloudslang.onboarding_new_user.application_server.create_linux_user:
            - first_name: '${first_name}'
            - last_name: '${last_name}'
            - login_name: '${login_name}'
        navigate:
          - FAILURE: send_email_on_error
          - SUCCESS: send_email_to_admin
    - create_user_in_hrm:
        do:
          io.cloudslang.onboarding_new_user.hrm.create_user_in_hrm:
            - first_name: '${first_name}'
            - last_name: '${last_name}'
            - employee_id: '${employee_id}'
        navigate:
          - FAILURE: send_email_on_error
          - SUCCESS: create_ad_user
    - send_email_on_error:
        do:
          io.cloudslang.onboarding_new_user.email.send_email:
            - subject: Oh dear... Something went wrong
            - body: "Dear Administrator,\\n\\nSomething in the onboarding of the new user wend wrong..\\n\\nPlease investigate.\\n\\nBest regards,\\nOperations Orchestrations"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_xls_data:
        x: 40
        'y': 120
      create_ad_user:
        x: 360
        'y': 120
      send_email_to_admin:
        x: 680
        'y': 120
        navigate:
          6d78d92c-f4e9-351f-8c54-161fccde5cbb:
            targetId: dbc6e82e-b1a7-80b6-aba9-934090ad7065
            port: SUCCESS
      create_linux_user_and_mailbox:
        x: 520
        'y': 120
      create_user_in_hrm:
        x: 200
        'y': 120
      send_email_on_error:
        x: 320
        'y': 400
        navigate:
          db2729e1-a5c8-361e-b035-7b2a7a4dc753:
            targetId: 0fc70f03-70aa-515d-bdbf-8ab4a5fb27da
            port: SUCCESS
    results:
      SUCCESS:
        dbc6e82e-b1a7-80b6-aba9-934090ad7065:
          x: 880
          'y': 120
      FAILURE:
        0fc70f03-70aa-515d-bdbf-8ab4a5fb27da:
          x: 320
          'y': 600
