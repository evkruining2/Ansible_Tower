########################################################################################################################
#!!
#! @input row_number: select a number between 1 and 10
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user.xls_processing
flow:
  name: read_xls_data
  inputs:
    - row_number
  workflow:
    - get_xls:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: localhost
            - command: 'smbclient //10.0.10.3/Shared -U guest% -c "get data/names-1.xls /tmp/names-1.xls"'
            - username: root
            - password:
                value: "${get_sp('onboarding.root_password')}"
                sensitive: true
        navigate:
          - SUCCESS: get_cell
          - FAILURE: on_failure
    - get_cell:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: /tmp/names-1.xls
            - row_index: '${row_number}'
        publish:
          - line: '${return_result}'
        navigate:
          - SUCCESS: Set_Flow_variables
          - FAILURE: on_failure
    - remove_xls:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: localhost
            - command: rm /tmp/names-1.xls
            - username: root
            - password:
                value: "${get_sp('root_password')}"
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Set_Flow_variables:
        do:
          io.cloudslang.onboarding_new_user.xls_processing.Set_Flow_variables:
            - line: '${line}'
        publish:
          - a
          - b
          - c
          - d
          - e
          - f
        navigate:
          - SUCCESS: remove_xls
  outputs:
    - first_name: '${a}'
    - last_name: '${b}'
    - login_name: '${c}'
    - email_address: '${d}'
    - employee_id: '${e}'
    - phone_number: '${f}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_xls:
        x: 80
        'y': 120
      get_cell:
        x: 280
        'y': 240
      remove_xls:
        x: 480
        'y': 360
        navigate:
          a1098fd3-fa18-e64b-4b43-27f3dbaf6723:
            targetId: 7a027881-2fd5-69e3-c80b-4c2018187a50
            port: SUCCESS
      Set_Flow_variables:
        x: 280
        'y': 440
    results:
      SUCCESS:
        7a027881-2fd5-69e3-c80b-4c2018187a50:
          x: 480
          'y': 120
