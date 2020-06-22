namespace: pve_test_flows
operation:
  name: create_urlencoded_body2
  inputs:
    - param_ostemplate
    - param_containerpassword
    - param_memory:
        required: false
    - param_storage
    - param_hostname:
        required: false
    - param_nameserver:
        required: false
    - param_net0:
        required: false
    - param_net1:
        required: false
    - param_net2:
        required: false
    - param_net3:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function \ndef execute(): \n    # code goes here\n# you can add additional helper methods below.\n\nimport urllib\n \ninputs = locals()                                           # all local variables\nprefix = 'param_'                                           # serialize just variables starting with this prefix\nrequest = ''                                                # string accumulator\nfor key, value in inputs.items():                           # iterate all parameters\n    if key.startswith(prefix) and value is not None:        # if parameter given\n        key = key[len(prefix):]                             # skip prefix\n        if key.startswith('net'):                  \n            value = urllib.quote(value)                     # encode all net* parameters\n        request += \"&\" + str(key) + '=' + str(value)\nrequest = request[1:]                                       #skip the very first delimiter"
  outputs:
    - request
  results:
    - SUCCESS
