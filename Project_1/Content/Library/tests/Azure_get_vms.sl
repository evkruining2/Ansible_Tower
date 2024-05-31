namespace: tests
flow:
  name: Azure_get_vms
  workflow:
    - get_token:
        do:
          io.cloudslang.co2e_collection.Azure.subflows.get_token: []
        publish:
          - azure_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_get
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://management.azure.com/subscriptions/4d08f192-8c63-49fa-a461-5cdd32ce42dc/resourceGroups/Merlion/providers/Microsoft.Compute/virtualMachines/DCASaaSVM235538?$expand=InstanceView&api-version=2022-11-01'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'Authorization: Bearer '+azure_token}"
            - content_type: application/json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: http_client_action
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: 'https://management.azure.com/subscriptions/4d08f192-8c63-49fa-a461-5cdd32ce42dc/resourceGroups/Merlion/providers/Microsoft.Compute/virtualMachines/DCASaaSVM235538?$expand=InstanceView&api-version=2022-11-01'
            - headers: "${'Authorization: Bearer '+azure_token}"
            - response_character_set: UTF-8
            - content_type: application/json
            - request_character_set: UTF-8
            - method: get
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 80
        'y': 160
      http_client_get:
        x: 200
        'y': 120
        navigate:
          95cee7df-cbc2-3126-708e-d1c9cbe1b642:
            targetId: 8f1d937e-3a35-a5d2-ecfa-6524f19ae88c
            port: SUCCESS
      http_client_action:
        x: 320
        'y': 280
        navigate:
          6d7085ac-217e-0d71-cc78-ef008aefb7af:
            targetId: 8f1d937e-3a35-a5d2-ecfa-6524f19ae88c
            port: SUCCESS
    results:
      SUCCESS:
        8f1d937e-3a35-a5d2-ecfa-6524f19ae88c:
          x: 400
          'y': 160
