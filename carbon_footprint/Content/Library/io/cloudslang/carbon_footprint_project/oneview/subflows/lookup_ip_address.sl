namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
operation:
  name: lookup_ip_address
  inputs:
    - hostname
  python_action:
    use_jython: false
    script: "# do not remove the execute function \ndef execute(hostname): \n    import socket\n    \n    ip_address = socket.gethostbyname(hostname)\n    return locals()\n# you can add additional helper methods below."
  outputs:
    - ip_address
  results:
    - SUCCESS

