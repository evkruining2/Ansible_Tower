########################################################################################################################
#!!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input node: Name of the PVE node that hosts this container
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.tools
flow:
  name: roll_back_changes_pve
  inputs:
    - AnsibleTowerURL: "${get_sp('site_migration.AnsibleTowerUrl')}"
    - AnsibleUsername: "${get_sp('site_migration.AnsibleUsername')}"
    - AnsiblePassword:
        default: "${get_sp('site_migration.AnsiblePassword')}"
        sensitive: true
    - TrustAllRoots: "${get_sp('site_migration.TrustAllRoots')}"
    - HostnameVerify: "${get_sp('site_migration.HostnameVerify')}"
    - pveURL: "${get_sp('site_migration.pveUrl')}"
    - pveUsername: "${get_sp('site_migration.pveUsername')}"
    - pvePassword:
        default: "${get_sp('site_migration.pvePassword')}"
        sensitive: true
    - node: pve
  workflow:
    - read_stored_values:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: /var/tmp/site.csv
        publish:
          - read_text
        navigate:
          - SUCCESS: set_flow_variables
          - FAILURE: on_failure
    - set_flow_variables:
        do:
          io.cloudslang.site_migration_use_case.tools.set_flow_variables:
            - line: '${read_text}'
        publish:
          - hostid: '${a}'
          - vmid: '${b}'
          - ip_address: '${c}'
          - old_website: '${d}'
        navigate:
          - SUCCESS: modify_fw_rule
    - modify_fw_rule:
        do:
          io.cloudslang.site_migration_use_case.firewall.modify_fw_rule:
            - ip_address: '${old_website}'
            - rule_number: '999'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_host_from_awx
    - delete_rollback_data_file:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: /var/tmp/site.csv
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - delete_host_from_awx:
        do:
          io.cloudslang.redhat.ansible_tower.hosts.delete_host:
            - AnsibleTowerURL: '${AnsibleTowerURL}'
            - AnsibleUsername: '${AnsibleUsername}'
            - AnsiblePassword:
                value: '${AnsiblePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - HostID: '${hostid}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: shutdown_lxc
    - shutdown_lxc:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.shutdown_lxc:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - node: '${node}'
            - vmid: '${vmid}'
        navigate:
          - SUCCESS: delete_lxc
          - FAILURE: on_failure
    - delete_lxc:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.delete_lxc:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - node: '${node}'
            - vmid: '${vmid}'
        navigate:
          - SUCCESS: delete_rollback_data_file
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      modify_fw_rule:
        x: 40
        'y': 520
      set_flow_variables:
        x: 40
        'y': 320
      read_stored_values:
        x: 40
        'y': 120
      delete_rollback_data_file:
        x: 440
        'y': 120
        navigate:
          5d4d278f-0dc8-6c7c-3438-1fe993e71e1d:
            targetId: e7592fcf-6bcd-409c-1fe8-812b2a132e61
            port: SUCCESS
      delete_host_from_awx:
        x: 240
        'y': 520
      shutdown_lxc:
        x: 240
        'y': 320
      delete_lxc:
        x: 240
        'y': 120
    results:
      SUCCESS:
        e7592fcf-6bcd-409c-1fe8-812b2a132e61:
          x: 440
          'y': 320
