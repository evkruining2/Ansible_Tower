namespace: io.cloudslang.energy_project.tools
flow:
  name: test_ha
  inputs:
    - token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIyMDYzYWVhNGE2ZGI0MWI1OWJhODM5ZGMxNGQ5NzBmZCIsImlhdCI6MTcxODYyMjA2MywiZXhwIjoyMDMzOTgyMDYzfQ.5yZBD6nPOa4qhut2ZATEfjWS2Oxyy3C5qJaOyxj0jxk
    - ha_url: 'http://ha:8123'
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${ha_url+'/api/services/automation/trigger'}"
            - headers: "${'Authorization: Bearer '+token}"
            - body: '{"entity_id": "automation.arie"}'
            - content_type: application/json
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
        'y': 120
        navigate:
          4ead9e54-0fb6-91f1-4859-52cccaf21cb7:
            targetId: 57a90961-4a76-129d-d384-7edcac4ebba3
            port: SUCCESS
    results:
      SUCCESS:
        57a90961-4a76-129d-d384-7edcac4ebba3:
          x: 360
          'y': 160
