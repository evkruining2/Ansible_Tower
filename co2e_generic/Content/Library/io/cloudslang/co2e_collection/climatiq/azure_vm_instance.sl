namespace: io.cloudslang.co2e_collection.climatiq
flow:
  name: azure_vm_instance
  inputs:
    - provider: azure
    - region
    - cpu_count
    - memory
  workflow:
    - calculate_co2e_cpu:
        do:
          io.cloudslang.co2e_collection.climatiq.calculate_co2e_cpu:
            - provider: '${provider}'
            - region: '${region}'
            - cpu_count: '${cpu_count}'
        publish:
          - co2e
          - total_co2e: '0'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: calculate_co2e_memory_1
          - FAILURE: on_failure
    - add_numbers_1:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - calculate_co2e_memory_1:
        do:
          io.cloudslang.co2e_collection.climatiq.calculate_co2e_memory:
            - provider: '${provider}'
            - region: '${region}'
            - memory: '${memory}'
            - data_unit: MB
            - trust_all_roots: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
            - hostname_verifier: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
        publish:
          - co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers_1
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
      calculate_co2e_memory_1:
        x: 360
        'y': 80
      add_numbers:
        x: 240
        'y': 280
      add_numbers_1:
        x: 520
        'y': 280
        navigate:
          f6166e2d-d29b-4bd8-02ee-cb0a447f37e9:
            targetId: 86ef6df4-a299-8026-ab07-c27c49b8adb4
            port: SUCCESS
    results:
      SUCCESS:
        86ef6df4-a299-8026-ab07-c27c49b8adb4:
          x: 680
          'y': 80
