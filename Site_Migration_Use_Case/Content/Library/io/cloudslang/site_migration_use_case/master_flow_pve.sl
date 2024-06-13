########################################################################################################################
#!!
#! @input vmid: The vmid of the new container
#! @input hostname: The name of the new LXC container (optional)
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: Name of the PVE node that will host this new container
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case
flow:
  name: master_flow_pve
  inputs:
    - vmid
    - ip_address
    - hostname
    - pveURL: "${get_sp('site_migration.pveUrl')}"
    - pveUsername: "${get_sp('site_migration.pveUsername')}"
    - pvePassword:
        default: "${get_sp('site_migration.pvePassword')}"
        sensitive: true
    - TrustAllRoots: "${get_sp('site_migration.TrustAllRoots')}"
    - HostnameVerify: "${get_sp('site_migration.HostnameVerify')}"
    - node: pve
    - fw_hostname: "${get_sp('site_migration.fw_hostname')}"
    - fw_username: "${get_sp('site_migration.fw_username')}"
    - fw_password:
        default: "${get_sp('site_migration.fw_password')}"
        sensitive: true
  workflow:
    - pve_create_and_start_new_target_vm:
        do:
          io.cloudslang.site_migration_use_case.pve.create_ctx:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - node: '${node}'
            - vmid: '${vmid}'
            - ip_address: '${ip_address}'
            - hostname: '${hostname}'
        publish:
          - lxc_status
          - ip_address
          - vmid
        navigate:
          - SUCCESS: allow_ssh_root_login
          - FAILURE: on_failure
    - allow_ssh_root_login:
        do:
          io.cloudslang.site_migration_use_case.ssh.allow_ssh_root_login:
            - username: root
            - password:
                value: '${pvePassword}'
                sensitive: true
            - target: '${ip_address}'
        navigate:
          - SUCCESS: ansible_update_os_on_target_server_install_apache_db_php
          - FAILURE: on_failure
    - ansible_update_os_on_target_server_install_apache_db_php:
        do:
          io.cloudslang.site_migration_use_case.ansible.update_os_on_target_server:
            - AnsibleTowerURL: "${get_sp('site_migration.AnsibleTowerUrl')}"
            - AnsibleUsername: "${get_sp('site_migration.AnsibleUsername')}"
            - AnsiblePassword:
                value: "${get_sp('site_migration.AnsiblePassword')}"
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - HostName: '${ip_address}'
        publish:
          - HostID
        navigate:
          - FAILURE: on_failure
          - SUCCESS: scp_payload
    - scp_payload:
        do:
          io.cloudslang.site_migration_use_case.ssh.scp_payload:
            - target: '${ip_address}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: db_populate_sql_db
    - db_populate_sql_db:
        do:
          io.cloudslang.site_migration_use_case.ssh.populate_sql_db:
            - target: '${ip_address}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: modify_fw_rule
    - modify_fw_rule:
        do:
          io.cloudslang.site_migration_use_case.firewall.modify_fw_rule:
            - firewall: '${fw_hostname}'
            - username: '${fw_username}'
            - password:
                value: '${fw_password}'
                sensitive: true
            - ip_address: '${ip_address}'
            - rule_number: '999'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_values_to_file
    - write_values_to_file:
        do:
          io.cloudslang.site_migration_use_case.tools.write_values_to_file:
            - hostid: '${HostID}'
            - vmid: '${vmid}'
            - ip_address: '${ip_address}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      pve_create_and_start_new_target_vm:
        x: 40
        'y': 80
      allow_ssh_root_login:
        x: 160
        'y': 400
      ansible_update_os_on_target_server_install_apache_db_php:
        x: 280
        'y': 80
      scp_payload:
        x: 400
        'y': 400
      db_populate_sql_db:
        x: 520
        'y': 80
      modify_fw_rule:
        x: 640
        'y': 400
      write_values_to_file:
        x: 760
        'y': 80
        navigate:
          68c1aa10-c804-232e-b326-cbf3fccb3faa:
            targetId: 2ece7d65-24f3-d98e-9743-fb9e2e3f43e7
            port: SUCCESS
    results:
      SUCCESS:
        2ece7d65-24f3-d98e-9743-fb9e2e3f43e7:
          x: 880
          'y': 400
