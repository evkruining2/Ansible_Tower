namespace: tests
flow:
  name: Check_JRE_Version_Windows
  inputs:
    - required_jre
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
            - script: "dir \"HKLM:\\SOFTWARE\\JavaSoft\\Java Runtime Environment\"  | select -expa pschildname -Last 1"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - detected_jre: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${detected_jre}'
            - second_string: '${required_jre}'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      powershell_script:
        x: 177
        'y': 124.5
      string_equals:
        x: 406
        'y': 130
        navigate:
          5dd30526-f57b-c8cb-95e1-20da065c96a8:
            targetId: 44baa2c3-5df2-e6a5-c71b-92b96e61bbc2
            port: SUCCESS
          c7849d3e-4576-bff2-97f7-9d6b5de7738b:
            targetId: da51e922-620b-4170-6920-9a32947528cc
            port: FAILURE
    results:
      SUCCESS:
        44baa2c3-5df2-e6a5-c71b-92b96e61bbc2:
          x: 506
          'y': 250
      FAILURE:
        da51e922-620b-4170-6920-9a32947528cc:
          x: 306
          'y': 315.5
