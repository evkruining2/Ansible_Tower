namespace: io.cloudslang.tests
flow:
  name: ssh_command
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: 192.168.2.30
            - command: date
            - username: root
            - password:
                value: gehakt
                sensitive: true
            - use_shell: 'false'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 280
        'y': 240
        navigate:
          be47e347-e900-1c66-a9cc-7b2c8ecddbcd:
            targetId: 016fdb0f-93ae-dd07-f3ea-181b032db1af
            port: SUCCESS
    results:
      SUCCESS:
        016fdb0f-93ae-dd07-f3ea-181b032db1af:
          x: 520
          'y': 280
