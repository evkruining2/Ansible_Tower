namespace: tests
flow:
  name: Get_Internal_IDs
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - run_id: '${get_run_id()}'
            - user_id: '${get_user_id()}'
            - worker_group: '${get_worker_group()}'
        publish:
          - run_id
          - user_id
          - worker_group
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - run_id: '${run_id}'
    - user_id: '${user_id}'
    - worker_group: '${worker_group}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing:
        x: 280
        'y': 160
        navigate:
          253c84b2-841e-c247-b89d-083db4336535:
            targetId: 84dd4e0e-77cb-feb7-331e-41b54be38cf9
            port: SUCCESS
    results:
      SUCCESS:
        84dd4e0e-77cb-feb7-331e-41b54be38cf9:
          x: 480
          'y': 160
