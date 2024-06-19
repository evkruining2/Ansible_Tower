########################################################################################################################
#!!
#! @description: Get a 24 hour date range in url encoded format for today
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.date_time
flow:
  name: create_iso_timestamp_for_tomorrow
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - locale_lang: nl
            - locale_country: nl
            - timezone: CET
            - date_format: YYYY-MM-dd
        publish:
          - output
          - begin_date: "${output+'T00:00:00'}"
        navigate:
          - SUCCESS: offset_time_by
          - FAILURE: on_failure
    - offset_time_by:
        do:
          io.cloudslang.base.datetime.offset_time_by:
            - date: '${output}'
            - offset: '86400'
        publish:
          - begin_date: '${output}'
        navigate:
          - SUCCESS: offset_time_by_1
          - FAILURE: on_failure
    - parse_date:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${begin_date}'
            - out_format: "yyyy-MM-dd'T'HH:mm:ss"
        publish:
          - begin_date: '${output}'
        navigate:
          - SUCCESS: parse_date_1
          - FAILURE: on_failure
    - url_encoder:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${begin_date}'
        publish:
          - begin_date: '${result}'
        navigate:
          - SUCCESS: url_encoder_1
          - FAILURE: on_failure
    - url_encoder_1:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${end_date}'
        publish:
          - end_date: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - offset_time_by_1:
        do:
          io.cloudslang.base.datetime.offset_time_by:
            - date: '${output}'
            - offset: '172800'
        publish:
          - end_date: '${output}'
        navigate:
          - SUCCESS: parse_date
          - FAILURE: on_failure
    - parse_date_1:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '${end_date}'
            - out_format: "yyyy-MM-dd'T'HH:mm:ss"
        publish:
          - end_date: '${output}'
        navigate:
          - SUCCESS: url_encoder
          - FAILURE: on_failure
  outputs:
    - begin_date: '${begin_date}'
    - end_date: '${end_date}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_time:
        x: 80
        'y': 80
      offset_time_by:
        x: 80
        'y': 280
      parse_date:
        x: 280
        'y': 480
      url_encoder:
        x: 640
        'y': 480
      url_encoder_1:
        x: 640
        'y': 280
        navigate:
          55eac0a1-5573-edc5-93f4-658464731ea0:
            targetId: b47d5219-c607-8df4-3c01-65a087330835
            port: SUCCESS
      offset_time_by_1:
        x: 80
        'y': 480
      parse_date_1:
        x: 480
        'y': 480
    results:
      SUCCESS:
        b47d5219-c607-8df4-3c01-65a087330835:
          x: 640
          'y': 80
