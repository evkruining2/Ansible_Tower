namespace: io.cloudslang.energy_project.easyenergy
flow:
  name: round_numbers
  inputs:
    - list: '0.1292885,0.12584,0.11374,0.10527,0.068486,0.0240669,0.0018634,1.089E-4,0.0,-7.26E-5,-0.0121968,-0.0350779,-0.0542927,-0.0791824,-0.0967879,-0.0679657,-0.0352957,-0.005445,-1.21E-5,0.0388289,0.0847,0.0820017,0.0765325,0.0492712'
  workflow:
    - round_to_4_decimals:
        do:
          io.cloudslang.energy_project.tools.round_to_4_decimals:
            - input: '1.3434343'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - tariff_list
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      round_to_4_decimals:
        x: 200
        'y': 200
        navigate:
          502822a0-98d7-f671-3556-901e5aff9431:
            targetId: a7601524-c572-ffe6-45a2-83e9e6534e53
            port: SUCCESS
    results:
      SUCCESS:
        a7601524-c572-ffe6-45a2-83e9e6534e53:
          x: 440
          'y': 240
