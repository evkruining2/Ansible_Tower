########################################################################################################################
#!!
#! @input hrm_url: URL to which the call is made.
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user.hrm
flow:
  name: create_user_in_hrm
  inputs:
    - hrm_url: 'https://10.0.10.118/orangehrm-4.6/symfony/web/index.php'
    - first_name
    - last_name
    - employee_id
  workflow:
    - get_token_from_hrm:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${hrm_url+'/oauth/issueToken'}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: 'Content-Type:application/json'
            - body: |-
                ${{"grant_type":"client_credentials",
                "client_id":"oo",
                "client_secret":"oo"}}
        publish:
          - return_result
        navigate:
          - SUCCESS: filter_token
          - FAILURE: on_failure
    - filter_token:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.access_token
        publish:
          - token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: add_user_data
          - FAILURE: on_failure
    - add_user_data:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${hrm_url+'/api/v1/employee/'+employee_id}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'Authorization: Bearer '+token}"
            - body: "${'{\"firstName\": \"'+first_name+'\",\"lastName\": \"'+last_name+'\",\"code\": \"'+employee_id+'\"}'}"
            - content_type: application/json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      filter_token:
        x: 280
        'y': 80
      get_token_from_hrm:
        x: 80
        'y': 80
      add_user_data:
        x: 480
        'y': 80
        navigate:
          197c8a0f-f53d-b63e-3954-d4af56fb551d:
            targetId: b0f33492-d967-e424-d425-ac904a424caf
            port: SUCCESS
    results:
      SUCCESS:
        b0f33492-d967-e424-d425-ac904a424caf:
          x: 680
          'y': 80
