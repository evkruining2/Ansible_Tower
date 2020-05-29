########################################################################################################################
#!!
#! @input ProjectID: The id (integer) of the Project to delete
#!!#
########################################################################################################################
namespace: Ansible_Tower.Projects
flow:
  name: Delete_Project
  inputs:
    - ProjectID
  workflow:
    - Delete_Project:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get_sp('AnsibleTowerURL')+'/projects/'+ProjectID+'/'}"
            - auth_type: basic
            - username: "${get_sp('AnsibleUsername')}"
            - password:
                value: "${get_sp('AnsiblePassword')}"
                sensitive: true
            - trust_all_roots: "${get_sp('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get_sp('HostNameVerify')}"
            - headers: 'Content-Type:application/json'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Delete_Project:
        x: 85
        'y': 79
        navigate:
          74804904-02f4-ef09-6abe-63c4c06d0e39:
            targetId: 981d4b12-5e7d-e856-ca53-3eb4619daa0e
            port: SUCCESS
    results:
      SUCCESS:
        981d4b12-5e7d-e856-ca53-3eb4619daa0e:
          x: 339
          'y': 77
