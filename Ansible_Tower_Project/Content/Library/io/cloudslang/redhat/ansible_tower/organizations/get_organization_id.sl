########################################################################################################################
#!!
#! @description: This flow will lookup the given Organization name and return its id.
#!               
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input OrgName: The exact Organization name of the Ansible Tower Organization component that you want to lookup the id for (example: "Default").
#!
#! @output OrgID: Value of the "id" property of this Ansible Tower component (integrer).
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.jobs
flow:
  name: get_organization_id
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
    - OrgName: Default
  workflow:
    - Convert_whitespaces:
        do:
          io.cloudslang.redhat.ansible_tower.utils.search_and_replace:
            - origin_string: '${OrgName}'
            - text_to_replace: ' '
            - replace_with: '%20'
        publish:
          - OrgName: '${replaced_string}'
        navigate:
          - SUCCESS: Connect_to_Ansible_Tower
    - Connect_to_Ansible_Tower:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('AnsibleTowerURL')+'/organizations?name='+OrgName}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Filter_count_from_JSON
          - FAILURE: on_failure
    - Filter_ID_from_JSON:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - OrgID: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Filter_count_from_JSON:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.count
        publish:
          - count: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: Check_count_is_1
          - FAILURE: on_failure
    - Check_count_is_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${count}'
            - second_string: '1'
        navigate:
          - SUCCESS: Filter_ID_from_JSON
          - FAILURE: FAILURE
  outputs:
    - OrgID: '${OrgID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Convert_whitespaces:
        x: 57
        'y': 79
      Connect_to_Ansible_Tower:
        x: 51
        'y': 272
      Filter_ID_from_JSON:
        x: 482
        'y': 75
        navigate:
          1931d9dd-3a25-7ed5-85e5-9275a2b4b549:
            targetId: 2e398679-49d5-534e-8413-f1f4e46f370a
            port: SUCCESS
      Filter_count_from_JSON:
        x: 265
        'y': 266
      Check_count_is_1:
        x: 263
        'y': 77
        navigate:
          754bef08-5d3c-d689-923a-45e2754b90d6:
            targetId: d55d7b8d-f0b6-a820-b28e-797a1d141a77
            port: FAILURE
    results:
      FAILURE:
        d55d7b8d-f0b6-a820-b28e-797a1d141a77:
          x: 474
          'y': 260
      SUCCESS:
        2e398679-49d5-534e-8413-f1f4e46f370a:
          x: 668
          'y': 83
