########################################################################################################################
#!!
#! @description: Run a Puppet Agent job on a group of nodes in Puppet Enterprise identified by the group ID
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input group_id: The id of the group of node to run the puppet agent on. Example: 17a15e19-a7bc-4a9c-90b7-f1f6ef5b2234
#! @input noop: Boolean, whether to run the agent in no-op mode. The default is false
#! @input environment: The environment to deploy. Default is "production"
#!
#! @output job_number: Puppet Enterprise group details
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.orchestrator.jobs
flow:
  name: puppet_agent_run_on_a_group
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - group_id
    - noop: 'false'
    - environment: production
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
        navigate:
          - SUCCESS: http_client_action
          - FAILURE: on_failure
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':8143/orchestrator/v1/command/deploy'}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - body: "${'{'+\\\n'   \"environment\" : \"'+environment+'\",'+\\\n'   \"noop\" : '+noop+','+\\\n'   \"scope\" : {'+\\\n'   \"node_group\" : \"'+group_id+'\"'+\\\n'   }'+\\\n'}'}"
            - content_type: application/json
            - method: post
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $..name
        publish:
          - job_number: "${return_result.strip('[').strip(']').strip('\"')}"
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
        'y': 96
      http_client_action:
        x: 225
        'y': 109
      json_path_query:
        x: 382
        'y': 114
        navigate:
          53bcfa79-90d8-d2dc-5c67-b3030ddf9f9a:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 543
          'y': 117
