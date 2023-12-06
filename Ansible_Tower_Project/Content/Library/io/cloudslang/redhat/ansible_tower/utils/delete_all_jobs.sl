########################################################################################################################
#!!
#! @description: This flow will iterate through all finished jobs logs in Ansible Tower and removes them (to cleanup all your test runs)
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.utils
flow:
  name: delete_all_jobs
  inputs:
    - AnsibleTowerURL: "${get_sp('io.cloudslang.redhat.ansible.ansible_url')}"
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.redhat.ansible.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.redhat.ansible.x509_hostname_verifier')}"
  workflow:
    - Get_all_Jobs:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('AnsibleTowerURL')+'/jobs/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_array_of_IDs
          - FAILURE: on_failure
    - http_client_delete:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get('AnsibleTowerURL')+'/jobs/'+list_item+'/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
        navigate:
          - SUCCESS: Iterate_trough_IDs
          - FAILURE: on_failure
    - Get_array_of_IDs:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - output: "${return_result.strip('[').strip(']')}"
          - new_string: ''
        navigate:
          - SUCCESS: Iterate_trough_IDs
          - FAILURE: on_failure
    - Iterate_trough_IDs:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${output}'
        publish:
          - list_item: '${result_string}'
        navigate:
          - HAS_MORE: http_client_delete
          - NO_MORE: Get_all_Project_updates
          - FAILURE: on_failure
    - Get_all_Project_updates:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('AnsibleTowerURL')+'/project_updates/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_array_of_IDs_1
          - FAILURE: on_failure
    - Get_array_of_IDs_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - output: "${return_result.strip('[').strip(']')}"
          - new_string: ''
        navigate:
          - SUCCESS: Iterate_trough_IDs_1
          - FAILURE: on_failure
    - Iterate_trough_IDs_1:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${output}'
        publish:
          - list_item: '${result_string}'
        navigate:
          - HAS_MORE: http_client_delete_1
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - http_client_delete_1:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get('AnsibleTowerURL')+'/project_updates/'+list_item+'/'}"
            - auth_type: basic
            - username: "${get('AnsibleUsername')}"
            - password:
                value: "${get('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
        navigate:
          - SUCCESS: Iterate_trough_IDs_1
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_all_Jobs:
        x: 57
        'y': 74
      http_client_delete:
        x: 406
        'y': 253
      Get_array_of_IDs:
        x: 58
        'y': 243
      Iterate_trough_IDs:
        x: 226
        'y': 251
      Get_all_Project_updates:
        x: 219
        'y': 80
      Get_array_of_IDs_1:
        x: 397
        'y': 82
      Iterate_trough_IDs_1:
        x: 560
        'y': 85
        navigate:
          83c5327e-2bff-73f4-c175-3c54eeb571e2:
            targetId: 59612ceb-4164-c913-262f-fc848c366147
            port: NO_MORE
      http_client_delete_1:
        x: 570
        'y': 266
    results:
      SUCCESS:
        59612ceb-4164-c913-262f-fc848c366147:
          x: 727
          'y': 87
