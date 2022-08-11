########################################################################################################################
#!!
#! @input jre_version: JRE minor version, eg: 271, 281 or 291
#!!#
########################################################################################################################
namespace: tests
flow:
  name: Install_JRE_Windows
  inputs:
    - jre_version
  workflow:
    - powershell_script:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: 192.168.2.219
            - port: '5985'
            - protocol: http
            - username: administrator
            - password:
                value: admin@123
                sensitive: true
            - script: "${'Start-Process \"c:\\\\temp\\jre-8u'+jre_version+'-windows-x64.exe\" -ArgumentList \"INSTALL_SILENT=Enable REBOOT=Disable SPONSORS=Disable\" -Wait -PassThru -NoNewWindow'}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - detected_jre: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      powershell_script:
        x: 231
        'y': 130
        navigate:
          3f447133-281b-ee79-4227-08e48bb698bf:
            targetId: c1551ac7-c10c-0702-29e5-1e1a452cb6b0
            port: SUCCESS
    results:
      SUCCESS:
        c1551ac7-c10c-0702-29e5-1e1a452cb6b0:
          x: 408
          'y': 263.5
