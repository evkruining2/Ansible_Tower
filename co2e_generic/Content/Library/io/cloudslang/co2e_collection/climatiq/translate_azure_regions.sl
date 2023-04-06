########################################################################################################################
#!!
#! @description: Mapping Azure location names into Climatiq.io accepted location names for Azure (adding "-" in the names)
#!
#! @input worker_group: Optional - RAS worker group to use. Default: RAS_Operator_Path
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.climatiq
flow:
  name: translate_azure_regions
  inputs:
    - az_region
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
  workflow:
    - get_azure_regions:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - json_result: |-
              ${'''
              {
                  "value" : [
                {"australia": "australia"},
                {"australiacentral": "australia_central"},
                {"australiacentral2": "australia_central_2"},
                {"australiaeast": "australia_east"},
                {"australiasoutheast": "australia_south_east"},
                {"brazil": "brazil"},
                {"brazilsouth": "brazil_south"},
                {"brazilsoutheast": "brazil_south_east"},
                {"canada": "canada"},
                {"canadacentral": "canada_central"},
                {"canadaeast": "canada_east"},
                {"centralus": "central_us"},
                {"eastasia": "east_asia"},
                {"eastus": "east_us"},
                {"eastus2": "east_us_2"},
                {"eastus3": "east_us_3"},
                {"france": "france"},
                {"francecentral": "france_central"},
                {"francesouth": "france_south"},
                {"germany": "germany"},
                {"germanynorth": "germany_north"},
                {"germanywestcentral": "germany_west_central"},
                {"india": "india"},
                {"indiacentral": "india_central"},
                {"indiasouth": "india_south"},
                {"indiawest": "india_west"},
                {"japan": "japan"},
                {"japaneast": "japan_east"},
                {"japanwest": "japan_west"},
                {"korea": "korea"},
                {"koreaeast": "korea_east"},
                {"koreasouth": "korea_south"},
                {"northcentralus": "north_central_us"},
                {"northeurope": "north_europe"},
                {"norway": "norway"},
                {"norwayeast": "norway_east"},
                {"norwaywest": "norway_west"},
                {"southafrica": "south_africa"},
                {"southafricanorth": "south_africa_north"},
                {"southafricawest": "south_africa_west"},
                {"southcentralus": "south_central_us"},
                {"southeastasia": "southeast_asia"},
                {"swedencentral": "sweden_central"},
                {"switzerland": "switzerland"},
                {"switzerlandnorth": "switzerland_north"},
                {"switzerlandwest": "switzerland_west"},
                {"uk": "uk"},
                {"uksouth": "uk_south"},
                {"ukwest": "uk_west"},
                {"unitedarabemirates": "united_arab_emirates"},
                {"unitedarabemiratescentral": "united_arab_emirates_central"},
                {"unitedarabemiratesnorth": "united_arab_emirates_north"},
                {"westcentralus": "west_central_us"},
                {"westeurope": "west_europe"},
                {"westus": "west_us"},
                {"westus2": "west_us_2"},
                {"westus3": "west_us_3"}
              ]
              }
              '''}
        navigate:
          - SUCCESS: map_climatiq_region
          - FAILURE: on_failure
    - map_climatiq_region:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: "${'$.value..'+az_region}"
        publish:
          - region: "${return_result.strip('[').strip(']').strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - region: '${region}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_azure_regions:
        x: 120
        'y': 120
      map_climatiq_region:
        x: 320
        'y': 120
        navigate:
          65613f40-1869-3d86-125b-b9d47082b831:
            targetId: 5d687388-4ea7-e7da-e42f-94256bbab6d3
            port: SUCCESS
    results:
      SUCCESS:
        5d687388-4ea7-e7da-e42f-94256bbab6d3:
          x: 560
          'y': 120
