########################################################################################################################
#!!
#! @input easy_energy_url: URL to which the call is made.
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.easyenergy
flow:
  name: get_tariff_for_yesterday
  inputs:
    - easy_energy_url: 'https://mijn.easyenergy.com/nl/api/tariff/getapxtariffs'
  workflow:
    - create_iso_timestamp_for_yesterday:
        do:
          io.cloudslang.energy_project.date_time.create_iso_timestamp_for_yesterday: []
        publish:
          - begin_date
          - end_date
          - p1_date
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
          - SUCCESS: round_numbers
          - FAILURE: on_failure
    - round_numbers:
        do:
          io.cloudslang.energy_project.easyenergy.round_numbers:
            - list: '${tariff_list}'
        publish:
          - tariff_list
        navigate:
          - SUCCESS: sort_list
          - FAILURE: on_failure
    - sort_list:
        do:
          io.cloudslang.base.lists.sort_list:
            - list: '${tariff_list}'
            - delimiter: ','
        publish:
          - lowest_tariff: '${return_result.split(",")[0]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - tariff_list: '${tariff_list}'
    - lowest_tariff: '${lowest_tariff}'
    - p1_date: '${p1_date}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_iso_timestamp_for_yesterday:
        x: 120
        'y': 80
      http_client_get:
        x: 120
        'y': 280
      json_path_query:
        x: 120
        'y': 440
      round_numbers:
        x: 320
        'y': 440
      sort_list:
        x: 320
        'y': 280
        navigate:
          af8f581b-c2c3-0e68-94ae-f95ed0e28d9e:
            targetId: c2ceccf0-9c7d-0d45-3730-5b3bf301e570
            port: SUCCESS
    results:
      SUCCESS:
        c2ceccf0-9c7d-0d45-3730-5b3bf301e570:
          x: 560
          'y': 200
