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
          - SUCCESS: put_cost_in_db
          - FAILURE: on_failure
    - put_cost_in_db:
        do:
          io.cloudslang.energy_project.database.put_cost_in_db:
            - date: '${p1_date}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_all_cost_chart_yesterday
    - create_all_cost_chart_yesterday:
        do:
          io.cloudslang.energy_project.usage_cost.create_all_cost_chart_yesterday: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
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
        x: 280
        'y': 80
      create_cost_chart:
        x: 400
        'y': 280
      email_cost_information:
        x: 480
        'y': 80
      put_cost_in_db:
        x: 600
        'y': 280
      create_all_cost_chart_yesterday:
        x: 680
        'y': 80
        navigate:
          25e15724-24d2-6dde-09b9-73f517e7e6f7:
            targetId: 0bcd0de2-7667-77a8-3309-9e3fa33f969e
            port: SUCCESS
    results:
      SUCCESS:
        0bcd0de2-7667-77a8-3309-9e3fa33f969e:
          x: 800
          'y': 280
