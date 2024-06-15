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
  name: create_html_chart
  inputs:
    - host: "${get_sp('easyenergy_project.web_host')}"
    - username: "${get_sp('easyenergy_project.web_host_user')}"
    - password:
        default: "${get_sp('easyenergy_project.web_host_password')}"
        sensitive: true
    - tariff_list
    - date
  workflow:
    - set_date_in_html:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'''sed -i \"s/easyEnergy stroom tarieven voor.*/easyEnergy stroom tarieven voor '''+date+'''/g\" /var/www/virtual/opsware.nl/easyenergy/index.html'''}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: place_tariff_data_in_html
          - FAILURE: on_failure
    - place_tariff_data_in_html:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'sed -i \"s/data: \\[.*/data: \\['+tariff_list+'\\],/g\" /var/www/virtual/opsware.nl/easyenergy/index.html'}"
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
      place_tariff_data_in_html:
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
