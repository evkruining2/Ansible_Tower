########################################################################################################################
#!!
#! @system_property AnsibleTowerURL: Ansible Tover API URL
#! @system_property AnsibleUsername: Ansible Tower administrator user name
#! @system_property AnsiblePassword: Ansible Tower administrator password
#! @system_property TrustAllRoots: Trust target certificate
#! @system_property HostNameVerify: Verify target hostnames
#!!#
########################################################################################################################
namespace: ''
properties:
  - AnsibleTowerURL:
      value: 'https://192.168.2.99/api/v2'
      sensitive: false
  - AnsibleUsername:
      value: admin
      sensitive: false
  - AnsiblePassword:
      value: Cloud@123
      sensitive: true
  - TrustAllRoots:
      value: 'true'
      sensitive: false
  - HostNameVerify:
      value: allow_all
      sensitive: false
