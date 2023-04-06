########################################################################################################################
#!!
#! @input climatiq_url: Climatiq API URL
#! @input climatiq_token: Climatiq token to get access to the API
#! @input provider_uuid: Energy provider uuid according to Climatiq for the off-cloud data center
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project.oneview
flow:
  name: write_dc_scope2_co2e_to_odl
  inputs:
    - timestamp
    - climatiq_url:
        default: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_url')}"
        required: false
    - climatiq_token:
        default: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_token')}"
        required: false
    - provider_uuid:
        default: "${get_sp('io.cloudslang.carbon_footprint_project.provider_uuid')}"
        required: false
  workflow:
    - calculate_co2e_scope3:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.calculate_co2e_scope3: []
        publish:
          - dcoe_scope3_co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: local_dc_co2e
    - local_dc_co2e:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.local_dc_co2e:
            - timestamp: '${timestamp}'
            - dcoe_scope3_co2e: '${dcoe_scope3_co2e}'
        publish:
          - date_of_sample
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - date_of_sample: '${date_of_sample}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      local_dc_co2e:
        x: 240
        'y': 80
        navigate:
          e78f9ee0-0df6-12f4-7556-2bc3695fe731:
            targetId: aa243003-4d3d-ce3a-1c71-bf1644cd54fe
            port: SUCCESS
      calculate_co2e_scope3:
        x: 80
        'y': 80
    results:
      SUCCESS:
        aa243003-4d3d-ce3a-1c71-bf1644cd54fe:
          x: 440
          'y': 80
