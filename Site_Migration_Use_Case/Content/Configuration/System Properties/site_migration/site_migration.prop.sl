namespace: site_migration
properties:
  - pveUrl: 'https://pve.museumhof.net:8006'
  - pveUsername: root@pam
  - pvePassword:
      value: ''
      sensitive: true
  - AnsibleTowerUrl: 'http://192.168.2.199:32330/api/v2'
  - AnsibleUsername: admin
  - AnsiblePassword:
      value: ''
      sensitive: true
  - TrustAllRoots: 'true'
  - HostnameVerify: allow_all
  - m2Password:
      value: ''
      sensitive: true
  - fw_hostname: 192.168.2.175
  - fw_username: admin
  - fw_password:
      value: ''
      sensitive: true
  - aws_key_id: empty due to git security scanning
  - aws_key:
      value: empty due to git security scanning
      sensitive: false
