########################################################################################################################
#!!
#! @description: This flow will create a new Project object in your Ansible Tower system
#!               
#!               Inputs:
#!               
#!               ProjectName		- The name (string) of the Ansible Tower Credential component that you want to create (example: "Demo Project").
#!               description		- The description of this new Project (optional)
#!               scm_type		- The type of Source Control Manament system to use.(empty for manual) (example: "git", "svn", "hg", "insights")
#!               local_path		- Enter Local_path when scm_type is manual (example: "myfolder")
#!               scm_url		- Enter the scm url (leave empty if scm_type is manual) (example: "https://github.com/ansible/ansible-tower-samples")
#!               CredentialID		- The Credential id (integer) for the Credential to link this Project to (optional) (defaults to id 1)
#!               orgID		- The Organization id (integer) for the Organization to create the new Project into (optional) (defaults to id 1)
#!               
#!               Output:
#!               
#!               ProjectID		- The id (integer) of the newly created Project
#!
#! @input ProjectName: The name (string) of the Ansible Tower Credential component that you want to create (example: "Demo Project").
#! @input description: The description of this new Project
#! @input scm_type: The type of Source Control Manament system to use (example: "manual, ""git", "svn", "hg", "insights")
#! @input local_path: Enter Local_path when scm_type is manual (example: "myfolder")
#! @input scm_url: Enter the scm url (leave empty if scm_type is manual) (example: "https://github.com/ansible/ansible-tower-samples")
#! @input CredentialID: The Credential id (integer) for the Credential to link this Project to (optional) (defaults to id 1)
#! @input OrgID: The Organization id (integer) for the Organization to create the new Project into (optional) (defaults to id 1)
#!
#! @output ProjectID: The id (integer) of the newly created Project
#!!#
########################################################################################################################
namespace: Ansible_Tower.Projects
flow:
  name: Create_Project
  inputs:
    - ProjectName
    - description:
        required: true
    - scm_type:
        default: git
        required: true
    - local_path:
        required: false
    - scm_url:
        required: false
    - CredentialID:
        default: 'null'
        required: false
    - OrgID:
        default: 'null'
        required: false
  workflow:
    - Set_local_path_if_empty:
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: '${local_path}'
            - default_value: manu
        publish:
          - local_path: '${return_result}'
        navigate:
          - SUCCESS: Set_scm_url_if_empty
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${scm_type}'
            - second_string: manual
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_scm_type_variable_manual
          - FAILURE: Set_scm_type_variable
    - Create_new_Project:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/projects/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+ProjectName+'\",'+\\\n'   \"description\": \"'+description+'\",'+\\\n'   \"local_path\": \"'+local_path+'\",'+scm_type+','+\\\n'   \"scm_url\": \"'+scm_url+'\",'+\\\n'   \"scm_branch\": \"\",'+\\\n'   \"scm_refspec\": \"\",'+\\\n'   \"scm_clean\": false,'+\\\n'   \"scm_delete_on_update\": false,'+\\\n'   \"credential\": '+CredentialID+','+\\\n'   \"timeout\": 0,'+\\\n'   \"organization\": '+OrgID+','+\\\n'   \"scm_update_on_launch\": false,'+\\\n'   \"scm_update_cache_timeout\": 0,'+\\\n'   \"allow_override\": false,'+\\\n'   \"custom_virtualenv\": null'+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_ProjectID
          - FAILURE: on_failure
    - Get_new_ProjectID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - ProjectID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Set_scm_type_variable:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${scm_type}'
            - text_to_replace: '${scm_type}'
            - replace_with: "${'\"scm_type\" : \"'+scm_type+'\"'}"
        publish:
          - scm_type: '${replaced_string}'
        navigate:
          - SUCCESS: Create_new_Project
          - FAILURE: on_failure
    - set_scm_type_variable_manual:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${scm_type}'
            - text_to_replace: '${scm_type}'
            - replace_with: '"scm_type" : ""'
        publish:
          - scm_type: '${replaced_string}'
        navigate:
          - SUCCESS: Create_new_Project
          - FAILURE: on_failure
    - Set_scm_url_if_empty:
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: '${scm_url}'
            - default_value: 'https://github.com/ansible/ansible-tower-samples'
        publish:
          - scm_url: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
  outputs:
    - ProjectID: '${ProjectID}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Set_local_path_if_empty:
        x: 62
        'y': 80
      string_equals:
        x: 241
        'y': 287
      Create_new_Project:
        x: 426
        'y': 87
      Get_new_ProjectID:
        x: 622
        'y': 88
        navigate:
          c218684a-b815-9d80-fb21-a28868518c5e:
            targetId: ad9feb36-6ddc-9e46-5429-4db8d8719bd2
            port: SUCCESS
      Set_scm_type_variable:
        x: 238
        'y': 84
      set_scm_type_variable_manual:
        x: 430
        'y': 290
      Set_scm_url_if_empty:
        x: 65
        'y': 286
    results:
      SUCCESS:
        ad9feb36-6ddc-9e46-5429-4db8d8719bd2:
          x: 618
          'y': 295
