########################################################################################################################
#!!
#! @description: This flow will create a new Inventory object in your Ansible Tower system
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input InventoryName: The name (string) of the Ansible Tower Inventory component that you want to create (example: "My Inventory").
#! @input OrgID: The Organization id (integer) of the Organization that you want to create this new Inventory into (example: "1" ).
#!
#! @output InventoryID: The id (integer) of the newly created Inventory
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.inventories
flow:
  name: create_inventory
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
    - InventoryName
    - OrgID
  workflow:
    - Create_new_Inventory:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get('AnsibleTowerURL')+'/inventories/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostNameVerify')}"
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
