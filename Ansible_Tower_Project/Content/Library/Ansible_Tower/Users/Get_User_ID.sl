########################################################################################################################
#!!
#! @input UserName: The exact username of the Ansible Tower User component that you want to lookup the id for (example: "DemoUser").
#!
#! @output UserID: The id (integer) of the selected User
#!!#
########################################################################################################################
namespace: Ansible_Tower.Users
flow:
  name: Get_User_ID
  inputs:
    - UserName: DemoUser
  workflow:
    - Connect_to_Ansible_Tower:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('AnsibleTowerURL')+'/users?username='+UserName}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Filter_count_from_JSON
          - FAILURE: on_failure
    - Filter_ID_from_JSON:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - UserID: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Filter_count_from_JSON:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.count
        publish:
          - count: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: Check_count_is_1
          - FAILURE: on_failure
    - Check_count_is_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${count}'
            - second_string: '1'
        navigate:
          - SUCCESS: Filter_ID_from_JSON
          - FAILURE: FAILURE
  outputs:
    - UserID: '${UserID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Connect_to_Ansible_Tower:
        x: 68
        'y': 90
      Filter_ID_from_JSON:
        x: 679
        'y': 98
        navigate:
          1931d9dd-3a25-7ed5-85e5-9275a2b4b549:
            targetId: 2e398679-49d5-534e-8413-f1f4e46f370a
            port: SUCCESS
      Filter_count_from_JSON:
        x: 267
        'y': 89
      Check_count_is_1:
        x: 476
        'y': 95
        navigate:
          754bef08-5d3c-d689-923a-45e2754b90d6:
            targetId: d55d7b8d-f0b6-a820-b28e-797a1d141a77
            port: FAILURE
    results:
      FAILURE:
        d55d7b8d-f0b6-a820-b28e-797a1d141a77:
          x: 472
          'y': 311
      SUCCESS:
        2e398679-49d5-534e-8413-f1f4e46f370a:
          x: 674
          'y': 310
