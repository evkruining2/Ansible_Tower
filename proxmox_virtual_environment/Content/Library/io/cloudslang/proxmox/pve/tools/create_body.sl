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

namespace: io.cloudslang.proxmox.pve.tools
operation:
  name: create_body
  inputs:
    - param_full:
        required: false
    - param_name:
        required: false
    - param_pool:
        required: false
    - param_storage:
        required: false
    - param_target:
        required: false
  python_action:
    script: "inputs = locals()                                           # all local variables\r\nprefix = 'param_'                                           # serialize just variables starting with this prefix\r\nrequest = ''                                                # string accumulator\r\nfor key, value in inputs.items():                           # iterate all parameters\r\n    if key.startswith(prefix) and value is not None:        # if parameter given\r\n        key = key[len(prefix):]                             # skip prefix\r\n        request += \"&\" + str(key) + '=' + str(value)\r\nrequest = request[1:]                                       #skip the very first delimiter\r\n                                                            #code by Petr Panuska"
  outputs:
    - request: '${request}'
  results:
    - SUCCESS
