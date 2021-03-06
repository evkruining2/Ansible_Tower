namespace: CS_flows
flow:
  name: Get_time
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - locale_lang: nl
            - locale_country: nl
            - timezone: CET
            - date_format: 'HH:mm'
        publish:
          - output
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - Time: '${output}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_time:
        x: 110
        'y': 250
        navigate:
          2018ad24-5966-22cc-99f7-908cae0c3f1c:
            targetId: 3e31891d-b482-7423-647d-24573c3f3a66
            port: SUCCESS
    results:
      SUCCESS:
        3e31891d-b482-7423-647d-24573c3f3a66:
          x: 370
          'y': 250
