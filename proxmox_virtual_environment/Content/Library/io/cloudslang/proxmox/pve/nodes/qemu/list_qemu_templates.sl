########################################################################################################################
#!!
#! @description: Get a Comma separated list of template VMIDs and names from the selected PVE node
#!
#! @output vmids: Comma separated list of template VMIDs and names
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.qemu
flow:
  name: list_qemu_templates
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - node
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vmids
    - get_vmids:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/qemu'}"
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
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: '$.data..[?(@.template==1)].vmid'
        publish:
          - vmids: "${return_result.strip('[').strip(']')}"
          - list: "${'vmid,name'+'\\r\\n'}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${vmids}'
            - separator: ','
        publish:
          - vmid: "${result_string.strip('\"')}"
        navigate:
          - HAS_MORE: get_template_name
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_template_name:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/qemu/'+vmid+'/config'}"
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
          - SUCCESS: append
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data..name
        publish:
          - name: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: append_1
          - FAILURE: on_failure
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${list}'
            - text: '${vmid}'
        publish:
          - list: "${new_string+','}"
        navigate:
          - SUCCESS: json_path_query_1
    - append_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${list}'
            - text: '${name}'
        publish:
          - list: "${new_string+'\\r\\n'}"
        navigate:
          - SUCCESS: list_iterator
  outputs:
    - vmids: '${list}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_ticket:
        x: 78
        'y': 93
      get_vmids:
        x: 80
        'y': 269
      json_path_query:
        x: 78
        'y': 431
      list_iterator:
        x: 287
        'y': 443
        navigate:
          c77081a3-e5f3-4c2f-2d6f-659be93ab99f:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: NO_MORE
      get_template_name:
        x: 284
        'y': 273
      json_path_query_1:
        x: 496
        'y': 95
      append:
        x: 285
        'y': 96
      append_1:
        x: 501
        'y': 267
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 503
          'y': 439
