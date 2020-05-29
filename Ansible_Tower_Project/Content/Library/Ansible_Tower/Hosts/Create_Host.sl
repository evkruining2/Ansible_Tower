########################################################################################################################
#!!
#! @description: This flow will create a new Host object in your Ansible Tower system
#!               
#!               Inputs:
#!               
#!               HostName		- The name (string) of the Ansible Tower Host component that you want to create (example: "myhost.tower.org").
#!               Inventory		- The Inventory id (integer) of the Inventory that you want to create this new host into (example: "1" ).
#!               HostDescription	- The description of this new Host (optional)
#!               
#!               Output:
#!               
#!               HostID		- The id (integer) of the newly created Host
#!
#! @input HostName: The name (string) of the Ansible Tower Host component that you want to create (example: "myhost.tower.org").
#! @input Inventory: The Inventory id (integer) of the Inventory that you want to create this new host into (example: "1" ).
#! @input HostDescription: The description of this new Host (optional)
#!
#! @output HostID: The id (integer) of the newly created Host
#!!#
########################################################################################################################
namespace: Ansible_Tower.Hosts
flow:
  name: Create_Host
  inputs:
    - HostName
    - Inventory
    - HostDescription:
        default: ' '
        required: false
  workflow:
    - Create_new_Host:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/hosts/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+HostName+'\",'+\\\n'   \"description\": \"'+HostDescription+'\",'+\\\n'   \"inventory\": '+Inventory+','+\\\n'   \"enabled\": true,'+\\\n'   \"instance_id\": \"\",'+\\\n'   \"variables\": \"\"'+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_HostID
          - FAILURE: on_failure
    - Get_new_HostID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - HostID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - HostID: '${HostID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_new_Host:
        x: 97
        'y': 91
      Get_new_HostID:
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
