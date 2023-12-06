########################################################################################################################
#!!
#! @description: This flow will create a new User object in your Ansible Tower system
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
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
namespace: io.cloudslang.redhat.ansible_tower.users
flow:
  name: create_user
  inputs:
    - AnsibleTowerURL: "${get_sp('io.cloudslang.redhat.ansible.ansible_url')}"
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.redhat.ansible.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.redhat.ansible.x509_hostname_verifier')}"
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
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get('AnsibleTowerURL')+'/users/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
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
