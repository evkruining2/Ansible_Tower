namespace: io.cloudslang.tests
flow:
  name: get_azure_disk_size
  inputs:
    - disks:
        prompt:
          type: text
        required: false
  workflow:
    - check_if_disk_is_present:
        do:
          io.cloudslang.base.strings.length:
            - origin_string: '${disks}'
        publish:
          - length
        navigate:
          - SUCCESS: compare_numbers
    - compare_numbers:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${length}'
            - value2: '0'
        publish: []
        navigate:
          - GREATER_THAN: cycle_through_disks
          - EQUALS: set_disk_sizes_to_zero
          - LESS_THAN: set_disk_sizes_to_zero
    - cycle_through_disks:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${disks}'
        publish:
          - disk: '${result_string}'
        navigate:
          - HAS_MORE: cumulative_disk_sizes
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - cumulative_disk_sizes:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: "${get('disk_sizes', '0')}"
            - value2: '${disk}'
        publish:
          - disk_sizes: '${result}'
        navigate:
          - SUCCESS: cycle_through_disks
          - FAILURE: on_failure
    - set_disk_sizes_to_zero:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: "${get('disk_sizes', '0')}"
            - value2: '${length}'
        publish:
          - disk_sizes: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - disk_sizes: '${disk_sizes}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      cycle_through_disks:
        x: 280
        'y': 240
        navigate:
          6f2d6f4f-53ee-10fe-ab97-26ffa35d76f7:
            targetId: c9c449c6-09b4-5ef2-e7d1-961de2773795
            port: NO_MORE
      compare_numbers:
        x: 280
        'y': 80
      set_disk_sizes_to_zero:
        x: 80
        'y': 240
        navigate:
          2116b6da-7db7-9dc3-eeb7-587d3ab8841f:
            targetId: c9c449c6-09b4-5ef2-e7d1-961de2773795
            port: SUCCESS
      cumulative_disk_sizes:
        x: 480
        'y': 240
      check_if_disk_is_present:
        x: 80
        'y': 80
    results:
      SUCCESS:
        c9c449c6-09b4-5ef2-e7d1-961de2773795:
          x: 280
          'y': 440
