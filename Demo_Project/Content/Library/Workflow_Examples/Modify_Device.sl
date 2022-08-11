namespace: Workflow_Examples
flow:
  name: Modify_Device
  workflow:
    - Get_Jira_Authentication_Token:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://jira/rest'
        navigate:
          - SUCCESS: Get_Jira_Ticket_Details
          - FAILURE: Send_email_to_Notify_Admin
    - NA_Show_Configuration_Details:
        do_external:
          989dbbaa-e2d8-4cf2-950b-839403600033:
            - coreHost: nacore
            - coreUsername: admin
            - corePassword:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - id: deviceID
        navigate:
          - failure: Send_email_to_Notify_Admin
          - success: Get_Password_Length_Setting
    - Update_Ticket_in_Jira_no_changes:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: 'https://jira/api'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Get_Jira_Ticket_Details:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://jira/rest'
        navigate:
          - SUCCESS: Get_Device_Connection_Details
          - FAILURE: on_failure
    - Get_Device_Connection_Details:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://jira/rest'
        navigate:
          - SUCCESS: NA_Show_Configuration_Details
          - FAILURE: on_failure
    - Get_Password_Length_Setting:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: json_results
            - json_path: $..data.config.psl
        publish:
          - pwl: '${return_result}'
        navigate:
          - SUCCESS: Is_Password_Length_greater_than_6
          - FAILURE: on_failure
    - Is_Password_Length_greater_than_6:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${pwl}'
            - value2: '6'
        navigate:
          - GREATER_THAN: Update_Ticket_in_Jira_no_changes
          - EQUALS: NA_Set_Device_Configuration
          - LESS_THAN: NA_Set_Device_Configuration
    - NA_Set_Device_Configuration:
        do_external:
          d2ec382f-877c-4157-a8b4-6c74cd10c051:
            - hostname: nacore
            - username: admin
            - password:
                value: "${get_sp('pvePassword')}"
                sensitive: true
            - Command: set pwl to 8
        navigate:
          - success: Update_Ticket_in_Jira_with_changes
          - failure: on_failure
    - Update_Ticket_in_Jira_with_changes:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: 'https://jira/api'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Update_Ticket_in_Jira_on_error:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: 'https://jira/api'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - Send_email_to_Notify_Admin:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: smtp
            - port: '25'
            - from: OO_Admin
            - to: admin@example.com
            - subject: Something went wrong
            - body: Look at this
        navigate:
          - SUCCESS: Update_Ticket_in_Jira_on_error
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Device_Connection_Details:
        x: 452
        'y': 66
      NA_Show_Configuration_Details:
        x: 654
        'y': 64
      Send_email_to_Notify_Admin:
        x: 359
        'y': 285
      Is_Password_Length_greater_than_6:
        x: 842
        'y': 259
      Get_Password_Length_Setting:
        x: 845
        'y': 65
      NA_Set_Device_Configuration:
        x: 649
        'y': 268
      Get_Jira_Ticket_Details:
        x: 257
        'y': 70
      Update_Ticket_in_Jira_no_changes:
        x: 849
        'y': 465
        navigate:
          02fd0a27-0b2f-0831-c791-b8cdca0702b0:
            targetId: c37eaa45-cd7f-210c-72c4-13a1de9cfc3b
            port: SUCCESS
      Get_Jira_Authentication_Token:
        x: 75
        'y': 69
      Update_Ticket_in_Jira_on_error:
        x: 361
        'y': 484
        navigate:
          dc27500c-84a5-7eed-ea0c-29b731d9012e:
            targetId: 6697da7e-7a63-0f68-277e-fc431441a2c9
            port: SUCCESS
      Update_Ticket_in_Jira_with_changes:
        x: 652
        'y': 467
        navigate:
          7861efa9-08c7-1b40-419c-6d7ecf3c4e51:
            targetId: c37eaa45-cd7f-210c-72c4-13a1de9cfc3b
            port: SUCCESS
    results:
      FAILURE:
        6697da7e-7a63-0f68-277e-fc431441a2c9:
          x: 357
          'y': 660
      SUCCESS:
        c37eaa45-cd7f-210c-72c4-13a1de9cfc3b:
          x: 753
          'y': 672
