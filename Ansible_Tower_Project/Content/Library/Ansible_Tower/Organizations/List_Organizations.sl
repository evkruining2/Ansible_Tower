########################################################################################################################
#!!
#! @output Organizations: A comma-separated list of Organizations and their id's
#!!#
########################################################################################################################
namespace: Ansible_Tower.Organizations
flow:
  name: List_Organizations
  workflow:
    - Get_all_Organizations:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('AnsibleTowerURL')+'/organizations/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_array_of_IDs
          - FAILURE: on_failure
    - Get_array_of_IDs:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - output: "${return_result.strip('[').strip(']')}"
          - new_string: ''
        navigate:
          - SUCCESS: Iterate_trough_IDs
          - FAILURE: on_failure
    - Iterate_trough_IDs:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${output}'
        publish:
          - list_item: '${result_string}'
        navigate:
          - HAS_MORE: Get_OrganizationName_from_ID
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - Get_OrganizationName_from_ID:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('AnsibleTowerURL')+'/organizations/'+list_item}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
        publish:
          - org: '${return_result}'
        navigate:
          - SUCCESS: Filter_OrganizationName_from_JSON
          - FAILURE: on_failure
    - Filter_OrganizationName_from_JSON:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${org}'
            - json_path: $.name
        publish:
          - org_name: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: Add_items_to_list
          - FAILURE: on_failure
    - Add_items_to_list:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${new_string}'
            - text: "${list_item+','+org_name+\"\\n\"}"
        publish:
          - new_string
        navigate:
          - SUCCESS: Iterate_trough_IDs
  outputs:
    - Organizations: '${new_string}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_all_Organizations:
        x: 39
        'y': 90
      Get_array_of_IDs:
        x: 216
        'y': 91
      Iterate_trough_IDs:
        x: 426
        'y': 87
        navigate:
          9b32e6af-61d5-f3b4-fe30-d5b72a38f613:
            targetId: 1ffd07c0-d987-2eba-f0d9-4112d7ba96e4
            port: NO_MORE
      Get_OrganizationName_from_ID:
        x: 425
        'y': 286
      Filter_OrganizationName_from_JSON:
        x: 422
        'y': 472
      Add_items_to_list:
        x: 639
        'y': 285
    results:
      SUCCESS:
        1ffd07c0-d987-2eba-f0d9-4112d7ba96e4:
          x: 638
          'y': 88
