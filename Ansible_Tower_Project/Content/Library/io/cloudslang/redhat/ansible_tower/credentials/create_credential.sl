########################################################################################################################
#!!
#! @description: This flow will create a new Credential object in your Ansible Tower system
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input CredentialType: The type (integer) of the new Credential (example: "1" for "Machine", "2" for "scm" etc). To get a list of credential_types, access https://your.ansibleserver.org/api/v2/credential_types
#! @input CredentialDescription: The description of this new Credential (optional)
#! @input CredentialName: The name (string) of the Ansible Tower Credential component that you want to create (example: "Demo Credential").
#! @input OrgID: The Organization id (integer) for the Organization to create the new Credential into
#!
#! @output CredentialID: The id (integer) of the newly created Credential
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.credentials
flow:
  name: create_credential
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots:
        default: 'false'
    - HostnameVerify:
        default: 'strict'
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
            - url: "${get('AnsibleTowerURL')+'/credentials/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostNameVerify')}"
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
