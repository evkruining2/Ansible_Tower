#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @result SUCCESS: 
#!!#
########################################################################################################################

namespace: pve_test_flows
operation:
  name: create_urlencoded_body3
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
    script: "import urllib\r\n\r\ninputs = locals()                                           # all local variables\r\nprefix = 'param_'                                           # serialize just variables starting with this prefix\r\nrequest = ''                                                # string accumulator\r\nfor key, value in inputs.items():                           # iterate all parameters\r\n    if key.startswith(prefix) and value is not None:        # if parameter given\r\n        key = key[len(prefix):]                             # skip prefix\r\n        if key.startswith('net'):                   \r\n            value = urllib.quote(value)                     # encode all net* parameters\r\n        request += \"&\" + str(key) + '=' + str(value)\r\nrequest = request[1:]                                       #skip the very first delimiter\r\n                                                            #code by Petr Panuska"
  outputs:
    - request: '${request}'
  results:
    - SUCCESS
