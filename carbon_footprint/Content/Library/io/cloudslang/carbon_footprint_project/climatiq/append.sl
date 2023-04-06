namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: append
  inputs:
    - providers: 'aws,gcp,azure'
    - big_list:
        default: "${'big_cpu_list'+'\\r\\n'}"
        required: false
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${providers}'
        publish:
          - provider: '${result_string}'
        navigate:
          - HAS_MORE: batch_processing_cpu
          - NO_MORE: write_to_file
          - FAILURE: on_failure
    - batch_processing_cpu:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.batch_processing_cpu:
            - provider: '${provider}'
        publish:
          - co2e_results
        navigate:
          - FAILURE: on_failure
          - SUCCESS: append
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${big_list}'
            - text: '${co2e_results}'
        publish:
          - big_list: '${new_string}'
        navigate:
          - SUCCESS: batch_processing_memory
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: /tmp/big_list_cpu.csv
            - text: '${big_list}'
        publish:
          - message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - batch_processing_memory:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.batch_processing_memory:
            - provider: '${provider}'
        publish:
          - co2e_results
        navigate:
          - FAILURE: on_failure
          - SUCCESS: append_1
    - append_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${big_list}'
            - text: '${co2e_results}'
        publish:
          - big_list: '${new_string}'
        navigate:
          - SUCCESS: batch_processing_storage
    - batch_processing_storage:
        do:
          io.cloudslang.carbon_footprint_project.climatiq.batch_processing_storage:
            - provider: '${provider}'
        publish:
          - co2e_results
        navigate:
          - FAILURE: on_failure
          - SUCCESS: append_2
    - append_2:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${big_list}'
            - text: '${co2e_results}'
        publish:
          - big_list: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
  outputs:
    - big_cpu_list: '${big_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      batch_processing_cpu:
        x: 80
        'y': 240
      list_iterator:
        x: 80
        'y': 80
      append:
        x: 80
        'y': 440
      write_to_file:
        x: 280
        'y': 80
        navigate:
          96fc2427-649f-a01a-7401-2b8304248772:
            targetId: 5aba9338-236f-42ec-1eaf-6488b3b393cc
            port: SUCCESS
      batch_processing_memory:
        x: 280
        'y': 440
      append_1:
        x: 480
        'y': 440
      batch_processing_storage:
        x: 480
        'y': 240
      append_2:
        x: 280
        'y': 240
    results:
      SUCCESS:
        5aba9338-236f-42ec-1eaf-6488b3b393cc:
          x: 480
          'y': 80
