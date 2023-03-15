########################################################################################################################
#!!
#! @description: Check the current status of a VM (running, stopped, paused, suspended)
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: The name of the PVE node that is hosting the VM. Example: pve_node2
#! @input vmid: The ID of the VM to run this operation against. Example: 102
#!
#! @output vmStatus: The current status of a VM (running, stopped, paused, suspended)
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.qemu
flow:
  name: current_vm_status
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.proxmox.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.proxmox.x_509_hostname_verifier')}"
    - node
    - vmid
  workflow:
    - get_ticket:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.proxmox.pve.access.get_ticket:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword: '${pvePassword}'
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pveTicket
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_version
    - get_version:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get('pveURL')+'/api2/json/nodes/'+node+'/qemu/'+vmid+'/status/current'}"
            - auth_type: basic
            - username: "${get('pveUsername')}"
            - password:
                value: "${get('pvePassword')}"
                sensitive: true
            - trust_all_roots: "${get('TrustAllRoots')}"
            - x_509_hostname_verifier: "${get('HostnameVerify')}"
            - headers: "${'Cookie:PVEAuthCookie='+pveTicket}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_vm_status
          - FAILURE: on_failure
    - get_vm_status:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.status
        publish:
          - vmStatus: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_cpus
          - FAILURE: on_failure
    - get_cpus:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.cpus
        publish:
          - cpus: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: get_memory
          - FAILURE: on_failure
    - get_memory:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data.maxmem
        publish:
          - memory_in_bytes: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: mem_in_mb
          - FAILURE: on_failure
    - get_disk_size:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: '@.data.maxdisk'
        publish:
          - disk_size_in_bytes: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: disk_in_gb
          - FAILURE: on_failure
    - mem_in_mb:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.math.divide_numbers:
            - value1: '${memory_in_bytes}'
            - value2: '1048576'
        publish:
          - memory: '${result}'
        navigate:
          - ILLEGAL: get_disk_size
          - SUCCESS: get_disk_size
    - disk_in_gb:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.math.divide_numbers:
            - value1: '${disk_size_in_bytes}'
            - value2: '1073741824'
        publish:
          - disk_size: '${result}'
        navigate:
          - ILLEGAL: SUCCESS
          - SUCCESS: SUCCESS
  outputs:
    - vmStatus: '${vmStatus}'
    - cpus: '${cpus}'
    - memory: '${memory}'
    - disk_size: '${disk_size}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ticket:
        x: 45
        'y': 87
      get_version:
        x: 231
        'y': 82
      get_disk_size:
        x: 80
        'y': 480
      get_memory:
        x: 240
        'y': 280
      get_cpus:
        x: 440
        'y': 280
      get_vm_status:
        x: 426
        'y': 81
      mem_in_mb:
        x: 80
        'y': 280
      disk_in_gb:
        x: 320
        'y': 440
        navigate:
          43f777d2-811b-4573-a2a1-2bba7187ae3b:
            targetId: 62d58777-7508-fc70-1b42-21d01def9eff
            port: SUCCESS
          f7bdde7b-c544-9a3a-6b0a-810fc0b77b9e:
            targetId: 62d58777-7508-fc70-1b42-21d01def9eff
            port: ILLEGAL
    results:
      SUCCESS:
        62d58777-7508-fc70-1b42-21d01def9eff:
          x: 520
          'y': 520
