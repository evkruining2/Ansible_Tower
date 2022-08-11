namespace: tests
flow:
  name: Test_Yahoo_Finance_API
  inputs:
    - symbol: MCRO.L
    - region: GB
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-profile?symbol='+symbol+'&region='+region}"
            - auth_type: anonymous
            - headers: |-
                x-rapidapi-key:fd2ff693f2msh4802d8cf96a1461p1f26f1jsn0f47f932842d
                x-rapidapi-host:apidojo-yahoo-finance-v1.p.rapidapi.com
            - content_type: application/json
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.price.regularMarketPrice.fmt
        publish:
          - regularMarketPrice: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - regularMarketPrice: '${regularMarketPrice}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_get:
        x: 147
        'y': 129
      json_path_query:
        x: 347
        'y': 140
        navigate:
          9b6a7a3b-0f5e-8483-122d-e2d5fcc1b433:
            targetId: 9405414b-cd9b-7233-b357-59545dee9f18
            port: SUCCESS
    results:
      SUCCESS:
        9405414b-cd9b-7233-b357-59545dee9f18:
          x: 497
          'y': 226
