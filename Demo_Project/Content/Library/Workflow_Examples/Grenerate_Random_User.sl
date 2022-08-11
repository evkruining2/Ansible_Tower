namespace: Workflow_Examples
flow:
  name: Grenerate_Random_User
  workflow:
    - Randomusers:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://randomuser.me/api/'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: Set_name_variable
          - FAILURE: on_failure
    - Set_name_variable:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.results..login.username
        publish:
          - username: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: Set_first_name_variable
          - FAILURE: on_failure
    - Set_first_name_variable:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.results..name.first
        publish:
          - first_name: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: Set_last_name_variable
          - FAILURE: on_failure
    - Set_last_name_variable:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.results..name.last
        publish:
          - last_name: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: Set_title_variable
          - FAILURE: on_failure
    - Set_title_variable:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.results..name.title
        publish:
          - title: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: Set_email_variable
          - FAILURE: on_failure
    - Set_email_variable:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.results..email
        publish:
          - email_address: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: Set_country_variable
          - FAILURE: on_failure
    - Set_country_variable:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.results..location.country
        publish:
          - country: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: Set_phone_number_variable
          - FAILURE: on_failure
    - Set_phone_number_variable:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.results..cell
        publish:
          - phone_number: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - username: '${username}'
    - first_name: '${first_name}'
    - last_name: '${last_name}'
    - title: '${title}'
    - email_address: '${email_address}'
    - country: '${country}'
    - phone_number: '${phone_number}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Randomusers:
        x: 79
        'y': 82
      Set_name_variable:
        x: 82
        'y': 251
      Set_first_name_variable:
        x: 265
        'y': 259
      Set_last_name_variable:
        x: 264
        'y': 90
      Set_title_variable:
        x: 435
        'y': 84
      Set_email_variable:
        x: 432
        'y': 263
      Set_country_variable:
        x: 606
        'y': 260
      Set_phone_number_variable:
        x: 605
        'y': 87
        navigate:
          048f340e-1af3-410d-4050-7738671fdc8d:
            targetId: 02367246-e86f-c2fc-52a6-bb139801974f
            port: SUCCESS
    results:
      SUCCESS:
        02367246-e86f-c2fc-52a6-bb139801974f:
          x: 772
          'y': 82
