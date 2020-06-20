namespace: pve_test_flows
operation:
  name: create_urlencoded_body
  inputs:
    - ostemplate
    - containerpassword
    - storage
    - memory:
        required: false
    - hostname:
        required: false
    - nameserver:
        required: false
    - net1:
        required: false
    - net2:
        required: false
    - net3:
        required: false
    - net0:
        required: false
  python_action:
    use_jython: false
    script: "import urllib.parse\ndef execute(ostemplate, containerpassword, memory, storage, hostname, nameserver, net0, net1, net2, net3):\n    inputs = locals()                               # all local variables\n    delimiter = '$'                                 # because of defect 868514, replace with & once fixed\n    request = ''                                    # string accumulator\n    for key, value in inputs.items():               # iterate all parameters\n        if value is not None:                       # if parameter given\n            if key.startswith('net'):                  \n                value = urllib.parse.quote(value)   # encode all net* parameters\n            request += delimiter + key + '=' + value\n    return {\n        'request' : request[1:]                     #skip the very first delimiter\n    }"
  outputs:
    - request
  results:
    - SUCCESS
