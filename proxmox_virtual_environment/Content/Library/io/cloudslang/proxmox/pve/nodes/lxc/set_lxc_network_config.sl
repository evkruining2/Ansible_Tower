namespace: io.cloudslang.proxmox.pve.nodes.lxc
flow:
  name: set_lxc_network_config
  inputs:
    - pveURL
    - pveUsername
    - pvePassword
    - TrustAllRoots
    - HostnameVerify
    - vmid
    - node
    - net
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
          - SUCCESS: http_client_action
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc/'+vmid+'/config'}"
            - auth_type: basic
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - keep_alive: 'true'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - response_character_set: utf-8
            - follow_redirects: 'false'
            - form_params_are_URL_encoded: 'true'
            - body: "${get('net')}"
            - content_type: application/x-www-form-urlencoded
            - request_character_set: utf-8
            - method: PUT
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${json_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ticket:
        x: 102
        'y': 107
      http_client_action:
        x: 281
        'y': 304
        navigate:
          92daa58b-b84a-434d-c4fe-4c9169710ab2:
            targetId: 75372d5b-a0a1-1f66-3a27-fe8bed6dd173
            port: SUCCESS
    results:
      SUCCESS:
        75372d5b-a0a1-1f66-3a27-fe8bed6dd173:
          x: 472
          'y': 114
