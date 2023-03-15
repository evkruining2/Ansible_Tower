########################################################################################################################
#!!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input vmid: The unique vm identifier (vmid) for the vm to modify. Example: 987
#! @input node: Name of the PVE node that hosts this vm
#! @input memory_in_mb: Memory in MB for this vm. Example: 2048
#! @input cpu_sockets: Amount of CPU Sockets this vm is allowed to allocate. Example: 2
#! @input cpu_cores: Amount of CPU Cores that this vm is allowed to allocate. Example: 4
#!
#! @output vmStatus: Current status of the vm
#! @output cpus: Total amount of vCPUs
#! @output memory: Amount of memory in MB
#! @output disk_size: Total amount of disk space
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pvesh.qemu
flow:
  name: resize_vm
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - vmid
    - node
    - memory_in_mb
    - cpu_sockets
    - cpu_cores
  workflow:
    - strip_pveurl:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.strings.trim:
            - origin_string: '${pveURL}'
        publish:
          - pve_server: '${new_string.replace("https://","").replace(":8006","")}'
        navigate:
          - SUCCESS: strip_pveUsername
    - ssh_command:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${pve_server}'
            - command: "${'pvesh set /nodes/'+node+'/qemu/'+vmid+'/config -cores '+cpu_cores+' -memory '+memory_in_mb+' -sockets '+cpu_sockets}"
            - username: '${pve_user}'
            - password:
                value: '${pvePassword}'
                sensitive: true
        navigate:
          - SUCCESS: reboot_vm
          - FAILURE: on_failure
    - strip_pveUsername:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.strings.trim:
            - origin_string: '${pveUsername}'
        publish:
          - pve_user: '${new_string.replace("@pam","")}'
        navigate:
          - SUCCESS: ssh_command
    - reboot_vm:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${pve_server}'
            - command: "${'qm reboot '+vmid}"
            - username: '${pve_user}'
            - password:
                value: '${pvePassword}'
                sensitive: true
        navigate:
          - SUCCESS: current_vm_status
          - FAILURE: on_failure
    - current_vm_status:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.proxmox.pve.nodes.qemu.current_vm_status:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: "${get_sp('io.cloudslang.proxmox.trust_all_roots')}"
            - HostnameVerify: "${get_sp('io.cloudslang.proxmox.x_509_hostname_verifier')}"
            - node: '${node}'
            - vmid: '${vmid}'
        publish:
          - vmStatus
          - cpus
          - memory
          - disk_size
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - vmStatus: '${vmStatus}'
    - cpus: '${cpus}'
    - memory: '${memory}'
    - disk_size: '${disk_size}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      strip_pveurl:
        x: 80
        'y': 80
      ssh_command:
        x: 280
        'y': 80
      strip_pveUsername:
        x: 160
        'y': 280
      reboot_vm:
        x: 440
        'y': 80
      current_vm_status:
        x: 560
        'y': 240
        navigate:
          4e74e798-63a5-8fc4-9ff9-de3f0111d986:
            targetId: 65a82c1f-dcbb-4d54-29ed-30ab92567ec7
            port: SUCCESS
    results:
      SUCCESS:
        65a82c1f-dcbb-4d54-29ed-30ab92567ec7:
          x: 520
          'y': 400
