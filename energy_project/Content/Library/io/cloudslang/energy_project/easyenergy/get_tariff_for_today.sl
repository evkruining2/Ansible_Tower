########################################################################################################################
#!!
#! @input easy_energy_url: URL to which the call is made.
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.easyenergy
flow:
  name: get_tariff_for_today
  inputs:
    - easy_energy_url: 'https://mijn.easyenergy.com/nl/api/tariff/getapxtariffs'
  workflow:
    - create_iso_timestamp:
        do:
          io.cloudslang.energy_project.date_time.create_iso_timestamp: []
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
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - tariff_list: '${tariff_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_iso_timestamp:
        x: 120
        'y': 80
      http_client_get:
        x: 120
        'y': 280
      json_path_query:
        x: 320
        'y': 160
        navigate:
          9c826c19-3fe8-edf2-8422-566ce8de45f1:
            targetId: c2ceccf0-9c7d-0d45-3730-5b3bf301e570
            port: SUCCESS
    results:
      SUCCESS:
        c2ceccf0-9c7d-0d45-3730-5b3bf301e570:
          x: 560
          'y': 200
