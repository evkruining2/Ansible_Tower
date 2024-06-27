########################################################################################################################
#!!
#! @input easy_energy_url: URL to which the call is made.
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.easyenergy
flow:
  name: get_tariff_for_tomorrow
  inputs:
    - easy_energy_url: 'https://mijn.easyenergy.com/nl/api/tariff/getapxtariffs'
  workflow:
    - create_iso_timestamp_for_tomorrow:
        do:
          io.cloudslang.energy_project.date_time.create_iso_timestamp_for_tomorrow: []
        publish:
          - begin_date
          - end_date
        navigate:
          - SUCCESS: http_client_get
          - FAILURE: on_failure
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${easy_energy_url+'?startTimestamp='+begin_date+'&endTimestamp='+end_date+'&grouping='}"
        publish:
          - json_array: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_array}'
            - json_path: $..TariffUsage
        publish:
          - tariff_list: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: is_list_empty
          - FAILURE: on_failure
    - round_numbers:
        do:
          io.cloudslang.energy_project.easyenergy.round_numbers:
            - list: '${tariff_list}'
        publish:
          - tariff_list
        navigate:
          - SUCCESS: get_lowest_tariff
          - FAILURE: on_failure
    - get_lowest_tariff:
        do:
          io.cloudslang.base.lists.sort_list:
            - list: '${tariff_list}'
            - delimiter: ','
        publish:
          - lowest_tariff: '${return_result.split(",")[0]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_list_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${tariff_list}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: round_numbers
  outputs:
    - tariff_list: '${tariff_list}'
    - lowest_tariff: '${lowest_tariff}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_iso_timestamp_for_tomorrow:
        x: 80
        'y': 80
      http_client_get:
        x: 80
        'y': 320
      json_path_query:
        x: 280
        'y': 440
      round_numbers:
        x: 280
        'y': 200
      get_lowest_tariff:
        x: 416
        'y': 112
        navigate:
          b826e965-0309-b216-b1b2-a79b11ac2bb9:
            targetId: c2ceccf0-9c7d-0d45-3730-5b3bf301e570
            port: SUCCESS
      is_list_empty:
        x: 440
        'y': 440
        navigate:
          1390f862-9d71-af7d-907f-354fb1c089f5:
            targetId: c2ceccf0-9c7d-0d45-3730-5b3bf301e570
            port: SUCCESS
    results:
      SUCCESS:
        c2ceccf0-9c7d-0d45-3730-5b3bf301e570:
          x: 680
          'y': 240
