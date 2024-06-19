namespace: io.cloudslang.energy_project.home_assistant
flow:
  name: switch_off
  inputs:
    - tasmota_url: 'http://tasmota1.museumhof.net/cm?cmnd=Power'
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${tasmota_url+'%20Off'}"
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_post:
        x: 160
        'y': 160
        navigate:
          951a4c2e-2a2b-c84d-a974-21190309ca0c:
            targetId: 7262f8f0-a598-83e6-e408-4762c71677c2
            port: SUCCESS
    results:
      SUCCESS:
        7262f8f0-a598-83e6-e408-4762c71677c2:
          x: 400
          'y': 160
