namespace: Workflow_Examples
flow:
  name: F
  workflow:
    - Randomusers:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://randomuser.me/api/'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: J
          - FAILURE: on_failure
    - J:
        do:
          Workflow_Examples.J:
            - json_result: '${json_result}'
        publish:
          - gender
          - first_name
          - last_name
          - title
          - email
          - login_username
          - phone
          - cell
          - id_value
          - nat
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - gender: '${gender}'
    - first_name: '${first_name}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Randomusers:
        x: 148
        'y': 155.5
      J:
        x: 311
        'y': 168
        navigate:
          64c82053-d8c1-2278-e947-d360a85dfd25:
            targetId: 95f52d93-8f95-c6d7-4781-5cc2b80af260
            port: SUCCESS
    results:
      SUCCESS:
        95f52d93-8f95-c6d7-4781-5cc2b80af260:
          x: 481
          'y': 133.5
