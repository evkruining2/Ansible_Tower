namespace: io.cloudslang.base.datetime

operation:
  name: get_yesterday_epoch
  
  python_action:
    script: |
      import datetime
      import time

      # Get current time
      now = datetime.datetime.now()
      
      # Subtract 1 day
      yesterday = now - datetime.timedelta(days=1)
      
      # Convert to Epoch (seconds)
      # Use int() to remove decimals if needed
      epoch_yesterday = int(time.mktime(yesterday.timetuple()))
      
  outputs:
    - yesterday_epoch: ${str(epoch_yesterday)}
    - yesterday_str: ${yesterday.strftime('%Y-%m-%d %H:%M:%S')}

  results:
    - SUCCESS
