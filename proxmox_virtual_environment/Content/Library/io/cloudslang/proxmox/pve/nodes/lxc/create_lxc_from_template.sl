namespace: io.cloudslang.proxmox.pve.nodes.lxc
flow:
  name: create_lxc_from_template
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - node
    - vmid
    - ostemplate
    - containerpassword:
        sensitive: true
    - storage
    - hostname:
        required: false
    - memory:
        required: false
    - nameserver:
        required: false
    - net0:
        required: false
    - net1:
        required: false
    - net2:
        required: false
    - net3:
        required: false
  workflow:
    - get_ticket:
        do:
          io.cloudslang.proxmox.pve.access.get_ticket:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pveTicket
          - pveToken
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_urlencoded_body
    - create_lxc_from_template:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc'}"
            - auth_type: basic
            - username: '${pveUsername}'
            - password:
                value: '${pvePassword}'
                sensitive: true
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - body: "${body+'&vmid='+vmid}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_status_id
          - FAILURE: on_failure
    - get_status_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data
        publish:
          - JobStatus: "${return_result.strip('[').strip(']').strip('\"')}"
          - loops: '10'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - get_task_status:
        loop:
          for: i in loops
          do:
            io.cloudslang.proxmox.pve.nodes.tasks.get_task_status:
              - node: '${node}'
              - upid: '${JobStatus}'
              - pveURL: '${pveURL}'
              - pveUsername: '${pveUsername}'
              - pvePassword: '${pvePassword}'
              - TrustAllRoots: '${TrustAllRoots}'
              - HostnameVerify: '${HostnameVerify}'
          break:
            - FAILURE
          publish:
            - TaskStatus
            - ExitStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_task_finished
    - is_task_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${TaskStatus}'
            - second_string: stopped
            - ignore_case: 'true'
        navigate:
          - SUCCESS: is_exitstatus_ok
          - FAILURE: sleep
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - is_exitstatus_ok:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ExitStatus}'
            - second_string: ok
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - create_urlencoded_body:
        do:
          io.cloudslang.proxmox.pve.tools.create_urlencoded_body:
            - param_ostemplate: '${ostemplate}'
            - param_password: '${containerpassword}'
            - param_containerpassword: '${containerpassword}'
            - param_memory: '${memory}'
            - param_storage: '${storage}'
            - param_hostname: '${hostname}'
            - param_nameserver: '${nameserver}'
            - param_net0: '${net0}'
            - param_net1: '${net1}'
            - param_net2: '${net2}'
            - param_net3: '${net3}'
        publish:
          - body: '${request}'
        navigate:
          - SUCCESS: create_lxc_from_template
  outputs:
    - JobStatus: '${JobStatus}'
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_ticket:
        x: 59
        'y': 65
      create_lxc_from_template:
        x: 51
        'y': 437
      get_status_id:
        x: 219
        'y': 436
      is_exitstatus_ok:
        x: 418
        'y': 63
        navigate:
          6dad6403-8964-563b-cc2a-9b71c3f6163f:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
      get_task_status:
        x: 214
        'y': 237
      is_task_finished:
        x: 217
        'y': 60
      sleep:
        x: 424
        'y': 247
      create_urlencoded_body:
        x: 57
        'y': 244
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 618
          'y': 60