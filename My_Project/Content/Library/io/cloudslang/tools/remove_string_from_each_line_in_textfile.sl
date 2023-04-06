namespace: io.cloudslang.tools
operation:
  name: remove_string_from_each_line_in_textfile
  inputs:
    - file_name
    - string_to_remove
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(file_name,string_to_remove):
          with open(file_name, mode='r', encoding='utf-8') as infile:
              inlines = infile.readlines()

          with open(file_name, mode='w', encoding='utf-8') as outfile:
              for line in inlines:
                  outfile.write(line.replace(string_to_remove, ''))
  results:
    - SUCCESS
