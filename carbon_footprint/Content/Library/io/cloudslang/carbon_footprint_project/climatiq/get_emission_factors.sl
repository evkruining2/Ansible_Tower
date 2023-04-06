########################################################################################################################
#!!
#! @description: This flow will query Climatq.io for the emission factors from a given location/provider, using a unique UUID. To lookup the appropriate UUID, go to the data explorer here: https://www.climatiq.io/explorer
#!
#! @input climatiq_url: Climatiq API URL
#! @input climatiq_token: Climatiq token to get access to the API
#! @input provider_uuid: Energy provider uuid according to Climatiq for the off-cloud data center
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: get_emission_factors
  inputs:
    - climatiq_url: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_url')}"
    - climatiq_token: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_token')}"
    - provider_uuid: "${get_sp('io.cloudslang.carbon_footprint_project.provider_uuid')}"
  workflow:
    - get_climatiq_io_provider_emission_factor:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${climatiq_url+'/estimate'}"
            - proxy_host: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_port')}"
            - headers: "${'Authorization: Bearer '+climatiq_token}"
            - body: "${'{'+\\\n'\"emission_factor\": {'+\\\n'\"uuid\": \"'+provider_uuid+'\"},'+\\\n'\"parameters\": {'+\\\n'\"energy\": 1,'+\\\n'\"energy_unit\": \"kWh\"'+\\\n'}}'}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.co2e
        publish:
          - co2e_kwh: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - co2e_kwh: '${co2e_kwh}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_climatiq_io_provider_emission_factor:
        x: 74
        'y': 96
      json_path_query:
        x: 143
        'y': 261
        navigate:
          e4ee4e5c-00eb-a08f-3420-73aec9bad093:
            targetId: 80d43498-370b-fc7c-6abf-e015e4d2314f
            port: SUCCESS
    results:
      SUCCESS:
        80d43498-370b-fc7c-6abf-e015e4d2314f:
          x: 221
          'y': 90
