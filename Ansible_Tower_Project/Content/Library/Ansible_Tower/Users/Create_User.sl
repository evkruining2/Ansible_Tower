########################################################################################################################
#!!
#! @description: This flow will create a new User object in your Ansible Tower system
#!               
#!               Inputs:
#!               
#!               UserName		- The name (string) of the Ansible Tower User component that you want to create (example: "Demo User").
#!               UserPassword	- The password of this new User 
#!               first_name		- User first name (optional)
#!               last_name		- User last name (optional)
#!               email		- Email address for this user (optional)
#!               is_superuser		- Is this a super user (optional) (default: false)
#!               is_system_auditor	- Is this a system auditor (optional) (default: false)
#!               
#!               Output:
#!               
#!               UserID		- The id (integer) of the newly created User
#!
#! @input UserName: The name (string) of the Ansible Tower User component that you want to create (example: "Demo User")
#! @input UserPassword: Password for the new user
#! @input first_name: User first name
#! @input last_name: User last name
#! @input email: Email address for this user
#! @input is_superuser: Is this a super user (optional) (default: false)
#! @input is_system_auditor: Is this a system auditor (optional) (default: false)
#!
#! @output UserID: The id (integer) of the newly created User
#!!#
########################################################################################################################
namespace: Ansible_Tower.Users
flow:
  name: Create_User
  inputs:
    - UserName
    - UserPassword:
        sensitive: true
    - first_name
    - last_name
    - email
    - is_superuser: 'false'
    - is_system_auditor: 'false'
  workflow:
    - Create_new_User:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/users/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"username\": \"'+UserName+'\",'+\\\n'   \"first_name\": \"'+first_name+'\",'+\\\n'   \"last_name\": \"'+last_name+'\",'+\\\n'   \"email\": \"'+email+'\",'+\\\n'   \"is_superuser\": '+is_superuser+','+\\\n'   \"is_system_auditor\": '+is_system_auditor+','+\\\n'   \"password\": \"'+UserPassword+'\"'+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_UserID
          - FAILURE: on_failure
    - Get_new_UserID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - UserID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - UserID: '${UserID}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Create_new_User:
        x: 65
        'y': 95
      Get_new_UserID:
        x: 263
        'y': 94
        navigate:
          d97a692d-8815-d478-bd73-a5050ce9f5e7:
            targetId: 9e182653-0daf-bc71-edee-760b20147b83
            port: SUCCESS
    results:
      SUCCESS:
        9e182653-0daf-bc71-edee-760b20147b83:
          x: 440
          'y': 94
