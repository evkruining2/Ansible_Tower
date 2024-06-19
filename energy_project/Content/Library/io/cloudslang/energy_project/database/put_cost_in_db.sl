########################################################################################################################
#!!
#! @input date: Format is YYYY-MM-dd
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.database
flow:
  name: put_cost_in_db
  inputs:
    - date
  workflow:
    - get_tariff_for_given_date:
        do:
          io.cloudslang.energy_project.easyenergy.get_tariff_for_given_date:
            - date: '${date}'
        publish:
          - tariff_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_power_usage
    - get_power_usage:
        do:
          io.cloudslang.energy_project.p1_monitor.get_power_usage:
            - date: '${date}'
            - cost_list: €
        publish:
          - usage_per_hour
          - cost_list
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - get_usage_by_index:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${usage_per_hour}'
            - delimiter: ','
            - index: '${index}'
        publish:
          - usage: '${return_result}'
        navigate:
          - SUCCESS: calculate_cost
          - FAILURE: on_failure
    - counter:
        do:
          io.cloudslang.base.utils.counter:
            - from: '0'
            - to: '23'
            - increment_by: '1'
            - reset: null
        publish:
          - index: '${return_result}'
        navigate:
          - HAS_MORE: get_tarif_by_index
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_tarif_by_index:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${tariff_list}'
            - delimiter: ','
            - index: '${index}'
        publish:
          - rate: '${return_result}'
        navigate:
          - SUCCESS: get_usage_by_index
          - FAILURE: on_failure
    - calculate_cost:
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${rate}'
            - value2: '${usage}'
        publish:
          - cost: '${result}'
        navigate:
          - SUCCESS: round_to_4_decimals
    - round_to_4_decimals:
        do:
          io.cloudslang.energy_project.tools.round_to_4_decimals:
            - input: '${cost}'
        publish:
          - cost: '${output}'
        navigate:
          - SUCCESS: sql_command
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: 192.168.2.129
            - db_type: PostgreSQL
            - username: postgres
            - password:
                value: admin
                sensitive: true
            - db_port: '5432'
            - database_name: power
            - command: "${'''\nINSERT INTO public.\"table\" (\"timestamp\",\"usage\",\"rate\",\"cost\")\n    VALUES (\\''''+date+''' '''+index+''':00:00\\',\\''''+usage+'''\\',\\''''+rate+'''\\',\\''''+cost+'''\\')\n'''}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_tariff_for_given_date:
        x: 40
        'y': 80
      get_power_usage:
        x: 200
        'y': 80
      get_usage_by_index:
        x: 200
        'y': 520
      counter:
        x: 360
        'y': 80
        navigate:
          9aecff35-4c43-2df6-6228-ba9e795b3e6e:
            targetId: 35256254-2752-cd54-cbb8-6040ea4d2199
            port: NO_MORE
      get_tarif_by_index:
        x: 200
        'y': 320
      calculate_cost:
        x: 360
        'y': 520
      round_to_4_decimals:
        x: 520
        'y': 520
      sql_command:
        x: 520
        'y': 320
    results:
      SUCCESS:
        35256254-2752-cd54-cbb8-6040ea4d2199:
          x: 680
          'y': 80
