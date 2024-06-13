namespace: io.cloudslang.site_migration_use_case.tools
flow:
  name: write_values_to_file
  inputs:
    - hostid
    - vmid
    - ip_address
    - old_website: 192.168.2.70
  workflow:
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: /var/tmp/site.csv
            - text: "${hostid+','+vmid+','+ip_address+','+old_website}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      write_to_file:
        x: 280
        'y': 240
        navigate:
          43516cbc-9be6-882b-929b-d7bd963f7ff2:
            targetId: 176fcfae-8026-0883-2590-b6aed8eb9161
            port: SUCCESS
    results:
      SUCCESS:
        176fcfae-8026-0883-2590-b6aed8eb9161:
          x: 480
          'y': 240
