########################################################################################################################
#!!
#! @description: This flow will create a new Job Template object in your Ansible Tower system
#!               
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input TemplateName: The name (string) of the Ansible Tower Job Template component that you want to create (example: "Demo Template")
#! @input ProjectID: The Projct id (integer) that this new Job Template is going to use (example: "6")
#! @input Playbook: The name of the playbook (string) that you want this Job Template to run (example: hello_world.yml)
#! @input InventoryID: The Inventory id (integer) that you want to associate with this Job Template (example: "1")
#! @input ExtraVars: The extra variables (string) that you want to attach to this Job Template (optional) (example: "tipo: /val/lib/ansib_vars")
#!
#! @output TemplateID: The id (integer) of the newly created Job Template
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.job_templates
flow:
  name: create_job_template
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
    - TemplateName
    - ProjectID: '6'
    - Playbook:
        default: hello_world.yml
        required: true
    - InventoryID: '1'
    - ExtraVars:
        default: ' '
        required: true
  workflow:
    - Create_new_Job_Template:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get('AnsibleTowerURL')+'/job_templates/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+TemplateName+'\",'+\\\n'   \"description\": \"'+TemplateName+'\",'+\\\n'   \"job_type\": \"run\",'+\\\n'   \"inventory\": '+InventoryID+','+\\\n'   \"project\": '+ProjectID+','+\\\n'   \"playbook\": \"'+Playbook+'\",'+\\\n'   \"scm_branch\": \"\",'+\\\n'   \"forks\": 0,'+\\\n'   \"limit\": \"\",'+\\\n'   \"verbosity\": 0,'+\\\n'   \"extra_vars\": \"'+ExtraVars+'\",'+\\\n'   \"job_tags\": \"\",'+\\\n'   \"force_handlers\": false,'+\\\n'   \"skip_tags\": \"\",'+\\\n'   \"start_at_task\": \"\",'+\\\n'   \"timeout\": 0,'+\\\n'   \"use_fact_cache\": false,'+\\\n'   \"host_config_key\": \"\",'+\\\n'   \"ask_scm_branch_on_launch\": false,'+\\\n'   \"ask_diff_mode_on_launch\": false,'+\\\n'   \"ask_variables_on_launch\": false,'+\\\n'   \"ask_limit_on_launch\": false,'+\\\n'   \"ask_tags_on_launch\": false,'+\\\n'   \"ask_skip_tags_on_launch\": false,'+\\\n'   \"ask_job_type_on_launch\": false,'+\\\n'   \"ask_verbosity_on_launch\": false,'+\\\n'   \"ask_inventory_on_launch\": false,'+\\\n'   \"ask_credential_on_launch\": false,'+\\\n'   \"survey_enabled\": false,'+\\\n'   \"become_enabled\": false,'+\\\n'   \"diff_mode\": false,'+\\\n'   \"allow_simultaneous\": false,'+\\\n'   \"custom_virtualenv\": null,'+\\\n'   \"job_slice_count\": 1,'+\\\n'   \"webhook_service\": null,'+\\\n'   \"webhook_credential\": null'+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_Job_TemplateID
          - FAILURE: on_failure
    - Get_new_Job_TemplateID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - TemplateID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - TemplateID: '${TemplateID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_new_Job_Template:
        x: 97
        'y': 91
      Get_new_Job_TemplateID:
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
