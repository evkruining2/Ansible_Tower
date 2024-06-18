########################################################################################################################
#!!
#! @input date: Format is YYYY-MM-dd
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.usage_cost
flow:
  name: get_usage_cost
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
          - NO_MORE: export_cost_list
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
          - output
        navigate:
          - SUCCESS: add_cost_to_list
    - add_cost_to_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${cost_list}'
            - element: '${output}'
            - delimiter: ','
        publish:
          - cost_list: "${cs_replace(return_result,'€,','')}"
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - export_cost_list:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: '${cost_list}'
        publish:
          - cost_list: '${input_0}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - cost_list: '${cost_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      round_to_4_decimals:
        x: 520
        'y': 520
      export_cost_list:
        x: 520
        'y': 80
        navigate:
          71d000fc-1c0e-d342-5028-eea5828ef354:
            targetId: 35256254-2752-cd54-cbb8-6040ea4d2199
            port: SUCCESS
      calculate_cost:
        x: 360
        'y': 520
      add_cost_to_list:
        x: 520
        'y': 320
      get_tarif_by_index:
        x: 200
        'y': 320
      get_usage_by_index:
        x: 200
        'y': 520
      get_tariff_for_given_date:
        x: 40
        'y': 80
      counter:
        x: 360
        'y': 80
      get_power_usage:
        x: 200
        'y': 80
    results:
      SUCCESS:
        35256254-2752-cd54-cbb8-6040ea4d2199:
          x: 680
          'y': 80
