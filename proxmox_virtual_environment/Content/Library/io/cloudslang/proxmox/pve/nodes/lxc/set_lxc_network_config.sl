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
          - SUCCESS: http_client_put
    - http_client_put:
        do:
          io.cloudslang.base.http.http_client_put:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc/'+vmid+'/config'}"
            - auth_type: basic
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - body: "${'net0='+net0}"
            - content_type: application/x-www-form-urlencoded
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
      http_client_put:
        x: 289
        'y': 95
        navigate:
          8b3bcd30-9394-261b-b2d2-b09c8363b182:
            targetId: 75372d5b-a0a1-1f66-3a27-fe8bed6dd173
            port: SUCCESS
    results:
      SUCCESS:
        75372d5b-a0a1-1f66-3a27-fe8bed6dd173:
          x: 472
          'y': 114
