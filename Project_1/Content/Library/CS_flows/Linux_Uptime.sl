namespace: CS_flows
flow:
  name: Linux_Uptime
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: localhost
            - command: uptime
            - username: root
            - password:
                prompt:
                  type: text
                  message: Enter password for user Root
        publish:
          - standard_out
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - uptime: '${standard_out}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 123
        'y': 111
        navigate:
          7eb10b66-6fe5-e145-84f7-eeaabeb47b64:
            targetId: ad7539c2-3a03-2f3b-003b-a91f4981d9a8
            port: SUCCESS
    results:
      SUCCESS:
        ad7539c2-3a03-2f3b-003b-a91f4981d9a8:
          x: 340
          'y': 106
