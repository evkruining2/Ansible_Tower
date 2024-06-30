########################################################################################################################
#!!
#! @input hr: The cheapest rate hour
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.date_time
flow:
  name: schedule_flow_run
  inputs:
    - hr: '13'
    - start_flow: io.cloudslang.energy_project.home_assistant.switch_on
    - stop_flow: io.cloudslang.energy_project.home_assistant.switch_off
  workflow:
    - get_current_date:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: yyyy-MM-dd
        publish:
          - output
          - year: '${cs_extract_number(output,1)}'
          - month: '${cs_extract_number(output,2)}'
        navigate:
          - SUCCESS: set_date_for_tomorrow
          - FAILURE: on_failure
    - set_date_for_tomorrow:
        do:
          io.cloudslang.base.datetime.offset_time_by:
            - date: '${output}'
            - offset: '86400'
        publish:
          - day: '${cs_extract_number(output,1)}'
          - output
        navigate:
          - SUCCESS: parse_date
          - FAILURE: on_failure
    - convert_date_format:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${year+month+day}'
            - date_format: yyyyMMdd
            - out_format: "${'MM/dd/yyyy '+hr+':00:00'}"
        publish:
          - output
        navigate:
          - SUCCESS: generate_epoch_time
          - FAILURE: on_failure
    - generate_epoch_time:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: "${get_sp('easyenergy_project.web_host')}"
            - command: "${'date --date=\"'+output+'\" +\"%s\"'}"
            - username: "${get_sp('easyenergy_project.web_host_user')}"
            - password:
                value: "${get_sp('easyenergy_project.web_host_password')}"
                sensitive: true
        publish:
          - epoch: "${return_result.strip('\\n')+'000'}"
        navigate:
          - SUCCESS: get_oo_csrf_token
          - FAILURE: on_failure
    - get_oo_csrf_token:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: 'https://oo3.museumhof.net:8443/oo/rest/version'
            - auth_type: basic
            - username: "${get_sp('easyenergy_project.oo_user')}"
            - password:
                value: "${get_sp('easyenergy_project.oo_password')}"
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - method: GET
        publish:
          - token: "${cs_regex(response_headers,'.*X-CSRF-TOKEN: (.*)')}"
        navigate:
          - SUCCESS: schedule_power_on_flow
          - FAILURE: on_failure
    - schedule_power_on_flow:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: 'https://oo3.museumhof.net:8443/oo/rest/v2/schedules'
            - auth_type: basic
            - username: "${get_sp('easyenergy_project.oo_user')}"
            - password:
                value: "${get_sp('easyenergy_project.oo_password')}"
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'X-CSRF-TOKEN: '+token+'\\nContent-Type: application/json'}"
            - body: |-
                ${'''
                {
                "flowScheduleName": "Power on smartplug at cheapest hour",
                "flowUuid": "'''+start_flow+'''",
                "triggerExpression": "*/600000",
                "startDate": '''+epoch+''',
                "endDate": '''+epoch+''',
                "runLogLevel": "STANDARD",
                "inputPromptUseBlank": true,
                "timeZone": "Europe/Amsterdam"
                }
                '''}
            - content_type: 'Content-Type: application/json'
        navigate:
          - SUCCESS: add_hour_to_epoch
          - FAILURE: on_failure
    - schedule_power_off_flow:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: 'https://oo3.museumhof.net:8443/oo/rest/v2/schedules'
            - auth_type: basic
            - username: "${get_sp('easyenergy_project.oo_user')}"
            - password:
                value: "${get_sp('easyenergy_project.oo_password')}"
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'X-CSRF-TOKEN: '+token+'\\nContent-Type: application/json'}"
            - body: |-
                ${'''
                {
                "flowScheduleName": "Power off smartplug after cheapest hour",
                "flowUuid": "'''+stop_flow+'''",
                "triggerExpression": "*/600000",
                "startDate": '''+epoch+''',
                "endDate": '''+epoch+''',
                "runLogLevel": "STANDARD",
                "inputPromptUseBlank": true,
                "timeZone": "Europe/Amsterdam"
                }
                '''}
            - content_type: 'Content-Type: application/json'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - add_hour_to_epoch:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${epoch}'
            - value2: '3600000'
        publish:
          - epoch: '${result}'
        navigate:
          - SUCCESS: schedule_power_off_flow
          - FAILURE: on_failure
    - parse_date:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${output}'
            - out_format: YYYY-MM-dd
        publish:
          - month: '${cs_extract_number(output,2)}'
        navigate:
          - SUCCESS: convert_date_format
          - FAILURE: on_failure
  outputs:
    - epoch: '${epoch}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      schedule_power_off_flow:
        x: 40
        'y': 240
        navigate:
          40ab1da0-f800-c94e-8e21-51d823dc260b:
            targetId: ac3e03c5-6268-e449-56a8-6f45982df783
            port: SUCCESS
      add_hour_to_epoch:
        x: 200
        'y': 240
      schedule_power_on_flow:
        x: 360
        'y': 240
      generate_epoch_time:
        x: 680
        'y': 40
      set_date_for_tomorrow:
        x: 200
        'y': 40
      get_oo_csrf_token:
        x: 520
        'y': 240
      parse_date:
        x: 360
        'y': 40
      convert_date_format:
        x: 520
        'y': 40
      get_current_date:
        x: 40
        'y': 40
    results:
      SUCCESS:
        ac3e03c5-6268-e449-56a8-6f45982df783:
          x: 40
          'y': 440
