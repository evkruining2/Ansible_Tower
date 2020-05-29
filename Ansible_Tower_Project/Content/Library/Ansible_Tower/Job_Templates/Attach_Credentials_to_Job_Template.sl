########################################################################################################################
#!!
#! @description: Attach a Credential component to a Job Template component. Use id (integer) for both.
#!
#! @input TemplateID: Enter the Job Template ID (integer)
#! @input CredentialID: Enter the Credential ID (integer)
#!!#
########################################################################################################################
namespace: Ansible_Tower.Job_Templates
flow:
  name: Attach_Credentials_to_Job_Template
  inputs:
    - TemplateID
    - CredentialID
  workflow:
    - Attach_CredentialID_to_Job_TemplateID:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('AnsibleTowerURL')+'/job_templates/'+TemplateID+'/credentials/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
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
