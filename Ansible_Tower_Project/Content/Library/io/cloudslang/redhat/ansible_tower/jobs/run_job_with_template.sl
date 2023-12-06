########################################################################################################################
#!!
#! @description: Launch the selected Job Template
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input TemplateID: The id (integer) of the Job Template to launch
#!
#! @output JobID: id (integer) of the launched Job
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.jobs
flow:
  name: run_job_with_template
  inputs:
    - AnsibleTowerURL: "${get_sp('io.cloudslang.redhat.ansible.ansible_url')}"
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.redhat.ansible.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.redhat.ansible.x509_hostname_verifier')}"
    - TemplateID
  workflow:
    - Launch_Job_Template:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get('AnsibleTowerURL')+'/job_templates/'+TemplateID+'/launch/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: 'Content-Type:application/json'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_Job_ID
          - FAILURE: on_failure
    - Get_new_Job_ID:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - JobID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobID: '${JobID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Launch_Job_Template:
        x: 173
        'y': 128.5
      Get_new_Job_ID:
        x: 373
        'y': 131
        navigate:
          33aee7f1-dcdd-df48-2d3d-da8249f0964f:
            targetId: 5f8931d5-1ea8-a948-a3d6-37da6e44875f
            port: SUCCESS
    results:
      SUCCESS:
        5f8931d5-1ea8-a948-a3d6-37da6e44875f:
          x: 579
          'y': 130
