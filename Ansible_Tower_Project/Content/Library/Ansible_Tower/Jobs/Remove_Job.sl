namespace: Ansible_Tower.Jobs
flow:
  name: Remove_Job
  inputs:
    - JobID
  workflow:
    - http_client_delete:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get_sp('AnsibleTowerURL')+'/jobs/'+JobID+'/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_delete:
        x: 148
        'y': 150
        navigate:
          6e46e9d9-9477-15a1-8868-d738d214edfb:
            targetId: f0c9c7ae-abde-909c-a748-c6be20c3d84b
            port: SUCCESS
    results:
      SUCCESS:
        f0c9c7ae-abde-909c-a748-c6be20c3d84b:
          x: 353
          'y': 147
