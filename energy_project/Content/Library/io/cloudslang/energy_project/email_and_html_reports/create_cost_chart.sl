########################################################################################################################
#!!
#! @input host: Hostname or IP address.
#! @input username: Username to connect as.
#! @input password: Password of user.
#!                  Optional
#!!#
########################################################################################################################
namespace: io.cloudslang.energy_project.email_and_html_reports
flow:
  name: create_cost_chart
  inputs:
    - host: "${get_sp('easyenergy_project.web_host')}"
    - username: "${get_sp('easyenergy_project.web_host_user')}"
    - password:
        default: "${get_sp('easyenergy_project.web_host_password')}"
        sensitive: true
    - cost_list: '0.0213,0.0194,0.0157,0.0123,0.0105,0.0152,0.0169,0.0126,0.0118,0.0127,0.0131,-0.0755,-0.0795,-0.1168,-0.0546,0.0167,0.0223,0.0205,0.0164,0.0217,0.021,0.0171,0.0138,0.0136'
    - date: 9 maart 2024
  workflow:
    - set_date_in_html:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'''sed -i \"s/Stroomkosten voor.*/Stroomkosten voor '''+date+'''/g\" /var/www/virtual/opsware.nl/easyenergy/cost.html'''}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: place_cost_data_in_html
          - FAILURE: on_failure
    - place_cost_data_in_html:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'sed -i \"s/data: \\[.*/data: \\['+cost_list+'\\],/g\" /var/www/virtual/opsware.nl/easyenergy/cost.html'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_date_in_html:
        x: 80
        'y': 80
      place_cost_data_in_html:
        x: 280
        'y': 80
        navigate:
          5561208c-e85e-c2ff-3a9d-8cca27198245:
            targetId: 08d8b302-9878-5dd0-8b89-03698f7eb081
            port: SUCCESS
    results:
      SUCCESS:
        08d8b302-9878-5dd0-8b89-03698f7eb081:
          x: 480
          'y': 80
