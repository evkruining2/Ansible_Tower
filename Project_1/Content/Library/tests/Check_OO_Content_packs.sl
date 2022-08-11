namespace: tests
flow:
  name: Check_OO_Content_packs
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://rpacore3.museumhof.net:8443/oo/rest/v2/content-packs'
            - username: erwin
            - password:
                value: opsware
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_get:
        x: 158
        'y': 156
        navigate:
          029aa30f-ecd4-a1df-493d-8ad72f639fe9:
            targetId: f29afb3d-8f87-3bc8-30aa-e74e213e80aa
            port: SUCCESS
    results:
      SUCCESS:
        f29afb3d-8f87-3bc8-30aa-e74e213e80aa:
          x: 435
          'y': 119
