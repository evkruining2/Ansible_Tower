namespace: pve_test_flows
operation:
  name: create_urlencoded_body
  inputs:
    - ostemplate: "get('ostemplate')"
    - containerpassword
    - storage: "get('storage')"
    - memory
    - hostname
    - nameserver
    - net1: "get('net1')"
    - net2: "get('net2')"
    - net3: "get('net3')"
    - net0: "get('net0')"
  python_action:
    use_jython: false
    script: "import urllib.parse\ndef execute(ostemplate, containerpassword, memory, storage, hostname, nameserver, net0, net1, net2, net3):\n    inputs = locals()                               # all local variables\n    delimiter = '$'                                 # because of defect 868514, replace with & once fixed\n    request = ''                                    # string accumulator\n    for key, value in inputs.items():               # iterate all parameters\n        if value is not None:                       # if parameter given\n            if key.startswith('net'):                  \n                value = urllib.parse.quote(value)   # encode all net* parameters\n            request += delimiter + key + '=' + value\n    return {\n        'request' : request[1:]                     #skip the very first delimiter\n    }"
  outputs:
    - request: request
  results:
    - SUCCESS
