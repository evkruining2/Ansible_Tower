namespace: io.cloudslang.tools
flow:
  name: update_and_cleanup_CentOS_server
  inputs:
    - host: localhost
    - username: root
    - password:
        sensitive: true
  workflow:
    - install_CentOS_updates:
        do:
          io.cloudslang.tools.install_CentOS_updates:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - update_out: '${standard_out}'
          - update_return_code: '${return_code}'
        navigate:
          - SUCCESS:
              next_step: autoremove_old_packages
              ROI: '1'
          - FAILURE: on_failure
    - autoremove_old_packages:
        do:
          io.cloudslang.tools.autoremove_old_packages:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - cleanup_out: '${standard_out}'
          - cleanup_return_code: '${return_code}'
        navigate:
          - SUCCESS:
              next_step: SUCCESS
              ROI: '1'
          - FAILURE: on_failure
  outputs:
    - update_return_code: '${update_return_code}'
    - cleanup_return_code: '${cleanup_return_code}'
    - update_out: '${update_out}'
    - cleanup_out: '${cleanup_out}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_CentOS_updates:
        x: 160
        'y': 160
      autoremove_old_packages:
        x: 400
        'y': 160
        navigate:
          22aafd05-5152-1558-0109-bddccc6332a7:
            targetId: 829bd0e0-93b5-fddc-19fb-c79b64da9aa2
            port: SUCCESS
    results:
      SUCCESS:
        829bd0e0-93b5-fddc-19fb-c79b64da9aa2:
          x: 440
          'y': 400
