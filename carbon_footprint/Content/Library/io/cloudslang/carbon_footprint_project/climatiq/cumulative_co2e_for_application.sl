########################################################################################################################
#!!
#! @input cpu_count: The number of CPU's configured for the application
#! @input cpu_load: The average CPU load of the application
#! @input memory: Amount of memory used (in "data_units")
#! @input storage: Amount of storage used (in "data_units")
#! @input storage_type: The type of storage that is used (ssd)
#! @input data_unit: Units for data sources (MB, GB, etc)
#! @input provider: Enter the compute provider (aws, azure or gcp)
#! @input region: Enter the region of the compute recourses (eu_west_1, uk_west, europe_west_1, etc)
#!
#! @output application_co2e: The total co2e of the application
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: cumulative_co2e_for_application
  inputs:
    - cpu_count: '32'
    - cpu_load: '75'
    - memory: '128'
    - storage: '3000'
    - storage_type: ssd
    - data_unit: GB
    - provider: gcp
    - region: europe_west_1
  workflow:
    - calculate_co2e_cpu:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.carbon_footprint_project.climatiq.calculate_co2e_cpu:
            - provider: '${provider}'
            - region: '${region}'
            - cpu_count: '${cpu_count}'
            - cpu_load: '${cpu_load}'
        publish:
          - cpu_co2e: '${co2e}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: calculate_co2e_memory
    - calculate_co2e_memory:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.carbon_footprint_project.climatiq.calculate_co2e_memory:
            - provider: '${provider}'
            - region: '${region}'
            - memory: '${memory}'
            - data_unit: '${data_unit}'
        publish:
          - memory_co2e: '${co2e}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_cpu_and_memory_co2e
    - calculate_co2e_storage:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.carbon_footprint_project.climatiq.calculate_co2e_storage:
            - provider: '${provider}'
            - region: '${region}'
            - storage_amount: '${storage}'
            - data_unit: '${data_unit}'
            - storage_type: '${storage_type}'
        publish:
          - storage_co2e: '${co2e}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_storage_co2e
    - add_cpu_and_memory_co2e:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${cpu_co2e}'
            - value2: '${memory_co2e}'
        publish:
          - sum1: '${result}'
        navigate:
          - SUCCESS: calculate_co2e_storage
          - FAILURE: on_failure
    - add_storage_co2e:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${storage_co2e}'
            - value2: '${sum1}'
        publish:
          - application_co2e: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - application_co2e: '${application_co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      calculate_co2e_cpu:
        x: 80
        'y': 80
      calculate_co2e_memory:
        x: 80
        'y': 240
      calculate_co2e_storage:
        x: 480
        'y': 80
      add_cpu_and_memory_co2e:
        x: 280
        'y': 160
      add_storage_co2e:
        x: 680
        'y': 160
        navigate:
          a377385a-906b-3309-46d7-97a9f9e6e681:
            targetId: 17a91132-8aeb-7c16-2480-f759e952a83d
            port: SUCCESS
    results:
      SUCCESS:
        17a91132-8aeb-7c16-2480-f759e952a83d:
          x: 680
          'y': 360
