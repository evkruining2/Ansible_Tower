########################################################################################################################
#!!
#! @description: Loop through a job status until either failed or successful and reports back the final status
#!
#! @input AnsibleTowerURL: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input AnsibleUsername: Username to connect to Ansible Tower
#! @input AnsiblePassword: Password used to connect to Ansible Tower
#! @input TrustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input HostnameVerify: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input JobID: The id(integer) of the job to watch
#! @input Loops: Amount of 10-seconds loops to watch for a final jab status
#!
#! @output JobStatus: The final job status
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible_tower.jobs
flow:
  name: wait_for_final_job_result
  inputs:
    - AnsibleTowerURL
    - AnsibleUsername
    - AnsiblePassword:
        sensitive: true
    - TrustAllRoots: 'false'
    - HostnameVerify: 'strict'
    - JobID:
        required: true
    - Loops: '10'
  workflow:
    - Job_Status:
        loop:
          for: i in Loops
          do:
            io.cloudslang.redhat.ansible_tower.jobs.job_status:
              - JobID: '${JobID}'
          break:
            - FAILURE
          publish:
            - JobStatus
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Is_status_successful
    - Is_status_successful:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${JobStatus}'
            - second_string: successful
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: Is_status_failed
    - Is_status_failed:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${JobStatus}'
            - second_string: failed
            - ignore_case: 'true'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: Is_status_pending
    - Is_status_pending:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${JobStatus}'
            - second_string: pending
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: Is_status_runnning
    - Is_status_runnning:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${JobStatus}'
            - second_string: running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: Job_Status
          - FAILURE: on_failure
  outputs:
    - JobStatus: '${JobStatus}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Job_Status:
        x: 158
        'y': 151
      Is_status_successful:
        x: 384
        'y': 161
        navigate:
          b4a458d2-013b-70e7-eca1-a8f28f2d8794:
            targetId: 16669dff-554d-a24f-6d6f-39e30c8c1c8d
            port: SUCCESS
      Is_status_failed:
        x: 390
        'y': 355
        navigate:
          99d177f2-d2f1-fbf6-c6b9-e23b86005560:
            targetId: bb28f55c-281b-8d13-71da-cec8a32fa709
            port: SUCCESS
      Is_status_pending:
        x: 388
        'y': 556
      Is_status_runnning:
        x: 172
        'y': 554
      sleep:
        x: 167
        'y': 345
    results:
      FAILURE:
        bb28f55c-281b-8d13-71da-cec8a32fa709:
          x: 654
          'y': 348
      SUCCESS:
        16669dff-554d-a24f-6d6f-39e30c8c1c8d:
          x: 656
          'y': 159
