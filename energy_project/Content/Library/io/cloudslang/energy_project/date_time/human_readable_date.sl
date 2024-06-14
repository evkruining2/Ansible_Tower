namespace: io.cloudslang.energy_project.date_time
flow:
  name: human_readable_date
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: yyyy-MM-dd
        publish:
          - output
        navigate:
          - SUCCESS: offset_time_by
          - FAILURE: on_failure
    - offset_time_by:
        do:
          io.cloudslang.base.datetime.offset_time_by:
            - date: '${output}'
            - offset: '86400'
            - locale_lang: NL
            - locale_country: NL
        publish:
          - date: "${cs_replace(output, \" 0:00:00 CEST\",'' )}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - date: '${date}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_time:
        x: 80
        'y': 120
      offset_time_by:
        x: 280
        'y': 120
        navigate:
          9d054815-83f6-fdf1-4f6b-3349299a3d60:
            targetId: d9023872-65e5-d9af-1f7e-b5e45c72df27
            port: SUCCESS
    results:
      SUCCESS:
        d9023872-65e5-d9af-1f7e-b5e45c72df27:
          x: 440
          'y': 120
