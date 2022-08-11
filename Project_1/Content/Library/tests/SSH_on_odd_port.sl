namespace: tests
flow:
  name: SSH_on_odd_port
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: 192.168.2.219
            - command: version
            - pty: 'true'
            - username: erwin
            - password:
                value: opsware
                sensitive: true
            - timeout: '1000'
            - connect_timeout: '5000'
            - use_shell: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 149
        'y': 169
        navigate:
          8b114039-8889-0774-7475-4ea4ed7b0aad:
            targetId: 085d493c-6381-bd39-785e-362c80f29799
            port: SUCCESS
    results:
      SUCCESS:
        085d493c-6381-bd39-785e-362c80f29799:
          x: 394
          'y': 122.5
