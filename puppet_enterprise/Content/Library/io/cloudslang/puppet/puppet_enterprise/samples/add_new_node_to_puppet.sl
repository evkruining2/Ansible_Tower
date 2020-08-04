########################################################################################################################
#!!
#! @description: This is an end-to-end sample flow that will create a connection for a new node in Puppet Enterprise, bootstrap the Puppet Agent on the new node, accepts the unsigned certificate from the new node adds the new node to an existing group (identified by the group ID)
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input PuppetUsername: Puppet Enterprise User Name
#! @input PuppetPassword: Puppet Enterprise User Password
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input environment: The environment to deploy. Default is "production"
#! @input group_id: ID of the Puppet Enterprise group to add the node to
#! @input node: The name of the certificate or node to to run the puppet agent on. Example: pupnode2.example.com
#! @input type: String containing either ssh or winrm. Instructs bolt-server which connection type to use to access the node when running a task
#! @input port: Connection port with the default of 22 for ssh. For winrm use port 5985
#! @input user: The user to log in as when connecting to the target node
#! @input password: Password to authenticate to target node
#! @input connect_timeout: The length of time, in seconds, PE should wait when establishing connections
#! @input duplicates: String containing either error or replace. Instructs how to handle cases where one or more provided certnames conflict with existing certnames stored in the inventory connections database. error results in a 409 response if any certnames are duplicates. replace overwrites the existing certnames if there are conflicts
#!
#! @output connection_id: The connection ID of the new node in Puppet Enterprise
#! @output job_number: Job number/name of the pe_bootstrap task
#! @output job_status: Status of the pe_bootstrap job
#! @output signing_job_id: Job ID of the certificate signing operation
#! @output status_code: Status code of adding node to the group (status 204 is success)
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.samples
flow:
  name: add_new_node_to_puppet
  inputs:
    - PuppetEnterpriseURL
    - PuppetUsername
    - PuppetPassword
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - environment:
        default: production
        required: true
    - group_id: 00000000-0000-4000-8000-000000000000
    - node
    - type: ssh
    - port: '22'
    - user: root
    - password:
        sensitive: true
    - connect_timeout:
        default: '600'
        required: false
    - duplicates:
        default: replace
        required: false
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
          - SUCCESS: create_connection
          - FAILURE: on_failure
    - create_connection:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':8143/inventory/v1/command/create-connection'}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - body: "${'{'+\\\n'\t\"certnames\": [\"'+node+'\"],'+\\\n'\t\"type\": \"'+type+'\",'+\\\n'\t\"parameters\": {'+\\\n'\t\"port\": '+port+','+\\\n'\t\"connect-timeout\": '+connect_timeout+','+\\\n'\t\"user\": \"'+user+'\"'+\\\n'\t},'+\\\n'\t\"sensitive_parameters\": {'+\\\n'\t\"password\": \"'+password+'\"'+\\\n'\t},'+\\\n'\t\"duplicates\": \"'+duplicates+'\"'+\\\n'}'}"
            - content_type: application/json
            - method: post
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: get_connection_id
          - FAILURE: on_failure
    - get_connection_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $..connection_id
        publish:
          - connection_id: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: pe_bootstrap
          - FAILURE: on_failure
    - pe_bootstrap:
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
          - SUCCESS: get_job_status
          - FAILURE: on_failure
    - get_job_status:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':8143/orchestrator/v1/jobs/'+job_number}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - content_type: application/json
            - method: get
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: get_jobstatus
          - FAILURE: on_failure
    - get_jobstatus:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.node_states
        publish:
          - job_status: "${return_result.replace(':1','').strip('{').strip('}').strip('\"')}"
        navigate:
          - SUCCESS: still_running
          - FAILURE: on_failure
    - still_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep_for_15_seconds
          - FAILURE: is_finished
    - sleep_for_15_seconds:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '15'
        navigate:
          - SUCCESS: get_job_status
          - FAILURE: on_failure
    - is_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: finished
        navigate:
          - SUCCESS: sign_node_certificate
          - FAILURE: on_failure
    - sign_node_certificate:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':8143/orchestrator/v1/command/task'}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - body: "${'{'+\\\n'   \"environment\" : \"'+environment+'\",'+\\\n'   \"task\" : \"enterprise_tasks::sign\",'+\\\n'   \"params\" : {'+\\\n'   \"host\" : \"'+node+'\"'+\\\n'   },'+\\\n'   \"scope\" : {'+\\\n'   \"nodes\" : [\"'+pemaster+'\"]'+\\\n'   }'+\\\n'}'}"
            - content_type: application/json
            - method: post
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: signing_job_id
          - FAILURE: on_failure
    - signing_job_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.job.id
        publish:
          - signing_job_id: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: add_node_to_group
          - FAILURE: on_failure
    - add_node_to_group:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${PuppetEnterpriseURL+':4433/classifier-api/v1/groups/'+group_id+'/pin?nodes='+node}"
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'X-Authentication:'+pe_token}"
            - content_type: application/json
            - method: post
        publish:
          - json_output: '${return_result}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - connection_id: '${connection_id}'
    - job_number: '${job_number}'
    - job_status: '${job_status}'
    - signing_job_id: '${signing_job_id}'
    - status_code: '${status_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_connection:
        x: 64
        'y': 219
      sleep_for_15_seconds:
        x: 253
        'y': 566
      pe_bootstrap:
        x: 249
        'y': 76
      get_jobstatus:
        x: 459
        'y': 390
      is_finished:
        x: 672
        'y': 566
      still_running:
        x: 459
        'y': 566
      get_auth_token:
        x: 61
        'y': 75
      get_connection_id:
        x: 65
        'y': 387
      signing_job_id:
        x: 667
        'y': 221
      add_node_to_group:
        x: 669
        'y': 75
        navigate:
          82b14e07-a331-0d72-9d44-7b26f04e8ce8:
            targetId: a66e6333-ed0f-a969-912a-f65115102154
            port: SUCCESS
      sign_node_certificate:
        x: 669
        'y': 390
      get_job_status:
        x: 251
        'y': 387
      get_jobnumber:
        x: 250
        'y': 222
    results:
      SUCCESS:
        a66e6333-ed0f-a969-912a-f65115102154:
          x: 839
          'y': 73
