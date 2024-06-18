namespace: io.cloudslang.energy_project.tools
operation:
  name: round_to_3_decimals
  inputs:
    - input
  python_action:
    script: 'output = round(float(input),3)'
  outputs:
    - output
  results:
    - SUCCESS
