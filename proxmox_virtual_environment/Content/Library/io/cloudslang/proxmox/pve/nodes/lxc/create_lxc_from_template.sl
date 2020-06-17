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
        sensitive: false
    - storage
    - node
    - hostname
    - net0
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
          - SUCCESS: create_lxc_from_template
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
            - body: "${'ostemplate='+ostemplate+\\\n'&password='+containerpassword+\\\n'&vmid='+vmid+\\\n'&storage='+storage+\\\n'&hostname='+hostname}"
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
        x: 233
        'y': 68
      get_status_id:
        x: 414
        'y': 69
        navigate:
          8f3e3409-fbf1-75fc-0525-8873c306ce8a:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 566
          'y': 255
