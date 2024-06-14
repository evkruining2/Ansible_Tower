
########################################################################################################################
#!!
#! @description: Sets multiple flow variables (e.g. "a", "b" "c"  and "d"), based on comma-separated list as input. The default number of values in the list is four. If you need more, add the variable to the python script, increase the number in the "split()" statement and add the added variable(s) to the outputs.
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.tools
operation:
  name: set_flow_variables
  inputs:
    - list
  python_action:
    script: "h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,h21,h22,h23 = list.split(',',24)"
  outputs:
    - h0
    - h1
    - h2
    - h3
    - h4
    - h5
    - h6
    - h7
    - h8
    - h9
    - h10
    - h11
    - h12
    - h13
    - h14
    - h15
    - h16
    - h17
    - h18
    - h19
    - h20
    - h21
    - h22
    - h23
  results:
    - SUCCESS
