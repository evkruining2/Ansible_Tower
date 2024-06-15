namespace: io.cloudslang.energy_project.tools
operation:
  name: get_smallest_number_in_list
  inputs:
    - input: '${0.968,-0.068,-0.0353,-0}'
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(input):
          new_list= []
          for each in input:
              Integer = float(each)
              new_list.append(Integer)

          output = min(new_list)
          return locals()
      # you can add additional helper methods below.
  outputs:
    - output
    - new_list
  results:
    - SUCCESS
