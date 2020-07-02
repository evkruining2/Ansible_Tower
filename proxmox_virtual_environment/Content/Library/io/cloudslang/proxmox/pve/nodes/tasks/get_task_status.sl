########################################################################################################################
#!!
#! @description: Get the status of a current or previous task
#!
#! @input upid: Task ID. Example: UPID:pve2:00003E60:081A0663:5EFD2E04:aptupdate::root@pam:
#!
#! @output TaskStatus: Status of a task
#! @output ExitStatus: Exitstatus of a taks
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.tasks
flow:
  name: get_task_status
  inputs:
    - pveURL
    - pveUsername
    - pvePassword
    - TrustAllRoots: 'false'
    - HostnameVerify: strict
    - node
    - upid
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
          - SUCCESS: get_task_status
    - get_task_status:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/tasks/'+upid+'/status'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_status
          - FAILURE: on_failure
    - get_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.status
        publish:
          - TaskStatus: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_exit_status
          - FAILURE: on_failure
    - get_exit_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.exitstatus
        publish:
          - ExitStatus: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS
  outputs:
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ticket:
        x: 86
        'y': 81
      get_task_status:
        x: 272
        'y': 84
      get_status:
        x: 447
        'y': 86
      get_exit_status:
        x: 605
        'y': 86
        navigate:
          bdae6068-83a1-1e42-01a6-2c738c10cae6:
            targetId: 06d8a696-d00b-cd7e-0f3f-c5fd72fb3707
            port: SUCCESS
          26a1164e-d7c6-81f2-0670-eadea35f9388:
            targetId: 06d8a696-d00b-cd7e-0f3f-c5fd72fb3707
            port: FAILURE
    results:
      SUCCESS:
        06d8a696-d00b-cd7e-0f3f-c5fd72fb3707:
          x: 696
          'y': 230
