########################################################################################################################
#!!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.qemu.agent
flow:
  name: get_vm_ip
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.proxmox.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.proxmox.x_509_hostname_verifier')}"
    - node
    - vmid
  workflow:
    - get_ticket:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_network_from_agent
    - get_network_from_agent:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/qemu/'+vmid+'/agent/network-get-interfaces'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: "${'Cookie:PVEAuthCookie='+pveTicket}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_netinfo
          - FAILURE: sleep_for_two_minutes
    - get_netinfo:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data
        publish:
          - netinfo: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: get_ip_address
          - FAILURE: on_failure
    - get_ip_address:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: '$.data.result[0].ip-addresses[0].ip-address'
        publish:
          - primary_ip_address: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_ip_address_1
          - FAILURE: on_failure
    - sleep_for_two_minutes:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '120'
        navigate:
          - SUCCESS: get_network_from_agent_second_try
          - FAILURE: on_failure
    - get_network_from_agent_second_try:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/qemu/'+vmid+'/agent/network-get-interfaces'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: "${'Cookie:PVEAuthCookie='+pveTicket}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_netinfo
          - FAILURE: on_failure
    - get_ip_address_1:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: '$.data.result[1].ip-addresses[0].ip-address'
        publish:
          - secondary_ip_address: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - netinfo: '${netinfo}'
    - primary_ip_address: '${primary_ip_address}'
    - secondary_ip_address: '${secondary_ip_address}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_ticket:
        x: 80
        'y': 80
      get_network_from_agent:
        x: 80
        'y': 240
      get_netinfo:
        x: 400
        'y': 240
      get_ip_address:
        x: 400
        'y': 80
      sleep_for_two_minutes:
        x: 80
        'y': 440
      get_network_from_agent_second_try:
        x: 400
        'y': 440
      get_ip_address_1:
        x: 640
        'y': 80
        navigate:
          d8825518-1ce7-4f89-59e1-3efa8b0b1514:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 640
          'y': 240
