########################################################################################################################
#!!
#! @description: This flow will display a list of all Job Templates in your Ansible Tower instance.
#!               
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!
#! @output Job_Templates: A comma-separated list of Job Templates and their id's
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.job_templates
flow:
  name: list_job_templates
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
  workflow:
    - Get_all_Job_Templates:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('AnsibleTowerURL')+'/job_templates/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostNameVerify')}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_array_of_IDs
          - FAILURE: on_failure
    - Get_array_of_IDs:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - output: "${return_result.strip('[').strip(']')}"
          - new_string: ''
        navigate:
          - SUCCESS: Iterate_trough_IDs
          - FAILURE: on_failure
    - Iterate_trough_IDs:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${output}'
        publish:
          - list_item: '${result_string}'
        navigate:
          - HAS_MORE: Get_Job_TemplateName_from_ID
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - Get_Job_TemplateName_from_ID:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('AnsibleTowerURL')+'/job_templates/'+list_item}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostNameVerify')}"
        publish:
          - template: '${return_result}'
        navigate:
          - SUCCESS: Filter_Job_TemplateName_from_JSON
          - FAILURE: on_failure
    - Filter_Job_TemplateName_from_JSON:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${template}'
            - json_path: $.name
        publish:
          - template_name: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: Add_items_to_list
          - FAILURE: on_failure
    - Add_items_to_list:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${new_string}'
            - text: "${list_item+','+template_name+\"\\n\"}"
        publish:
          - new_string
        navigate:
          - SUCCESS: Iterate_trough_IDs
  outputs:
    - Job_Templates: '${new_string}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_all_Job_Templates:
        x: 39
        'y': 90
      Get_array_of_IDs:
        x: 216
        'y': 91
      Iterate_trough_IDs:
        x: 426
        'y': 87
        navigate:
          9b32e6af-61d5-f3b4-fe30-d5b72a38f613:
            targetId: 1ffd07c0-d987-2eba-f0d9-4112d7ba96e4
            port: NO_MORE
      Get_Job_TemplateName_from_ID:
        x: 425
        'y': 286
      Filter_Job_TemplateName_from_JSON:
        x: 422
        'y': 472
      Add_items_to_list:
        x: 639
        'y': 285
    results:
      SUCCESS:
        1ffd07c0-d987-2eba-f0d9-4112d7ba96e4:
          x: 638
          'y': 88
