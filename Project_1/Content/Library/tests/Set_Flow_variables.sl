
########################################################################################################################
#!!
#! @description: Sets multiple flow variables (e.g. "a", "b" "c"  and "d"), based on comma-separated list as input. The default number of values in the list is four. If you need more, add the variable to the python script, increase the number in the "split()" statement and add the added variable(s) to the outputs.
#!!#
########################################################################################################################
namespace: tests
operation:
  name: Set_Flow_variables
  inputs:
    - line
  python_action:
    script: "a,b,c,d = line.split(',',3)"
  outputs:
    - a
    - b
    - c
    - d
  results:
    - SUCCESS
