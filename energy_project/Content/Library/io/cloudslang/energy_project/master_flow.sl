namespace: io.cloudslang.energy_project
flow:
  name: master_flow
  workflow:
    - get_tariff_for_tomorrow:
        do:
          io.cloudslang.energy_project.easyenergy.get_tariff_for_tomorrow: []
        publish:
          - tariff_list
          - lowest_tariff
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_if_we_have_a_list
    - human_readable_date:
        do:
          io.cloudslang.energy_project.date_time.human_readable_date:
            - offset: '86400'
        publish:
          - date
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_html_chart
    - check_if_we_have_a_list:
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: '${tariff_list}'
            - default_value: '0'
        publish:
          - tariff_list: '${return_result}'
        navigate:
          - SUCCESS: check_list_length
          - FAILURE: on_failure
    - check_list_length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${tariff_list}'
        publish:
          - list_length: '${return_result}'
        navigate:
          - SUCCESS: proceed_if_list_length_is_24
          - FAILURE: on_failure
    - proceed_if_list_length_is_24:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${list_length}'
            - second_string: '24'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: human_readable_date
          - FAILURE: no_list_present
    - no_list_present:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: '13'
        publish:
          - cheapest_hour: '${input_0}'
        navigate:
          - SUCCESS: human_readable_date_1
          - FAILURE: on_failure
    - create_html_chart:
        do:
          io.cloudslang.energy_project.email_and_html_reports.create_html_chart:
            - tariff_list: '${tariff_list}'
            - date: '${date}'
        navigate:
          - SUCCESS: email_tariff_information
          - FAILURE: on_failure
    - email_tariff_information:
        do:
          io.cloudslang.energy_project.email_and_html_reports.email_tariff_information:
            - tariff_list: '${tariff_list}'
            - date: '${date}'
            - lowest_tariff: '${lowest_tariff}'
        publish:
          - cheapest_hour
        navigate:
          - SUCCESS: schedule_flow_run
          - FAILURE: on_failure
    - schedule_flow_run:
        do:
          io.cloudslang.energy_project.date_time.schedule_flow_run:
            - hr: '${cheapest_hour}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: m2
            - port: '25'
            - from: easyEnergyBot@opsware.nl
            - to: erwin@opsware.nl
            - subject: "${'We hebben geen tarieven kunnen vinden voor '+date}"
            - body: |-
                ${'''
                <!DOCTYPE html>
                <html>
                  <head>

                    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
                    <title></title>
                  </head>
                  <body>
                    <table width="100%" cellspacing="2" cellpadding="2" border="0"
                      bgcolor="#ff6600">
                      <tbody>
                        <tr>
                          <td valign="top"><br>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <br>
                    Beste Erwin, we hebben helaas geen easyEnergy tarieven kunnen vinden voor morgen, '''+date+'''.<br>
                    <br>
                    We hebben de smart-plug(s) nu standaard geprogrammeerd voor 13:00 uur tot 14:00 uur. Hopelijk krijgen we morgen weer de juiste tarieven binnen.<br>
                    <br>
                    Met vriendelijke groeten,<br>
                    Uw easyEneryBot - powered by Operations Orchestration<br>
                    <br>
                    <table width="100%" cellspacing="2" cellpadding="2" border="0">
                      <tbody>
                        <tr>
                          <td valign="top" bgcolor="#ff6600"><br>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <br>
                  </body>
                </html>

                '''}
            - html_email: 'true'
        navigate:
          - SUCCESS: schedule_flow_run
          - FAILURE: on_failure
    - human_readable_date_1:
        do:
          io.cloudslang.energy_project.date_time.human_readable_date:
            - offset: '86400'
        publish:
          - date
        navigate:
          - FAILURE: on_failure
          - SUCCESS: send_mail
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      schedule_flow_run:
        x: 680
        'y': 280
        navigate:
          445f1a4b-0211-6c08-dee4-cf651db2a2c4:
            targetId: b0d752b2-3b75-ebc7-ca84-85efa6b536a6
            port: SUCCESS
      human_readable_date:
        x: 280
        'y': 80
      check_if_we_have_a_list:
        x: 80
        'y': 280
      create_html_chart:
        x: 480
        'y': 80
      get_tariff_for_tomorrow:
        x: 80
        'y': 80
      send_mail:
        x: 480
        'y': 280
      proceed_if_list_length_is_24:
        x: 280
        'y': 280
      check_list_length:
        x: 80
        'y': 480
      email_tariff_information:
        x: 680
        'y': 80
      no_list_present:
        x: 280
        'y': 520
      human_readable_date_1:
        x: 480
        'y': 520
    results:
      SUCCESS:
        b0d752b2-3b75-ebc7-ca84-85efa6b536a6:
          x: 680
          'y': 480
