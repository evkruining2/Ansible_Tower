namespace: tests
flow:
  name: windows_command
  workflow:
    - powershell_script_sample:
        do:
          io.cloudslang.base.powershell.powershell_script_sample:
            - host: pupnode4.museumhof.net
            - protocol: https
            - username: administrator
            - password:
                value: admin@123
                sensitive: true
            - auth_type: basic
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - keystore_password:
                value: null
                sensitive: true
            - script: get-process
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      powershell_script_sample:
        x: 135
        'y': 144.5
        navigate:
          2a28581a-903d-e523-7753-e16f696c1620:
            targetId: 0d287cfc-2039-ca0c-a6d3-87ae20cf4ed7
            port: SUCCESS
    results:
      SUCCESS:
        0d287cfc-2039-ca0c-a6d3-87ae20cf4ed7:
          x: 289
          'y': 145
