########################################################################################################################
#!!
#! @input storage_amount: amount of storage
#! @input storage_type: Type of storage used
#! @input data_unit: unit of measurement
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: azure_vm_instance
  inputs:
    - provider: azure
    - region
    - cpu_count
    - memory
    - storage_amount
    - storage_type:
        default: ssd
        required: false
    - data_unit:
        default: GB
        required: false
  workflow:
    - calculate_co2e_cpu:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.calculate_co2e_cpu:
            - provider: '${provider}'
            - region: '${region}'
            - cpu_count: '${cpu_count}'
        publish:
          - co2e
          - total_co2e: '0'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers
    - calculate_co2e_memory:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.calculate_co2e_memory:
            - provider: '${provider}'
            - region: '${region}'
            - memory: '${memory}'
            - data_unit: MB
        publish:
          - co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers_1
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: calculate_co2e_memory
          - FAILURE: on_failure
    - add_numbers_1:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: calculate_co2e_storage
          - FAILURE: on_failure
    - calculate_co2e_storage:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.calculate_co2e_storage:
            - climatiq_url: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_url')}"
            - climatiq_token: "${get_sp('io.cloudslang.carbon_footprint_project.climatiq_token')}"
            - provider: '${provider}'
            - region: '${region}'
            - storage_amount: '${storage_amount}'
            - data_unit: '${data_unit}'
            - storage_type: '${storage_type}'
        publish:
          - co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers_1_1
    - add_numbers_1_1:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - total_co2e: '${total_co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      calculate_co2e_cpu:
        x: 120
        'y': 80
      calculate_co2e_memory:
        x: 320
        'y': 80
      add_numbers:
        x: 120
        'y': 280
      add_numbers_1:
        x: 320
        'y': 280
      calculate_co2e_storage:
        x: 520
        'y': 80
      add_numbers_1_1:
        x: 520
        'y': 280
        navigate:
          9239f539-ab39-78cf-0878-cbc260b0ff11:
            targetId: 86ef6df4-a299-8026-ab07-c27c49b8adb4
            port: SUCCESS
    results:
      SUCCESS:
        86ef6df4-a299-8026-ab07-c27c49b8adb4:
          x: 680
          'y': 80
