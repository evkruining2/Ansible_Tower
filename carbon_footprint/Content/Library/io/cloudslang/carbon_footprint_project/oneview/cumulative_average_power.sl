########################################################################################################################
#!!
#! @output combined_power_consumption: Combines power consumption in Watts
#! @output servers: List of queried servers
#! @output date_of_sample: Sample date
#! @output co2e: Total CO2e per 24 hours in kg
#! @output co2e_kwh: CO2e per kwh for provider
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project.oneview
flow:
  name: cumulative_average_power
  inputs:
    - list_of_servers: 'esx01.advantageinc.org,esx02.advantageinc.org,esx03.advantageinc.org'
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - get_oneview_token_1:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_oneview_token:
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
        publish:
          - token
          - number: '0'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${list_of_servers}'
        publish:
          - serverName: '${result_string}'
        navigate:
          - HAS_MORE: get_server_uuid_from_name
          - NO_MORE: watts_to_kwh
          - FAILURE: on_failure
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${number}'
            - value2: '${current_power_consumption}'
        publish:
          - number: '${result}'
          - watts: '${result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - get_server_uuid_from_name:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_server_uuid_from_name:
            - token: '${token}'
            - serverName: '${serverName}'
        publish:
          - uuid
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_server_average_power
    - get_server_average_power:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_server_average_power:
            - server_uuid: '${uuid}'
            - token: '${token}'
        publish:
          - current_power_consumption
          - date_of_sample
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers
    - get_emission_factors:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.get_emission_factors: []
        publish:
          - co2e_kwh
        navigate:
          - FAILURE: on_failure
          - SUCCESS: co2e_per_hour
    - co2e_per_hour:
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${co2e_kwh}'
            - value2: '${number}'
        publish:
          - number: '${result}'
        navigate:
          - SUCCESS: co2e_per_24hr
    - watts_to_kwh:
        do:
          io.cloudslang.base.math.divide_numbers:
            - value1: '${number}'
            - value2: '1000'
        publish:
          - number: '${result}'
        navigate:
          - ILLEGAL: FAILURE
          - SUCCESS: get_emission_factors
    - co2e_per_24hr:
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${number}'
            - value2: '24'
        publish:
          - co2e: '${result}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - combined_power_consumption: '${watts}'
    - servers: '${list_of_servers}'
    - date_of_sample: '${date_of_sample}'
    - co2e: '${co2e}'
    - co2e_kwh: '${co2e_kwh}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      co2e_per_hour:
        x: 448
        'y': 407
      add_numbers:
        x: 280
        'y': 400
      co2e_per_24hr:
        x: 672
        'y': 409
        navigate:
          701b223f-c079-1769-f0d4-5e7ee1936788:
            targetId: d6a78080-cfa1-c39e-0c31-318fe0db4606
            port: SUCCESS
      get_oneview_token_1:
        x: 80
        'y': 80
      watts_to_kwh:
        x: 458
        'y': 79
        navigate:
          80120798-f526-4654-b950-e3eefa7f7093:
            targetId: 2c11562d-9351-b40b-d55e-e83262175e70
            port: ILLEGAL
      get_server_uuid_from_name:
        x: 80
        'y': 240
      list_iterator:
        x: 280
        'y': 200
      get_server_average_power:
        x: 80
        'y': 440
      get_emission_factors:
        x: 456
        'y': 247
    results:
      SUCCESS:
        d6a78080-cfa1-c39e-0c31-318fe0db4606:
          x: 674
          'y': 238
      FAILURE:
        2c11562d-9351-b40b-d55e-e83262175e70:
          x: 674
          'y': 77

