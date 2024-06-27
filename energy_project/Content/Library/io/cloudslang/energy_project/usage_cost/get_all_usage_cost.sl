########################################################################################################################
#!!
#! @input date: Format is YYYY-MM-dd
#! @input energy_tax: Compensatie energiebelasting is verrekend (normaal 0.1327 per Kwh)
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.usage_cost
flow:
  name: get_all_usage_cost
  inputs:
    - date
    - fixed_cost_provider: '0.00683'
    - storage: '0.02177'
    - gvo_wind: '0.00508'
    - energy_tax: '0.001'
    - net_management: '0.05'
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
            - tax_list: €
            - storage_list: €
            - gvo_list: €
            - fixed_list: €
            - net_management_list: €
        publish:
          - usage_per_hour
          - cost_list
          - tax_list
          - storage_list
          - gvo_list
          - fixed_list
          - net_management_list
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
          - SUCCESS: calculate_tax
          - FAILURE: on_failure
    - export_cost_list:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: '${cost_list}'
            - input_1: '${tax_list}'
            - input_2: '${storage_list}'
            - input_3: '${gvo_list}'
            - input_4: '${fixed_list}'
            - input_5: '${net_management_list}'
        publish:
          - cost_list: '${input_0}'
          - tax_list: '${input_1}'
          - storage_list: '${input_2}'
          - gvo_list: '${input_3}'
          - fixed_list: '${input_4}'
          - net_management_list: '${input_5}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - calculate_tax:
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${energy_tax}'
            - value2: '${usage}'
        publish:
          - tax: '${result}'
        navigate:
          - SUCCESS: round_to_4_decimals_1
    - add_tax_to_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${tax_list}'
            - element: '${output}'
            - delimiter: ','
        publish:
          - tax_list: "${cs_replace(return_result,'€,','')}"
        navigate:
          - SUCCESS: calculate_storage
          - FAILURE: on_failure
    - round_to_4_decimals_1:
        do:
          io.cloudslang.energy_project.tools.round_to_4_decimals:
            - input: '${tax}'
        publish:
          - output
        navigate:
          - SUCCESS: add_tax_to_list
    - calculate_storage:
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${storage}'
            - value2: '${usage}'
        publish:
          - storage_1: '${result}'
        navigate:
          - SUCCESS: round_to_4_decimals_1_1
    - round_to_4_decimals_1_1:
        do:
          io.cloudslang.energy_project.tools.round_to_4_decimals:
            - input: '${storage_1}'
        publish:
          - output
        navigate:
          - SUCCESS: add_storage_to_list
    - add_storage_to_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${storage_list}'
            - element: '${output}'
            - delimiter: ','
        publish:
          - storage_list: "${cs_replace(return_result,'€,','')}"
        navigate:
          - SUCCESS: calculate_gvo
          - FAILURE: on_failure
    - calculate_gvo:
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${gvo_wind}'
            - value2: '${usage}'
        publish:
          - gvo: '${result}'
        navigate:
          - SUCCESS: round_to_4_decimals_1_2
    - round_to_4_decimals_1_2:
        do:
          io.cloudslang.energy_project.tools.round_to_4_decimals:
            - input: '${gvo}'
        publish:
          - output
        navigate:
          - SUCCESS: add_gvo_to_list
    - add_gvo_to_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${gvo_list}'
            - element: '${output}'
            - delimiter: ','
        publish:
          - gvo_list: "${cs_replace(return_result,'€,','')}"
        navigate:
          - SUCCESS: add_fixed_cost_to_list
          - FAILURE: on_failure
    - add_fixed_cost_to_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${fixed_list}'
            - element: '${fixed_cost_provider}'
            - delimiter: ','
        publish:
          - fixed_list: "${cs_replace(return_result,'€,','')}"
        navigate:
          - SUCCESS: add_net_management_to_list
          - FAILURE: on_failure
    - add_net_management_to_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${net_management_list}'
            - element: '${net_management}'
            - delimiter: ','
        publish:
          - net_management_list: "${cs_replace(return_result,'€,','')}"
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
  outputs:
    - cost_list: '${cost_list}'
    - tax_list: '${tax_list}'
    - storage_list: '${storage_list}'
    - gvo_list: '${gvo_list}'
    - fixed_list: '${fixed_list}'
    - net_management_list: '${net_management_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      round_to_4_decimals:
        x: 200
        'y': 640
      add_storage_to_list:
        x: 520
        'y': 480
      calculate_storage:
        x: 360
        'y': 640
      round_to_4_decimals_1_1:
        x: 520
        'y': 640
      round_to_4_decimals_1_2:
        x: 680
        'y': 280
      add_gvo_to_list:
        x: 680
        'y': 480
      export_cost_list:
        x: 520
        'y': 80
        navigate:
          71d000fc-1c0e-d342-5028-eea5828ef354:
            targetId: 35256254-2752-cd54-cbb8-6040ea4d2199
            port: SUCCESS
      calculate_cost:
        x: 40
        'y': 640
      add_net_management_to_list:
        x: 840
        'y': 280
      calculate_gvo:
        x: 520
        'y': 280
      add_cost_to_list:
        x: 200
        'y': 480
      add_tax_to_list:
        x: 360
        'y': 480
      get_tarif_by_index:
        x: 40
        'y': 280
      get_usage_by_index:
        x: 40
        'y': 480
      round_to_4_decimals_1:
        x: 360
        'y': 280
      calculate_tax:
        x: 200
        'y': 280
      get_tariff_for_given_date:
        x: 40
        'y': 80
      add_fixed_cost_to_list:
        x: 840
        'y': 480
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
