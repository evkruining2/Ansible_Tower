########################################################################################################################
#!!
#! @description: Installs the Puppet agent on a Windows target system
#!
#! @input PuppetEnterpriseURL: Puppet Enterprise URL. Example: https://pemaster.example.com
#! @input host: The hostname or ip address of the target node to install the PE agent. Example: pupnode1.example.com
#! @input username: The username to login to the target node. Example: administrator
#! @input password: Password for the user on the target node
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!!#
########################################################################################################################
namespace: io.cloudslang.puppet.puppet_enterprise.nodes
flow:
  name: install_agent_windows
  inputs:
    - PuppetEnterpriseURL
    - host
    - username
    - password:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
  workflow:
    - powershell_script:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - script: "${'[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFile(\\''+PuppetEnterpriseURL+':8140/packages/current/install.ps1\\', \\'install.ps1\\'); .\\\\install.ps1 -v'}"
            - operation_timeout: '600'
        publish:
          - return_result
          - return_code
          - script_exit_code
          - stderr
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - script_exit_code: '${script_exit_code}'
    - stderr: '${stderr}'
    - return_code: '${return_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      powershell_script:
        x: 153
        'y': 122
        navigate:
          f33ae499-964b-a339-c392-15d2b278ef48:
            targetId: 158ed0db-383b-2402-d4ff-edd73f0443c7
            port: SUCCESS
    results:
      SUCCESS:
        158ed0db-383b-2402-d4ff-edd73f0443c7:
          x: 406
          'y': 111.5
