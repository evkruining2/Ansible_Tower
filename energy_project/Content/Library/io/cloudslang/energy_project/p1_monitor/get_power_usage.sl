########################################################################################################################
#!!
#! @input host: Hostname or IP address.
#! @input username: Username to connect as.
#! @input password: Password of user.
#!                  Optional
#! @input date: Format is YYYY-MM-dd
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.p1_monitor
flow:
  name: get_power_usage
  inputs:
    - host: "${get_sp('easyenergy_project.p1_host')}"
    - username: "${get_sp('easyenergy_project.p1_user')}"
    - password:
        default: "${get_sp('easyenergy_project.p1_password')}"
        sensitive: true
    - date
  workflow:
    - sqlite_query:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: |-
                ${'''
                sqlite3 /p1mon/mnt/ramdisk/e_historie.db "SELECT VERBR_KWH_X FROM e_history_uur WHERE TIMESTAMP like '%'''+date+'''%';"'''}
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - usage_per_hour: "${cs_replace(return_result,'\\n',',').rstrip(',')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - usage_per_hour: '${usage_per_hour}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      sqlite_query:
        x: 80
        'y': 80
        navigate:
          484525b0-c2f0-89d0-710c-354b51c0361a:
            targetId: 28d1f193-fd77-b67d-c138-552f93c92142
            port: SUCCESS
    results:
      SUCCESS:
        28d1f193-fd77-b67d-c138-552f93c92142:
          x: 280
          'y': 120
