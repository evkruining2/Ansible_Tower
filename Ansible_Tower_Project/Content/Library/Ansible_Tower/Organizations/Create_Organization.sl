########################################################################################################################
#!!
#! @description: This flow will create a new Organization object in your Ansible Tower system
#!               
#!               Inputs:
#!               
#!               OrgName		- The name (string) of the Ansible Tower Organization component that you want to create (example: "Demo Organization").
#!               description		- The description of this new Organization (optional)
#!               max_hosts		- The maximum amount of allowed hosts (optional) 
#!               custom_virtualenv	- (optional)
#!               
#!               Output:
#!               
#!               OrgID		- The id (integer) of the newly created Organization
#!
#! @input OrgName: The name (string) of the Ansible Tower Organization component that you want to create (example: "Demo Organization").
#! @input description: The description of this new Organization (optional)
#! @input max_hosts: The maximum amount of allowed hosts (optional) 
#! @input custom_virtualenv: (optional)
#!
#! @output OrgID: The id (integer) of the newly created Organization
#!!#
########################################################################################################################
namespace: Ansible_Tower.Organizations
flow:
  name: Create_Organization
  inputs:
    - OrgName
    - description:
        default: ' '
        required: false
    - max_hosts:
        default: '0'
        required: false
    - custom_virtualenv:
        default: 'null'
        required: false
  workflow:
    - Create_new_Organization:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/organizations/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+OrgName+'\",'+\\\n'   \"description\": \"'+description+'\",'+\\\n'   \"max_hosts\": '+max_hosts+','+\\\n'   \"custom_virtualenv\": '+custom_virtualenv+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_OrgID
          - FAILURE: on_failure
    - Get_new_OrgID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - OrgID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - OrgID: '${OrgID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_new_Organization:
        x: 97
        'y': 91
      Get_new_OrgID:
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
