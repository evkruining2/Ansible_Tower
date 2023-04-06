namespace: io.cloudslang.tools
flow:
  name: autoremove_old_packages
  inputs:
    - host: localhost
    - username: root
    - password:
        sensitive: true
    - command: dnf autoremove -y
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
        x: 160
        'y': 160
        navigate:
          1d0ae1de-2f95-c909-daf0-faaa769d213a:
            targetId: 8ebe4025-8078-e554-5c51-2a0298d57d41
            port: SUCCESS
    results:
      SUCCESS:
        8ebe4025-8078-e554-5c51-2a0298d57d41:
          x: 360
          'y': 160
