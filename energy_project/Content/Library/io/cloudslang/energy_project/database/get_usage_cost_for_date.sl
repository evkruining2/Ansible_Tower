########################################################################################################################
#!!
#! @input date: Dateformat is YYYY-MM-dd or YYYY-MM or YYYY or HH: or YYYY-%HH:
#! @input db_server_name: The hostname or ip address of the database server.
#! @input username: The username to use when connecting to the database.
#! @input password: The password to use when connecting to the database.
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.database
flow:
  name: get_usage_cost_for_date
  inputs:
    - date
    - db_server_name: "${get_sp('easyenergy_project.postgresql_server')}"
    - username: "${get_sp('easyenergy_project.postgresql_user')}"
    - password:
        default: "${get_sp('easyenergy_project.postgresql_password')}"
        sensitive: true
  workflow:
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${db_server_name}'
            - db_type: PostgreSQL
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - db_port: '5432'
            - database_name: power
            - command: "${'''\nSELECT (timestamp::text like \\'%'''+date+'''%') \"range\", round(sum(cast(\"cost\" as float8))::numeric,2) \"usage_cost per period\"\nFROM \"table\" t\ngroup by 1\nORDER BY 1\n;\n'''}"
            - trust_all_roots: 'true'
        publish:
          - output_text
        navigate:
          - SUCCESS: get_values_v2
          - FAILURE: on_failure
    - get_values_v2:
        do:
          io.cloudslang.base.maps.get_values_v2:
            - map: '${output_text}'
            - key: t
            - pair_delimiter: ','
            - entry_delimiter: |-
                ${'''
                '''}
            - strip_whitespaces: 'true'
            - d: '${date}'
        publish:
          - energy_cost: "${'The costs of enery for '+d+' was €'+return_result}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - energy_cost: '${energy_cost}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      sql_command:
        x: 240
        'y': 120
      get_values_v2:
        x: 360
        'y': 320
        navigate:
          639abe31-d688-4115-be58-a57e4abf3e41:
            targetId: 2decee0c-c7b8-8de2-4aca-16638767b240
            port: SUCCESS
    results:
      SUCCESS:
        2decee0c-c7b8-8de2-4aca-16638767b240:
          x: 560
          'y': 200
