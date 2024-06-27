namespace: io.cloudslang.energy_project.usage_cost
flow:
  name: create_all_cost_chart_yesterday
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - locale_lang: nl
            - locale_country: nl
            - timezone: CET
            - date_format: YYYY-MM-dd
        publish:
          - output
        navigate:
          - SUCCESS: offset_time_by
          - FAILURE: on_failure
    - offset_time_by:
        do:
          io.cloudslang.base.datetime.offset_time_by:
            - date: '${output}'
            - offset: '-86400'
        publish:
          - begin_date: '${output}'
        navigate:
          - SUCCESS: parse_date_2
          - FAILURE: on_failure
    - parse_date_2:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${begin_date}'
            - out_format: yyyy-MM-dd
        publish:
          - p1_date: '${output}'
        navigate:
          - SUCCESS: parse_date_2_1
          - FAILURE: on_failure
    - parse_date_2_1:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${begin_date}'
            - out_locale_lang: nl
            - out_locale_country: nl
        publish:
          - h_date: "${cs_replace(output, \" 0:00:00 CEST\",'' )}"
        navigate:
          - SUCCESS: get_all_usage_cost
          - FAILURE: on_failure
    - get_all_usage_cost:
        do:
          io.cloudslang.energy_project.usage_cost.get_all_usage_cost:
            - date: '${p1_date}'
        publish:
          - cost_list
          - tax_list
          - storage_list
          - gvo_list
          - fixed_list
          - net_management_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: calculate_sum_cost
    - create_all_cost_chart:
        do:
          io.cloudslang.energy_project.email_and_html_reports.create_all_cost_chart:
            - cost_list: '${cost_list}'
            - tax_list: '${tax_list}'
            - storage_list: '${storage_list}'
            - gvo_list: '${gvo_list}'
            - fixed_list: '${fixed_list}'
            - net_management_list: '${net_management_list}'
            - date: '${h_date}'
            - sum_cost: '${sum_cost}'
            - sum_tax: '${sum_tax}'
            - sum_storage: '${sum_storage}'
            - sum_gvo: '${sum_gvo}'
            - sum_net_management: '${sum_net_management}'
            - sum_fixed: '${sum_fixed}'
            - sum_total: '${total_cost}'
            - p1_date: '${p1_date}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - calculate_sum_cost:
        do:
          io.cloudslang.energy_project.tools.calculate_sum:
            - list: '${cost_list}'
        publish:
          - sum_cost
        navigate:
          - SUCCESS: calculate_sum_fixed
          - FAILURE: on_failure
    - calculate_sum_fixed:
        do:
          io.cloudslang.energy_project.tools.calculate_sum:
            - list: '${fixed_list}'
        publish:
          - sum_fixed: '${sum_cost}'
        navigate:
          - SUCCESS: calculate_sum_gvo
          - FAILURE: on_failure
    - calculate_sum_gvo:
        do:
          io.cloudslang.energy_project.tools.calculate_sum:
            - list: '${gvo_list}'
        publish:
          - sum_gvo: '${sum_cost}'
        navigate:
          - SUCCESS: calculate_sum_net_management
          - FAILURE: on_failure
    - calculate_sum_net_management:
        do:
          io.cloudslang.energy_project.tools.calculate_sum:
            - list: '${net_management_list}'
        publish:
          - sum_net_management: '${sum_cost}'
        navigate:
          - SUCCESS: calculate_sum_storage
          - FAILURE: on_failure
    - calculate_sum_storage:
        do:
          io.cloudslang.energy_project.tools.calculate_sum:
            - list: '${storage_list}'
        publish:
          - sum_storage: '${sum_cost}'
        navigate:
          - SUCCESS: calculate_sum_tax
          - FAILURE: on_failure
    - calculate_sum_tax:
        do:
          io.cloudslang.energy_project.tools.calculate_sum:
            - list: '${tax_list}'
        publish:
          - sum_tax: '${sum_cost}'
        navigate:
          - SUCCESS: calculate_sum_total
          - FAILURE: on_failure
    - calculate_sum_total:
        do:
          io.cloudslang.energy_project.tools.calculate_sum:
            - list: "${sum_cost+','+sum_tax+','+sum_net_management+','+sum_gvo+','+sum_storage+','+sum_fixed}"
        publish:
          - total_cost: '${sum_cost}'
        navigate:
          - SUCCESS: create_all_cost_chart
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      calculate_sum_fixed:
        x: 600
        'y': 560
      parse_date_2:
        x: 80
        'y': 400
      create_all_cost_chart:
        x: 600
        'y': 240
        navigate:
          f8a0315b-e086-f60a-5b0c-fe18c237b5db:
            targetId: cd5d4958-502c-5f61-5d9b-a63da0e1e39b
            port: SUCCESS
      calculate_sum_storage:
        x: 280
        'y': 400
      get_all_usage_cost:
        x: 280
        'y': 560
      calculate_sum_net_management:
        x: 440
        'y': 400
      calculate_sum_gvo:
        x: 600
        'y': 400
      get_time:
        x: 80
        'y': 80
      calculate_sum_total:
        x: 440
        'y': 240
      calculate_sum_cost:
        x: 440
        'y': 560
      offset_time_by:
        x: 80
        'y': 240
      calculate_sum_tax:
        x: 280
        'y': 240
      parse_date_2_1:
        x: 80
        'y': 560
    results:
      SUCCESS:
        cd5d4958-502c-5f61-5d9b-a63da0e1e39b:
          x: 840
          'y': 360
