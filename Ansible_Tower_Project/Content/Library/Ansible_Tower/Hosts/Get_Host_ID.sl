########################################################################################################################
#!!
#! @description: This flow will lookup the given Host name and return its id.
#!               
#!               Inputs:
#!               
#!               HostName		- The exact name of the Ansible Tower Host component that you want to lookup the id for (example: "hostname.tower.org").
#!               
#!               Output:
#!               
#!               HostID		- Value of the "id" property of this Ansible Tower component (integrer).
#!
#! @input HostName: The exact Host name of the Ansible Tower Host component that you want to lookup the id for (example: "localhost").
#!
#! @output HostID: Value of the "id" property of this Ansible Tower component (integrer).
#!!#
########################################################################################################################
namespace: Ansible_Tower.Hosts
flow:
  name: Get_Host_ID
  inputs:
    - HostName: localhost
  workflow:
    - Convert_whitespaces:
        do:
          Ansible_Tower.Utils.search_and_replace:
            - origin_string: '${HostName}'
            - text_to_replace: ' '
            - replace_with: '%20'
        publish:
          - HostName: '${replaced_string}'
        navigate:
          - SUCCESS: Connect_to_Ansible_Tower
    - Connect_to_Ansible_Tower:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('AnsibleTowerURL')+'/hosts?name='+HostName}"
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
          - HostID: "${return_result.strip('[').strip(']')}"
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
    - HostID: '${HostID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Convert_whitespaces:
        x: 57
        'y': 79
      Connect_to_Ansible_Tower:
        x: 51
        'y': 272
      Filter_ID_from_JSON:
        x: 482
        'y': 75
        navigate:
          1931d9dd-3a25-7ed5-85e5-9275a2b4b549:
            targetId: 2e398679-49d5-534e-8413-f1f4e46f370a
            port: SUCCESS
      Filter_count_from_JSON:
        x: 265
        'y': 266
      Check_count_is_1:
        x: 263
        'y': 77
        navigate:
          754bef08-5d3c-d689-923a-45e2754b90d6:
            targetId: d55d7b8d-f0b6-a820-b28e-797a1d141a77
            port: FAILURE
    results:
      FAILURE:
        d55d7b8d-f0b6-a820-b28e-797a1d141a77:
          x: 474
          'y': 260
      SUCCESS:
        2e398679-49d5-534e-8413-f1f4e46f370a:
          x: 668
          'y': 83
