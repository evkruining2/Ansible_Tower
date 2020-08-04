########################################################################################################################
#!!
#! @description: Bootstrap a node with puppet-agent (install puppet agent on target) from Puppet Enterprise
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: Certificate name of hostname of the new node to install the agent on. Example: pupnode3.example.com
#! @input environment: The environment in which the node should be bootstrapped
#!
#! @output job_number: List of Puppet Enterprise groups
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.orchestrator.tasks
flow:
  name: pe_bootstrap
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - node
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
          - pemaster: '${PuppetEnterpriseURL.replace("https://","")}'
        navigate:
          - SUCCESS: http_client_action
          - FAILURE: on_failure
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':8143/orchestrator/v1/command/task'}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - body: "${'{'+\\\n'   \"environment\" : \"'+environment+'\",'+\\\n'   \"task\" : \"pe_bootstrap\",'+\\\n'   \"params\" : {'+\\\n'   \"master\" : \"'+pemaster+'\"'+\\\n'   },'+\\\n'   \"scope\" : {'+\\\n'   \"nodes\" : [\"'+node+'\"]'+\\\n'   }'+\\\n'}'}"
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
        'y': 96
      http_client_action:
        x: 225
        'y': 109
      json_path_query:
        x: 391
        'y': 110
        navigate:
          e1a8bd05-b210-17c3-4fa5-f7afdcf9c468:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 558
          'y': 109
