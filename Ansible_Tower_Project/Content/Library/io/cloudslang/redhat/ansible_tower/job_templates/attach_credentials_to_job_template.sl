########################################################################################################################
#!!
#! @description: Attach a Credential component to a Job Template component. Use id (integer) for both.
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input TemplateID: Enter the Job Template ID (integer)
#! @input CredentialID: Enter the Credential ID (integer)
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.job_templates
flow:
  name: attach_credentials_to_job_template
  inputs:
    - AnsibleTowerURL: "${get_sp('io.cloudslang.redhat.ansible.ansible_url')}"
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.redhat.ansible.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.redhat.ansible.x509_hostname_verifier')}"
    - TemplateID
    - CredentialID
  workflow:
    - Attach_CredentialID_to_Job_TemplateID:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get('AnsibleTowerURL')+'/job_templates/'+TemplateID+'/credentials/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"id\": '+CredentialID+\\\n'}'}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Attach_CredentialID_to_Job_TemplateID:
        x: 134
        'y': 146.5
        navigate:
          a7aadae2-791e-76fa-cafe-81311af1a021:
            targetId: 1443236e-9882-ab05-5df0-9d94dd8b32ab
            port: SUCCESS
    results:
      SUCCESS:
        1443236e-9882-ab05-5df0-9d94dd8b32ab:
          x: 350
          'y': 155
