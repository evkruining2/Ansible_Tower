########################################################################################################################
#!!
#! @input azure_auth_url: Azure authentication URL. Example: https://login.microsoftonline.com
#! @input tenant_id: Azure tenant ID
#! @input client_id: Azure Client ID
#! @input client_secret: Azure Client Secret
#! @input scope: Azure scope. Example: https://management.azure.com/.default
#! @input grant_type: Azure grant type. Example: client_credentials
#! @input worker_group: Optional -RAS worker group to use. Default: RAS_Operator_Path
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.Azure.subflows
flow:
  name: get_token
  inputs:
    - azure_auth_url: "${get_sp('io.cloudslang.co2e_collection.azure_auth_url')}"
    - tenant_id: "${get_sp('io.cloudslang.co2e_collection.azure_tenant_id')}"
    - client_id: "${get_sp('io.cloudslang.co2e_collection.azure_client_id')}"
    - client_secret:
        default: "${get_sp('io.cloudslang.co2e_collection.azure_client_secret')}"
        sensitive: true
    - scope: 'https://management.azure.com/.default'
    - grant_type: client_credentials
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
    - trust_all_roots:
        default: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
        required: false
    - x_509_hostname_verifier:
        default: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
        required: false
    - proxy_host:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_host')}"
        required: false
    - proxy_port:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_port')}"
        required: false
    - proxy_username:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_username')}"
        required: false
    - proxy_password:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_password')}"
        required: false
        sensitive: true
  workflow:
    - url_encode_scope_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${scope}'
        publish:
          - scope: '${result}'
        navigate:
          - SUCCESS: request_Azure_token
          - FAILURE: on_failure
    - request_Azure_token:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${azure_auth_url+'/'+tenant_id+'/oauth2/v2.0/token'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - body: "${'client_id='+client_id+'&scope='+scope+'&client_secret='+client_secret+'&grant_type='+grant_type}"
            - content_type: application/x-www-form-urlencoded
            - worker_group: '${worker_group}'
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: filter_token_from_json_result
          - FAILURE: on_failure
    - filter_token_from_json_result:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.access_token
        publish:
          - token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - azure_token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      request_Azure_token:
        x: 280
        'y': 80
      url_encode_scope_value:
        x: 80
        'y': 80
      filter_token_from_json_result:
        x: 480
        'y': 80
        navigate:
          2d82319f-b9e7-6bb9-f8a9-fdb64020ffca:
            targetId: 5b29e953-77f0-1365-a664-5b0f7c907e1d
            port: SUCCESS
    results:
      SUCCESS:
        5b29e953-77f0-1365-a664-5b0f7c907e1d:
          x: 640
          'y': 80
