namespace: io.cloudslang.energy_project.usage_cost
flow:
  name: report_usage_cost_for_yesterday
  workflow:
    - get_tariff_for_yesterday:
        do:
          io.cloudslang.energy_project.easyenergy.get_tariff_for_yesterday: []
        publish:
          - tariff_list
          - p1_date
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_usage_cost
    - get_usage_cost:
        do:
          io.cloudslang.energy_project.usage_cost.get_usage_cost:
            - date: '${p1_date}'
        publish:
          - cost_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: human_readable_date
    - human_readable_date:
        do:
          io.cloudslang.energy_project.date_time.human_readable_date:
            - offset: '-86400'
        publish:
          - date
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_cost_chart
    - create_cost_chart:
        do:
          io.cloudslang.energy_project.email_and_html_reports.create_cost_chart:
            - cost_list: '${cost_list}'
            - date: '${date}'
        navigate:
          - SUCCESS: email_cost_information
          - FAILURE: on_failure
    - email_cost_information:
        do:
          io.cloudslang.energy_project.email_and_html_reports.email_cost_information:
            - cost_list: '${cost_list}'
            - date: '${date}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_tariff_for_yesterday:
        x: 80
        'y': 80
      get_usage_cost:
        x: 200
        'y': 280
      human_readable_date:
        x: 320
        'y': 80
      create_cost_chart:
        x: 440
        'y': 280
      email_cost_information:
        x: 560
        'y': 80
        navigate:
          48427cfe-e4d8-f81b-74fa-78f95f2380d6:
            targetId: 0bcd0de2-7667-77a8-3309-9e3fa33f969e
            port: SUCCESS
    results:
      SUCCESS:
        0bcd0de2-7667-77a8-3309-9e3fa33f969e:
          x: 680
          'y': 280
