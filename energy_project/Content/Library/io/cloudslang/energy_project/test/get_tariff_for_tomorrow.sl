########################################################################################################################
#!!
#! @input easy_energy_url: URL to which the call is made.
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.test
flow:
  name: get_tariff_for_tomorrow
  inputs:
    - easy_energy_url: 'https://mijn.easyenergy.com/nl/api/tariff/getapxtariffs'
    - begin_date: '2024-06-21T00%3A00%3A00'
    - end_date: '2024-06-22T00%3A00%3A00'
  workflow:
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
          - SUCCESS: FAILURE
          - FAILURE: round_numbers
  outputs:
    - tariff_list: '${tariff_list}'
    - lowest_tariff: '${lowest_tariff}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_lowest_tariff:
        x: 416
        'y': 112
        navigate:
          b826e965-0309-b216-b1b2-a79b11ac2bb9:
            targetId: c2ceccf0-9c7d-0d45-3730-5b3bf301e570
            port: SUCCESS
      http_client_get:
        x: 80
        'y': 320
      json_path_query:
        x: 280
        'y': 440
      round_numbers:
        x: 280
        'y': 200
      is_list_empty:
        x: 480
        'y': 440
        navigate:
          42a74515-feeb-647e-c83b-d4197ee4bf22:
            targetId: c8cb7e77-6ea4-e666-7850-8d892a3c27d9
            port: SUCCESS
    results:
      SUCCESS:
        c2ceccf0-9c7d-0d45-3730-5b3bf301e570:
          x: 680
          'y': 240
      FAILURE:
        c8cb7e77-6ea4-e666-7850-8d892a3c27d9:
          x: 680
          'y': 440
