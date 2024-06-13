########################################################################################################################
#!!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: Name of the PVE node that will host this new container
#! @input vmid: The vmid of the new container
#! @input hostname: The name of the new LXC container (optional)
#! @input ssh_public_keys: Setup public SSH keys (one key per line, OpenSSH format) - Input must be URL Encoded
#! @input features: Allow containers access to advanced features. - Input must be URL encoded
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.pve
flow:
  name: create_ctx
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots
    - HostnameVerify
    - node: pve
    - vmid
    - ip_address
    - hostname:
        required: false
    - ssh_public_keys:
        default: 'ssh-rsa%20AAAAB3NzaC1yc2EAAAABIwAAAQEA8uX6GvqQx0SxHwtC5O3vF0Uk95VtNKbelBZW6yqPegeAGb3qfJ0UPf5Z1i%2BDayiQ5%2B2JMxWOq8HTGicaBxPw3k2JW1CcQVkenPlq0iMTezrd%2Bli3mo4D%2BetRTsaRooTwgH6Lr09HYYyhWi657gBGd6lCWhIYGFVDsI6ptKRnHD%2FJQbHJybnejaPLj5L%2Fmpk%2BUY0w2lC62x6WDIF%2F5Lxi%2FIZKJn%2FdIwvMbtNHhg1WtJrZ6Uf1JwsY1KE6VtktFMDw%2BI57yWqpCTdcTOHNWHJ2%2FqDYTMZ1f5Cg07gcQEHjqyuZpVntwcn8EH2qqMNI85cw6ZINNDv968tLKmki%2FX%2BlaQ%3D%3D%20megamo%40g5.museumhof.net%0Assh-rsa%20AAAAB3NzaC1yc2EAAAADAQABAAABgQDY9Pi3baHq%2BCO%2B3jznEnz4D53%2FERbvaQTAEadfTkUrkPfHpmbPJCARTc7B5xxNze7MGJh0xs7dlMbO9C%2BfuOa3Nn9r0EaeVApQrhY0Gf07RZlAuT37I3qVY1oQjwIpRKbvow%2BxDgcQrCGVEvf5oDwJCDaFC4b9Sj7R%2F3WM94kWE3xdvJz9ZO%2FQUnc5FGu%2BY5bseWBBXq5sUsHsaopQp64Z%2FjxDAHYPogMPuZF6BjW4FYDIW9EnjK1xD9iAGGMZqHi8%2BPP218sE04LsiI9R8AxCSm%2BCBoiZpx5QalU1%2FBV0zH6rMlkAMrJET%2Bjh8u4Ue1KzMwhziWNC%2Fb8yED%2FVyObLbgQrpOXNFKCyLY77BjezQ7fy4x%2BSpJvNC0o%2B8s9BC6vS0y%2BhkVEwx7THbelxesAoUlT05WOUI8jGo0PpMYoVoHinE7ih%2BpDq9g8uGx4nnZ7M0bSoDhUw0U10FZd1hYalkIejXnxd5ZkrIYms0e78Gwrvz90TyCoZN%2FjQ86kN7M8%3D%20root%40oo3.museumhof.net%0Assh-rsa%20AAAAB3NzaC1yc2EAAAADAQABAAABgQCt1redeisilktf%2FamsSZQyh31xgPO8jyBTGFFSpCuAsR%2BCpQSGOeXJJL7DAAs9TebvC%2B4JIAfSdmUUYqbuDST4bX3J7FXSDv57%2FrVJ1uAlfrajhD2oVgnAxNzuGzzRyt7qe9M7%2F5bb4%2BNkAM3nyIihHFHsAVT8KWGCfD2K9Gy%2BYAGtaOAG7M1n%2FcgC7rPo4q7vyowBtr0PKDRNFRyjTd2EpuCwKN%2FKZB7SGi8uLXccOl9negJgYVbgwKrrBjXJISgli3pFouWi2wbeXXjsrHK5BQ4fTXWiOLUuSbX2d%2Bw%2FSCCB1LmeJ6OUlvd8RdGl%2FQy2MRLM8ZfrxOYd4fKBQiWHjofE611DiCV95YqAX9pGRP%2Buxm8fWkn%2FFZmKUQDn05stgwSJDzZINGckqsEwURayir4%2F2WN%2BXdPsddXVUNAf3N1OoS80ZuhX2ut41YKp5B7T0PPXdG%2BWdCtyUdL2TVoZwdmNpFZ%2Bs%2FUcPtkvO%2BbZa6oCvQUP3S%2Bm2%2FOzKkKPU9U%3D%20root%40awx-sheetal'
        required: false
    - features:
        default: 'nesting%3D1'
        required: false
  workflow:
    - create_lxc_from_template:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.create_lxc_from_template:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - node: '${node}'
            - vmid: '${vmid}'
            - ostemplate: 'pve_backup:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst'
            - containerpassword:
                value: '${pvePassword}'
                sensitive: true
            - storage: local-lvm
            - hostname: '${hostname}'
            - memory: '1024'
            - nameserver: 192.168.2.20
            - net0: "${'name=eth0,bridge=vmbr0,ip='+ip_address+'/24,gw=192.168.2.1,firewall=0'}"
            - ssh_public_keys: '${ssh_public_keys}'
            - features: '${features}'
        publish:
          - JobStatus
          - vmid
        navigate:
          - SUCCESS: start_lxc
          - FAILURE: on_failure
    - start_lxc:
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.start_lxc:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
            - node: '${node}'
            - vmid: '${vmid}'
        publish:
          - lxc_status
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - lxc_status: '${lxc_status}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_lxc_from_template:
        x: 120
        'y': 120
      start_lxc:
        x: 120
        'y': 360
        navigate:
          9c0bd232-9caa-274d-aa0d-83893115b4c6:
            targetId: 2ece7d65-24f3-d98e-9743-fb9e2e3f43e7
            port: SUCCESS
    results:
      SUCCESS:
        2ece7d65-24f3-d98e-9743-fb9e2e3f43e7:
          x: 480
          'y': 240
