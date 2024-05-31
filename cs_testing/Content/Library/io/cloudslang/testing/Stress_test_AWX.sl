namespace: io.cloudslang.testing
flow:
  name: Stress_test_AWX
  inputs:
    - loop: '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20'
    - TemplateID: '20'
  workflow:
    - Launch_Job_Template:
        worker_group:
          value: "${get_sp('io.cloudslang.redhat.ansible.worker_group')}"
          override: true
        parallel_loop:
          for: i in loop
          do:
            io.cloudslang.base.http.http_client_post:
              - url: "${'http://192.168.2.199:32330/api/v2/job_templates/'+TemplateID+'/launch/'}"
              - auth_type: basic
              - username: admin
              - password:
                  value: admin
                  sensitive: true
              - trust_all_roots: 'true'
              - x_509_hostname_verifier: allow_all
              - headers: 'Content-Type:application/json'
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Launch_Job_Template:
        x: 161
        'y': 187
        navigate:
          1042a7c7-87c7-333d-d148-290d061d8839:
            targetId: 798571d1-dbac-7f5e-7d4a-d0985abd881f
            port: SUCCESS
    results:
      SUCCESS:
        798571d1-dbac-7f5e-7d4a-d0985abd881f:
          x: 440
          'y': 520
