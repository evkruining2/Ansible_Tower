namespace: io.cloudslang.tools
operation:
  name: create_timestamp
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute():\n    # code goes here\n    import time\n    \n    timestamp = round(time.time() * 1000)\n    return locals()\n# you can add additional helper methods below."
  outputs:
    - timestamp
  results:
    - SUCCESS
