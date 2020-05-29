########################################################################################################################
#!!
#! @description: This flow will delete a Host object in your Ansible Tower system
#!               
#!               Inputs:
#!               
#!               HostID		- The id (integrer) of the Ansible Tower Host component that you want to delete (example: "15"). 
#!               
#!               Output:
#!               
#!               No outputs are generated. 
#!
#! @input HostID: The id (integrer) of the Ansible Tower Host component that you want to delete (example: "15"). 
#!!#
########################################################################################################################
namespace: Ansible_Tower.Hosts
flow:
  name: Delete_Host
  inputs:
    - HostID
  workflow:
    - Delete_Host:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get_sp('AnsibleTowerURL')+'/hosts/'+HostID+'/'}"
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
      Delete_Host:
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
