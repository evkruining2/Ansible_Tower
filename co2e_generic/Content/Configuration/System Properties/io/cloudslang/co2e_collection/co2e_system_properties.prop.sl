########################################################################################################################
#!!
#! @system_property proxy_host: Proxy server used to access the web site.
#! @system_property proxy_port: Proxy server port.Default: '8080'
#! @system_property worker_group: RAS worker group to use. Default: RAS_Operator_Path
#! @system_property trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted 
#!                                   even if no trusted certification authority issued it. Default: 'false'
#! @system_property x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the 
#!                                           subject's Common Name (CN) or subjectAltName field of the X.509 
#!                                           certificate. Set this to "allow_all" to skip any checking. For the value 
#!                                           "browser_compatible" the hostname verifier works the same way as Curl and 
#!                                           Firefox. The hostname must match either the first CN, or any of the 
#!                                           subject-alts. A wildcard can occur in the CN, and in any of the 
#!                                           subject-alts. The only difference between "browser_compatible" and "strict" 
#!                                           is that a wildcard (such as "*.foo.com") with "browser_compatible" matches 
#!                                           all subdomains, including "a.b.foo.com". Default: 'strict'
#! @system_property proxy_username: User name used when connecting to the proxy.
#! @system_property proxy_password: Proxy server password associated with the proxy_username input value.
#! @system_property azure_auth_url: Azure authentication URL
#! @system_property azure_tenant_id: Azure tenant ID
#! @system_property azure_client_id: Azure Client ID
#! @system_property azure_client_secret: Azure Client Secret
#! @system_property azure_subscription_id: Azure Subscription ID
#! @system_property climatiq_url: Climatiq.io API URL
#! @system_property climatiq_token: Climatiq.io Access Token
#! @system_property azure_url: Azure API URL
#! @system_property aws_accesskey: AWS Access Key
#! @system_property aws_secretkey: AWS Access Secret
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection
properties:
  - proxy_host:
      value: ''
      sensitive: false
  - proxy_port:
      value: ''
      sensitive: false
  - worker_group:
      value: RAS_Operator_Path
      sensitive: false
  - trust_all_roots:
      value: 'false'
      sensitive: false
  - x_509_hostname_verifier:
      value: strict
      sensitive: false
  - proxy_username:
      value: ''
      sensitive: false
  - proxy_password:
      value: ''
      sensitive: false
  - azure_auth_url:
      value: 'https://login.microsoftonline.com'
      sensitive: false
  - azure_tenant_id:
      value: 6002e264-31f7-43d3-a51e-9ed1ba9ca689
      sensitive: false
  - azure_client_id:
      value: 365b64e7-7b0a-41fc-893f-69438f93e943
      sensitive: false
  - azure_client_secret:
      value: 8e48Q~M3AqtHfjfLsSwUeHeLXtrlHxYZr~D_Pafj
      sensitive: true
  - azure_subscription_id:
      value: 4d08f192-8c63-49fa-a461-5cdd32ce42dc
      sensitive: false
  - climatiq_url:
      value: 'https://beta3.api.climatiq.io'
      sensitive: false
  - climatiq_token:
      value: Y3Q5BATS8TM2ARKBB18Y8MN95HX1
      sensitive: true
  - azure_url:
      value: 'https://management.azure.com'
      sensitive: false
  - aws_accesskey:
      value: AKIARHRVZWALGMFI6VF7
      sensitive: false
  - aws_secretkey:
      value: '********'
      sensitive: true
