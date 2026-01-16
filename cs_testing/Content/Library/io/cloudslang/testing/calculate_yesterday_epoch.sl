namespace: io.cloudslang.base.datetime

flow:
  name: calculate_yesterday_epoch

  workflow:
    # 1. Get the current time in a standard format
    - get_current_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: "yyyy-MM-dd HH:mm:ss"
        publish:
          - current_time: ${output_text}

    # 2. Offset the time by -1 days
    - offset_to_yesterday:
        do:
          io.cloudslang.base.datetime.offset_time_by:
            - date_as_string: ${current_time}
            - date_format: "yyyy-MM-dd HH:mm:ss"
            - offset: "-86400" # 24 hours in seconds
        publish:
          - yesterday_date: ${new_date}

    # 3. Convert that date string into Epoch
    - convert_to_epoch:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date_string: ${yesterday_date}
            - date_format: "yyyy-MM-dd HH:mm:ss"
            - out_format: "unix" 
        publish:
          - yesterday_epoch: ${result_text}

  outputs:
    - yesterday_epoch: ${yesterday_epoch}
