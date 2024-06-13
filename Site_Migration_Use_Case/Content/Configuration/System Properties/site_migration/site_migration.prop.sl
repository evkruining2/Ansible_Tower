namespace: site_migration
properties:
  - pveUrl: 'https://pve.museumhof.net:8006'
  - pveUsername: root@pam
  - pvePassword:
      value: opsware
      sensitive: true
  - AnsibleTowerUrl: 'http://192.168.2.199:32330/api/v2'
  - AnsibleUsername: admin
  - AnsiblePassword:
      value: admin
      sensitive: true
  - TrustAllRoots: 'true'
  - HostnameVerify: allow_all
  - m2Password:
      value: '0p5w4r3123!'
      sensitive: true
  - fw_hostname: 192.168.2.175
  - fw_username: admin
  - fw_password:
      value: opsware
      sensitive: true
  - aws_key_id: AKIARHRVZWALMN5CVBVX
  - aws_key:
      value: WHJLypuLMSLG2YJ5vpG+wxDZwn52/cd+ta81DXSH
      sensitive: true
