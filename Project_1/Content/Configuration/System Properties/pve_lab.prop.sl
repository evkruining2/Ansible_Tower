namespace: ''
properties:
  - pveURL: 'https://pve:8006'
  - pveUsername: root@pam
  - pvePassword:
      value: opsware
      sensitive: true
  - TrustAllRoots: 'true'
  - HostnameVerify: allow_all
