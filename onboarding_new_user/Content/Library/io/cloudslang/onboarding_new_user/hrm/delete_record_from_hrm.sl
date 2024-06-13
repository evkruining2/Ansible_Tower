namespace: io.cloudslang.onboarding_new_user.hrm
flow:
  name: delete_record_from_hrm
  inputs:
    - employee_id
    - hrm_url: 'https://10.0.10.118/orangehrm-4.6/symfony/web/index.php'
  workflow:
    - get_token_from_hrm:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${hrm_url+'/oauth/issueToken'}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: 'Content-Type:application/json'
            - body: |-
                ${{"grant_type":"client_credentials",
                "client_id":"oo",
                "client_secret":"oo"}}
        publish:
          - return_result
        navigate:
          - SUCCESS: filter_token
          - FAILURE: on_failure
    - search_for_id:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://10.0.10.118/orangehrm-4.6/symfony/web/index.php/api/v1/employee/search?code='+employee_id}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'Authorization: Bearer '+token}"
            - content_type: application/json
        publish:
          - return_result
        navigate:
          - SUCCESS: filter_id
          - FAILURE: on_failure
    - delete_record_in_mysql:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: guac.museumhof.net
            - command: "${'mysql -h 10.0.10.118 -u root -popsware -D orangehrm_mysql -e \"DELETE FROM hs_hr_employee WHERE hs_hr_employee.emp_number = '+db_id+'\"'}"
            - username: root
            - password:
                value: opsware
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - filter_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.data..employeeId
        publish:
          - db_id: "${return_result.strip('\"').strip('[').strip(']')}"
        navigate:
          - SUCCESS: delete_record_in_mysql
          - FAILURE: on_failure
    - filter_token:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.access_token
        publish:
          - token: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: search_for_id
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      filter_id:
        x: 280
        'y': 480
      filter_token:
        x: 80
        'y': 280
      search_for_id:
        x: 80
        'y': 480
      get_token_from_hrm:
        x: 80
        'y': 80
      delete_record_in_mysql:
        x: 280
        'y': 280
        navigate:
          4228e111-d0b7-7258-6684-5cdac3bf16a8:
            targetId: 33e9bca2-2892-e174-9215-033bc0a82be2
            port: SUCCESS
    results:
      SUCCESS:
        33e9bca2-2892-e174-9215-033bc0a82be2:
          x: 520
          'y': 280
