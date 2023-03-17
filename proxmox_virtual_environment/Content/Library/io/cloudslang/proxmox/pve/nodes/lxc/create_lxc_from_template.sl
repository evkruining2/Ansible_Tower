########################################################################################################################
#!!
#! @description: This flow will create a new LXC container on the specified PVE node, using a selected template. To get a list of PVE nodes and a list of available templates run the "get_nodes" and "list_templates" flows respectfully.
#!
#! @input pveURL: URL of the PVE environment. Example: http://pve.example.com:8006
#! @input pveUsername: PVE username with appropriate access. Example: root@pam
#! @input pvePassword: Password for the PVE user
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input node: Name of the PVE node that will host this new container
#! @input vmid: The vmid of the new container
#! @input ostemplate: Name of the template object to use as source. Example: pve_mystorage:vztmpl/debian-10.0-standard_10.0-1_amd64.tar.gz
#! @input containerpassword: The root password for the new LXC container
#! @input storage: Target storage where the new lxc will deployed. Example: local-lvm.
#! @input hostname: The name of the new LXC container (optional)
#! @input memory: The amount of memory (in MB) to allocate to this new LXC container (optional)
#! @input nameserver: FQDN or IP address of the nameserver this LXC container will use (optional)
#! @input net0: Network setting for the first NIC. Example: name=eth0,bridge=vmbr0,ip=192.168.2.88/24,gw=192.168.2.1,firewall=0 (optional)
#! @input net1: Network setting for the second NIC. Example: name=eth1,bridge=vmbr0,ip=dhcp,tag=1,firewall=0 (optional)
#! @input net2: Network setting for the third NIC (optional)
#! @input net3: Network setting for the fourth NIC (optional)
#!
#! @output JobStatus: Status of the PBE cloning job
#! @output TaskStatus: Task status of the LXC creation ("stopped" means the task has finished)
#! @output ExitStatus: Exit status of the task ("OK" means success)
#!!#
########################################################################################################################
namespace: io.cloudslang.proxmox.pve.nodes.lxc
flow:
  name: create_lxc_from_template
  inputs:
    - pveURL
    - pveUsername
    - pvePassword:
        sensitive: true
    - TrustAllRoots: "${get_sp('io.cloudslang.proxmox.trust_all_roots')}"
    - HostnameVerify: "${get_sp('io.cloudslang.proxmox.x_509_hostname_verifier')}"
    - node
    - vmid
    - ostemplate
    - containerpassword:
        sensitive: true
    - storage
    - hostname:
        required: false
    - memory:
        required: false
    - nameserver:
        required: false
    - net0:
        required: false
    - net1:
        required: false
    - net2:
        required: false
    - net3:
        required: false
  workflow:
    - get_ticket:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.proxmox.pve.access.get_ticket:
            - pveURL: '${pveURL}'
            - pveUsername: '${pveUsername}'
            - pvePassword:
                value: '${pvePassword}'
                sensitive: true
            - TrustAllRoots: '${TrustAllRoots}'
            - HostnameVerify: '${HostnameVerify}'
        publish:
          - pveTicket
          - pveToken
        navigate:
          - FAILURE: on_failure
          - SUCCESS: url_encode_net_values
    - create_lxc_from_template:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${pveURL+'/api2/json/nodes/'+node+'/lxc'}"
            - auth_type: basic
            - username: '${pveUsername}'
            - password:
                value: '${pvePassword}'
                sensitive: true
            - trust_all_roots: '${TrustAllRoots}'
            - x_509_hostname_verifier: '${HostnameVerify}'
            - headers: "${'CSRFPreventionToken :'+pveToken+'\\r\\nCookie:PVEAuthCookie='+pveTicket}"
            - body: "${body+'&vmid='+vmid}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_status_id
          - FAILURE: on_failure
    - get_status_id:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.data
        publish:
          - JobStatus: "${return_result.strip('[').strip(']').strip('\"')}"
          - loops: '10'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - get_task_status:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        loop:
          for: i in loops
          do:
            io.cloudslang.proxmox.pve.nodes.tasks.get_task_status:
              - node: '${node}'
              - upid: '${JobStatus}'
              - pveURL: '${pveURL}'
              - pveUsername: '${pveUsername}'
              - pvePassword: '${pvePassword}'
              - TrustAllRoots: '${TrustAllRoots}'
              - HostnameVerify: '${HostnameVerify}'
          break:
            - FAILURE
          publish:
            - TaskStatus
            - ExitStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_task_finished
    - is_task_finished:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${TaskStatus}'
            - second_string: stopped
            - ignore_case: 'true'
        navigate:
          - SUCCESS: is_exitstatus_ok
          - FAILURE: sleep
    - sleep:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_status
          - FAILURE: on_failure
    - is_exitstatus_ok:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ExitStatus}'
            - second_string: ok
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - url_encode_net_values:
        worker_group:
          value: "${get_sp('io.cloudslang.proxmox.worker_group')}"
          override: true
        do:
          io.cloudslang.proxmox.pve.nodes.lxc.url_encode_net_values:
            - net0_0: '${net0}'
            - net1_1: '${net1}'
            - net2_2: '${net2}'
            - net3_3: '${net3}'
        publish:
          - net0
          - net1
          - net2
          - net3
        navigate:
          - SUCCESS: create_urlencoded_body_1
          - FAILURE: on_failure
    - create_urlencoded_body_1:
        worker_group: "${get_sp('io.cloudslang.proxmox.worker_group')}"
        do:
          io.cloudslang.proxmox.pve.tools.create_urlencoded_body_1:
            - param_ostemplate: '${ostemplate}'
            - param_password: '${containerpassword}'
            - param_memory: '${memory}'
            - param_storage: '${storage}'
            - param_hostname: '${hostname}'
            - param_nameserver: '${nameserver}'
            - param_net0: '${net0}'
            - param_net1: '${net1}'
            - param_net2: '${net2}'
            - param_net3: '${net3}'
        publish:
          - body: '${request}'
        navigate:
          - SUCCESS: create_lxc_from_template
  outputs:
    - JobStatus: '${JobStatus}'
    - TaskStatus: '${TaskStatus}'
    - ExitStatus: '${ExitStatus}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_task_status:
        x: 214
        'y': 237
      create_lxc_from_template:
        x: 40
        'y': 560
      create_urlencoded_body_1:
        x: 40
        'y': 400
      get_ticket:
        x: 40
        'y': 40
      is_exitstatus_ok:
        x: 418
        'y': 63
        navigate:
          6dad6403-8964-563b-cc2a-9b71c3f6163f:
            targetId: a5963fbc-5743-c48e-2971-f4864960f24d
            port: SUCCESS
      sleep:
        x: 424
        'y': 247
      is_task_finished:
        x: 217
        'y': 60
      url_encode_net_values:
        x: 40
        'y': 200
      get_status_id:
        x: 219
        'y': 436
    results:
      SUCCESS:
        a5963fbc-5743-c48e-2971-f4864960f24d:
          x: 618
          'y': 60
