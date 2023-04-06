namespace: io.cloudslang.tests
flow:
  name: get_cpu_utilization_esxi
  workflow:
    - get_server_names:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_server_names: []
        publish:
          - server_names
          - token
          - csv: |
              uuid,sample_date,server_name,cpu_utilization
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - get_server_uuid_from_name:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_server_uuid_from_name:
            - token: '${token}'
            - serverName: '${serverName}'
        publish:
          - uuid
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_server_cpu_utilization
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${server_names}'
        publish:
          - serverName: '${result_string}'
        navigate:
          - HAS_MORE: get_server_uuid_from_name
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_server_cpu_utilization:
        do:
          io.cloudslang.carbon_footprint_project.oneview.subflows.get_server_cpu_utilization:
            - server_uuid: '${uuid}'
            - token: '${token}'
        publish:
          - cpu_utilization
          - date_of_sample
        navigate:
          - FAILURE: on_failure
          - SUCCESS: append
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${csv}'
            - text: "${uuid+','+date_of_sample+','+serverName+','+cpu_utilization+'\\n\\r'}"
        publish:
          - csv: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
  outputs:
    - cpu_utilization: '${csv}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_server_names:
        x: 103
        'y': 78
      get_server_uuid_from_name:
        x: 236
        'y': 260
      list_iterator:
        x: 399
        'y': 141
        navigate:
          62e8dfb8-9f54-e635-b4cc-6f5201b905d6:
            targetId: 0ad40115-6459-56cf-6e84-2c8f09ca13d2
            port: NO_MORE
      get_server_cpu_utilization:
        x: 362
        'y': 398
      append:
        x: 513
        'y': 352
    results:
      SUCCESS:
        0ad40115-6459-56cf-6e84-2c8f09ca13d2:
          x: 665
          'y': 112

