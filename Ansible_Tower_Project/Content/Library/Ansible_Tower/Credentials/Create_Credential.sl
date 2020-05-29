########################################################################################################################
#!!
#! @description: This flow will create a new Credential object in your Ansible Tower system
#!               
#!               Inputs:
#!               
#!               CredentialName	- The name (string) of the Ansible Tower Credential component that you want to create (example: "Demo Credential").
#!               CredentialType	- The type (integer) of the new Credential (example: "1" for "Machine", "2" for "scm" etc). To get a list of credential_types, access https://your.ansibleserver.org/api/v2/credential_types
#!               CredentialDescription	- The description of this new Credential (optional)
#!               OrgID		- The Organization id (integer) for the Organization to create the new Credential into
#!               
#!               Output:
#!               
#!               CredentialID		- The id (integer) of the newly created Credential
#!
#! @input CredentialName: The name (string) of the Ansible Tower Credential component that you want to create (example: "Demo Credential").
#! @input CredentialType: The type (integer) of the new Credential (example: "1" for "Machine", "2" for "scm" etc). To get a list of credential_types, access https://your.ansibleserver.org/api/v2/credential_types
#! @input CredentialDescription: The description of this new Credential (optional)
#! @input OrgID: The Organization id (integer) for the Organization to create the new Credential into
#!
#! @output CredentialID: The id (integer) of the newly created Credential
#!!#
########################################################################################################################
namespace: Ansible_Tower.Credentials
flow:
  name: Create_Credential
  inputs:
    - CredentialName
    - CredentialType
    - CredentialDescription:
        default: ' '
        required: false
    - OrgID
  workflow:
    - Create_new_Credential:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/credentials/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+CredentialName+'\",'+\\\n'   \"description\": \"'+CredentialDescription+'\",'+\\\n'   \"organization\": '+OrgID+','+\\\n'   \"credential_type\": '+CredentialType+','+\\\n'   \"inputs\": {},'+\\\n'   \"user\": null,'+\\\n'   \"team\": null'+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_Credential_ID
          - FAILURE: on_failure
    - Get_new_Credential_ID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - CredentialID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - CredentialID: '${CredentialID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_new_Credential:
        x: 97
        'y': 91
      Get_new_Credential_ID:
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
