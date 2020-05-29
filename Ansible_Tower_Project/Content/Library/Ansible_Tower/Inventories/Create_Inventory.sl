########################################################################################################################
#!!
#! @description: This flow will create a new Inventory object in your Ansible Tower system
#!               Inputs:
#!               IventoryName		- The name (string) of the Ansible Tower Inventory component that you want to create (example: "My Inventory").
#!               OrgID		                - The Organization id (integer) of the Organization that you want to create this new Inventory into (example: "1" ).
#!               
#!               Output:
#!               
#!               InventoryID		- The id (integer) of the newly created Inventory
#!
#! @input InventoryName: The name (string) of the Ansible Tower Inventory component that you want to create (example: "My Inventory").
#! @input OrgID: The Organization id (integer) of the Organization that you want to create this new Inventory into (example: "1" ).
#!
#! @output InventoryID: The id (integer) of the newly created Inventory
#!!#
########################################################################################################################
namespace: Ansible_Tower.Inventories
flow:
  name: Create_Inventory
  inputs:
    - InventoryName
    - OrgID
  workflow:
    - Create_new_Inventory:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/inventories/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+InventoryName+'\",'+\\\n'   \"description\": \"'+InventoryName+'\",'+\\\n'   \"organization\": '+OrgID+','+\\\n'   \"kind\": \"\",'+\\\n'   \"host_filter\": null,'+\\\n'   \"variables\": \"\",'+\\\n'   \"insights_credential\": null'+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_IntentoryID
          - FAILURE: on_failure
    - Get_new_IntentoryID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - InventoryID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - InventoryID: '${InventoryID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_new_Inventory:
        x: 97
        'y': 91
      Get_new_IntentoryID:
        x: 319
        'y': 92
        navigate:
          d3f16ba3-4c0c-1dda-bf12-eb90216243c3:
            targetId: 9a4e8453-d8e7-362e-6069-e90dc4da4657
            port: SUCCESS
    results:
      SUCCESS:
        9a4e8453-d8e7-362e-6069-e90dc4da4657:
          x: 522
          'y': 95
