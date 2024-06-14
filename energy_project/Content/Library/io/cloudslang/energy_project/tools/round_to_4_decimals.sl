namespace: io.cloudslang.energy_project.tools
operation:
  name: round_to_4_decimals
  inputs:
    - input
  python_action:
    script: 'output = round(input,4)'
  outputs:
    - output
  results:
    - SUCCESS
