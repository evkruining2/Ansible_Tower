namespace: io.cloudslang.tools
operation:
  name: add_string_to_each_line_in_textfile
  inputs:
    - file_name
    - string_to_add
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(file_name,string_to_add):\n    with open(file_name, 'r') as f:\n        file_lines = [''.join([x.strip(), string_to_add, '\\n']) for x in f.readlines()]\n\n    with open(file_name, 'w') as f:\n        f.writelines(file_lines)"
  results:
    - SUCCESS
