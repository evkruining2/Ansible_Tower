########################################################################################################################
#!!
#! @input easy_energy_url: URL to which the call is made.
#! @input date: Format is YYYY-MM-dd
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.easyenergy
flow:
  name: get_tariff_for_given_date
  inputs:
    - easy_energy_url: 'https://mijn.easyenergy.com/nl/api/tariff/getapxtariffs'
    - date
  workflow:
    - create_iso_timestamp_for_given_day:
        do:
          io.cloudslang.energy_project.date_time.create_iso_timestamp_for_given_day:
            - date: '${date}'
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
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sort_list:
        x: 880
        'y': 200
        navigate:
          af8f581b-c2c3-0e68-94ae-f95ed0e28d9e:
            targetId: c2ceccf0-9c7d-0d45-3730-5b3bf301e570
            port: SUCCESS
      http_client_get:
        x: 280
        'y': 80
      json_path_query:
        x: 480
        'y': 80
      round_numbers:
        x: 680
        'y': 80
      create_iso_timestamp_for_given_day:
        x: 80
        'y': 80
    results:
      SUCCESS:
        c2ceccf0-9c7d-0d45-3730-5b3bf301e570:
          x: 680
          'y': 440
