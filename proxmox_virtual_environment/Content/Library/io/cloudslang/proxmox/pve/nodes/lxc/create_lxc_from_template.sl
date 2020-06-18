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
    - ostemplate
    - vmid
    - containerpassword:
        sensitive: true
    - storage
    - node
    - hostname
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
          - SUCCESS: build_http_body
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
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - build_http_body:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.build_http_body:
            - ostemplate: '${ostemplate}'
            - containerpassword: '${containerpassword}'
            - storage: '${storage}'
            - hostname: '${hostname}'
            - memory: '${memory}'
            - nameserver: '${nameserver}'
            - net0: '${net0}'
            - net1: '${net1}'
            - net2: '${net2}'
            - net3: '${net3}'
        publish:
          - body
        navigate:
          - SUCCESS: create_lxc_from_template
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${JobStatus}'
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
        x: 375
        'y': 67
      get_status_id:
        x: 566
        'y': 65
        navigate:
          8f3e3409-fbf1-75fc-0525-8873c306ce8a:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
      build_http_body:
        x: 214
        'y': 67
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 566
          'y': 255
