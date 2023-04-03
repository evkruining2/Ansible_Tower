########################################################################################################################
#!!
#! @description: This operation takes a JSON array as input and creates flow variables from the configured key values
#!               
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.tools
operation:
  name: set_flow_variables
  inputs:
    - json_list
    - index: '0'
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(json_list,index):\n    # code goes here\n    import json\n    \n    data = json.loads(json_list)\n    index = int(index)\n    \n    aws_region = data[index]['aws_region']\n    instance_name = data[index]['instance_name']\n    instance_state = data[index]['instance_state']\n    instance_type = data[index]['instance_type']\n    instance_id = data[index]['instance_id']\n    reservation_id = data[index]['reservation_id']\n\n    \n    return locals()\n    # you can add additional helper methods below."
  outputs:
    - reservation_id
    - instance_id
    - instance_type
    - instance_state
    - instance_name
    - aws_region
  results:
    - SUCCESS
