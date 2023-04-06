namespace: io.cloudslang.tools
flow:
  name: install_CentOS_updates
  inputs:
    - host: localhost
    - username: root
    - password:
        sensitive: true
    - command: dnf update -y
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: '${command}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - return_result
          - return_code
          - standard_out
          - standard_err
          - exception
          - command_return_code
        navigate:
          - SUCCESS:
              next_step: SUCCESS
              ROI: '1'
          - FAILURE: on_failure
  outputs:
    - standard_out: '${standard_out}'
    - return_code: '${return_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 120
        'y': 120
        navigate:
          d1aaa330-48ae-d270-ec7c-41b53d20bd99:
            targetId: 339a23f0-91ab-d420-853f-b02943fe90c8
            port: SUCCESS
    results:
      SUCCESS:
        339a23f0-91ab-d420-853f-b02943fe90c8:
          x: 360
          'y': 120
