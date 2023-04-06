namespace: io.cloudslang.tools
flow:
  name: ssh_error_test
  inputs:
    - host
    - user
    - passwd:
        sensitive: true
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: ls
            - pty: 'true'
            - username: '${user}'
            - password:
                value: '${passwd}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
  results:
    - SUCCESS
    - FAILURE_1
extensions:
  graph:
    steps:
      ssh_command:
        x: 200
        'y': 160
        navigate:
          0595edb4-f30b-af40-2be6-5b766c5f683f:
            targetId: 2d275f72-a8a5-acb8-1b1c-24987e7fdead
            port: SUCCESS
          d60c88ea-a6b0-73aa-c1b5-84738486b285:
            targetId: 87b3f768-e17e-9211-2984-910149580188
            port: FAILURE
    results:
      SUCCESS:
        2d275f72-a8a5-acb8-1b1c-24987e7fdead:
          x: 400
          'y': 160
      FAILURE_1:
        87b3f768-e17e-9211-2984-910149580188:
          x: 360
          'y': 360
