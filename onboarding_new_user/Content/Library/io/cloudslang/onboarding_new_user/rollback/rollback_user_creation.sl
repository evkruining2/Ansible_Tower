########################################################################################################################
#!!
#! @input row_number: select a number between 1 and 10
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user.rollback
flow:
  name: rollback_user_creation
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
          - employee_id
        navigate:
          - FAILURE: delete_record_from_hrm
          - SUCCESS: delete_record_from_hrm
    - delete_ad_user:
        do:
          io.cloudslang.onboarding_new_user.active_directory.delete_ad_user:
            - first_name: '${first_name}'
            - last_name: '${last_name}'
        navigate:
          - SUCCESS: send_email
          - FAILURE: send_email
    - send_email:
        do:
          io.cloudslang.onboarding_new_user.email.send_email:
            - email_to: oouser@example.com
            - subject: A user hase been removed from the system
            - body: "${'Dear OO User,\\n\\nBeware, an existing user has just been deleted from our system.\\n\\nThis is what happened:\\n\\nFirst Name:        '+first_name+'\\nLast Name:      '+last_name+'\\n\\nHave a nice day!\\n\\nBest regards,\\nYour system administrator\\n'}"
            - first_name: '${first_name}'
            - last_name: '${last_name}'
        navigate:
          - FAILURE: delete_linux_user
          - SUCCESS: delete_linux_user
    - delete_linux_user:
        do:
          io.cloudslang.onboarding_new_user.application_server.delete_linux_user:
            - login_name: '${login_name}'
        navigate:
          - FAILURE: SUCCESS
          - SUCCESS: SUCCESS
    - delete_record_from_hrm:
        do:
          io.cloudslang.onboarding_new_user.hrm.delete_record_from_hrm:
            - employee_id: '${employee_id}'
        navigate:
          - SUCCESS: delete_ad_user
          - FAILURE: delete_ad_user
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      read_xls_data:
        x: 40
        'y': 120
      delete_ad_user:
        x: 280
        'y': 120
      send_email:
        x: 400
        'y': 320
      delete_linux_user:
        x: 520
        'y': 120
        navigate:
          42169f52-35c1-224a-f885-249136302061:
            targetId: 64b7d742-0bfe-cad1-8a3b-755dafd06a12
            port: SUCCESS
          5c067dba-ca16-11f8-7c68-582425b5e74a:
            targetId: 64b7d742-0bfe-cad1-8a3b-755dafd06a12
            port: FAILURE
      delete_record_from_hrm:
        x: 160
        'y': 320
    results:
      SUCCESS:
        64b7d742-0bfe-cad1-8a3b-755dafd06a12:
          x: 640
          'y': 320
