########################################################################################################################
#!!
#! @description: Generate a ticket (cookie) for all additional PVE API calls
#!!#
########################################################################################################################
namespace: pve_test_flows
flow:
  name: get_ticket
  inputs:
    - pveURL
    - pveUsername
    - pvePassword
    - TrustAllRoots
    - HostnameVerify
  workflow:
    - get_ticket:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get('pveURL')+'/api2/json/access/ticket'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - body: "${'username='+pveUsername+'&password='+pvePassword}"
            - content_type: ' '
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.ticket
        publish:
          - pveTicket: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - pveTicket: '${pveTicket}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ticket:
        x: 95
        'y': 121.5
      json_path_query:
        x: 292
        'y': 123
        navigate:
          5a2b8031-409f-3fbf-a712-d7cd79225fc6:
            targetId: c2769967-dad0-7dfa-46e9-d32658447dd5
            port: SUCCESS
    results:
      SUCCESS:
        c2769967-dad0-7dfa-46e9-d32658447dd5:
          x: 487
          'y': 128
