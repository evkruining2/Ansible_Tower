########################################################################################################################
#!!
#! @description: Reboot all nodes in an existing group (identified by the group ID)
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input environment: The environment to deploy. Default is "production"
#! @input group_id: ID of the Puppet Enterprise group to add the node to
#!
#! @output job_number: Job number/name of the pe_bootstrap task
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.samples
flow:
  name: reboot_all_nodes_in_a_group
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - environment:
        default: production
        required: true
    - group_id: 00000000-0000-4000-8000-000000000000
  workflow:
    - get_auth_token:
        do:
          io.cloudslang.puppet.puppet_enterprise.rbac.get_auth_token:
            - PuppetEnterpriseURL: '${PuppetEnterpriseURL}'
            - PuppetUsername: '${PuppetUsername}'
            - PuppetPassword: '${PuppetPassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pe_token
          - pemaster: '${PuppetEnterpriseURL.replace("https://","")}'
        navigate:
          - SUCCESS: run_reboot_task
          - FAILURE: on_failure
    - run_reboot_task:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':8143/orchestrator/v1/command/task'}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - body: "${'{'+\\\n'   \"environment\" : \"'+environment+'\",'+\\\n'   \"task\" : \"reboot\",'+\\\n'   \"params\" : {'+\\\n'   \"message\" : \"Rebooting now...\"'+\\\n'   },'+\\\n'   \"scope\" : {'+\\\n'   \"node_group\" : \"'+group_id+'\"'+\\\n'   }'+\\\n'}'}"
            - content_type: application/json
            - method: post
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: get_jobnumber
          - FAILURE: on_failure
    - get_jobnumber:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.job.name
        publish:
          - job_number: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - job_number: '${job_number}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token:
        x: 61
        'y': 75
      run_reboot_task:
        x: 247
        'y': 79
      get_jobnumber:
        x: 414
        'y': 80
        navigate:
          624e9278-57e3-d4d1-a5dd-a6808837a49e:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 568
          'y': 83
