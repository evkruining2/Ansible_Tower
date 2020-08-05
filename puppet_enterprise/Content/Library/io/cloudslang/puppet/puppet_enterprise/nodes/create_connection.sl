########################################################################################################################
#!!
#! @description: Create a new connection entry in the inventory service database.
#!               Connection entries contain connection options, such as credentials, which are used to connect to the certnames provided in the payload via the provided connection type.
#!               This endpoint also inserts each of the provided certnames into PuppetDB with an empty fact set, if they are not already present. After certnames have been added to PuppetDB, you can view them from the Nodes page in the Puppet Enterprise console. You can also add them to an inventory node list when you set up a job to run tasks.
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input certname: Certname to associate with connection information, usually the FQDN. Example: pupnode3.example.com
#! @input type: String containing either ssh or winrm. Instructs bolt-server which connection type to use to access the node when running a task
#! @input port: Connection port with the default of 22 for ssh. For winrm use port 5985
#! @input user: The user to log in as when connecting to the target node
#! @input password: Password to authenticate to target node
#! @input connect_timeout: The length of time, in seconds, PE should wait when establishing connections
#! @input duplicates: String containing either error or replace. Instructs how to handle cases where one or more provided certnames conflict with existing certnames stored in the inventory connections database. error results in a 409response if any certnames are duplicates. replace overwrites the existing certnames if there are conflicts
#!
#! @output connection_id: Puppet Enterprise group details
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.nodes
flow:
  name: create_connection
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword:
        sensitive: true
    - TrustAllRoots: flase
    - HostnameVerify: 'true'
    - certname
    - type: winrm
    - port:
        default: '5985'
        required: false
    - user: administrator
    - password:
        sensitive: true
    - connect_timeout:
        default: '600'
        required: false
    - duplicates: replace
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
            - url: "${PuppetEnterpriseURL+':8143/inventory/v1/command/create-connection'}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - body: "${'{'+\\\n'\t\"certnames\": [\"'+certname+'\"],'+\\\n'\t\"type\": \"'+type+'\",'+\\\n'\t\"parameters\": {'+\\\n'\t\"port\": '+port+','+\\\n'\t\"connect-timeout\": '+connect_timeout+','+\\\n'\t\"user\": \"'+user+'\"'+\\\n'\t},'+\\\n'\t\"sensitive_parameters\": {'+\\\n'\t\"password\": \"'+password+'\"'+\\\n'\t},'+\\\n'\t\"duplicates\": \"'+duplicates+'\"'+\\\n'}'}"
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
            - json_path: $..connection_id
        publish:
          - connection_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - connection_id: '${connection_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token:
        x: 53
        'y': 79
      http_client_action:
        x: 222
        'y': 82
      json_path_query:
        x: 372
        'y': 82
        navigate:
          3264b36b-6a54-36d5-a807-a47f88d13900:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 525
          'y': 91
