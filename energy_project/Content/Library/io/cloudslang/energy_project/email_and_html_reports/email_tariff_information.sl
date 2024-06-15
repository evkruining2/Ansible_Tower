namespace: io.cloudslang.energy_project.email_and_html_reports
flow:
  name: email_tariff_information
  inputs:
    - users: 'Erwin,Rilana'
    - tariff_list
    - date
    - lowest_tariff
  workflow:
    - set_flow_variables:
        do:
          io.cloudslang.energy_project.tools.set_flow_variables:
            - list: '${tariff_list}'
            - lowest_tariff: '${lowest_tariff}'
        publish:
          - h0: "${cs_replace(h0,lowest_tariff,'<b>'+h0+'</b>')}"
          - h1: "${cs_replace(h1,lowest_tariff,'<b>'+h1+'</b>')}"
          - h2: "${cs_replace(h2,lowest_tariff,'<b>'+h2+'</b>')}"
          - h3: "${cs_replace(h3,lowest_tariff,'<b>'+h3+'</b>')}"
          - h4: "${cs_replace(h4,lowest_tariff,'<b>'+h4+'</b>')}"
          - h5: "${cs_replace(h5,lowest_tariff,'<b>'+h5+'</b>')}"
          - h6: "${cs_replace(h6,lowest_tariff,'<b>'+h6+'</b>')}"
          - h7: "${cs_replace(h7,lowest_tariff,'<b>'+h7+'</b>')}"
          - h8: "${cs_replace(h8,lowest_tariff,'<b>'+h8+'</b>')}"
          - h9: "${cs_replace(h9,lowest_tariff,'<b>'+h9+'</b>')}"
          - h10: "${cs_replace(h10,lowest_tariff,'<b>'+h10+'</b>')}"
          - h11: "${cs_replace(h11,lowest_tariff,'<b>'+h11+'</b>')}"
          - h12: "${cs_replace(h12,lowest_tariff,'<b>'+h12+'</b>')}"
          - h13: "${cs_replace(h13,lowest_tariff,'<b>'+h13+'</b>')}"
          - h14: "${cs_replace(h14,lowest_tariff,'<b>'+h14+'</b>')}"
          - h15: "${cs_replace(h15,lowest_tariff,'<b>'+h15+'</b>')}"
          - h16: "${cs_replace(h16,lowest_tariff,'<b>'+h16+'</b>')}"
          - h17: "${cs_replace(h17,lowest_tariff,'<b>'+h17+'</b>')}"
          - h18: "${cs_replace(h18,lowest_tariff,'<b>'+h18+'</b>')}"
          - h19: "${cs_replace(h19,lowest_tariff,'<b>'+h19+'</b>')}"
          - h20: "${cs_replace(h20,lowest_tariff,'<b>'+h20+'</b>')}"
          - h21: "${cs_replace(h21,lowest_tariff,'<b>'+h21+'</b>')}"
          - h22: "${cs_replace(h22,lowest_tariff,'<b>'+h22+'</b>')}"
          - h23: "${cs_replace(h23,lowest_tariff,'<b>'+h23+'</b>')}"
        navigate:
          - SUCCESS: get_cheapest_hour
    - send_mail:
        loop:
          for: user in users
          do:
            io.cloudslang.base.mail.send_mail:
              - hostname: m2
              - port: '25'
              - from: easyEnergyBot@opsware.nl
              - to: '${cs_replace(cs_to_lower(cs_replace(cs_to_lower(user),"rilana","rilanavandergaag@gmail.com")),"erwin","erwin@opsware.nl")}'
              - subject: "${'easyEnergy tarieven voor '+date}"
              - body: |-
                  ${'''
                  <!DOCTYPE html>
                  <html>
                    <head>

                      <meta http-equiv="content-type" content="text/html; charset=UTF-8">
                      <title></title>
                    </head>
                    <body>
                      <table width="100%" cellspacing="2" cellpadding="2" border="0"
                        bgcolor="#ff6600">
                        <tbody>
                          <tr>
                            <td valign="top"><br>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <br>
                      Beste '''+user+''', hier zijn de easyEnergy tarieven voor morgen, '''+date+''':<br>
                      <br>
                      <table width="100%" cellspacing="2" cellpadding="2" border="1">
                        <tbody>
                          <tr>
                            <td valign="top">0:00<br>
                            </td>
                            <td valign="top">'''+h0+'''<br>
                            </td>
                            <td valign="top">12:00<br>
                            </td>
                            <td valign="top">'''+h12+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">1:00<br>
                            </td>
                            <td valign="top">'''+h1+'''<br>
                            </td>
                            <td valign="top">13:00<br>
                            </td>
                            <td valign="top">'''+h13+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">2:00<br>
                            </td>
                            <td valign="top">'''+h2+'''<br>
                            </td>
                            <td valign="top">14:00<br>
                            </td>
                            <td valign="top">'''+h14+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">3:00<br>
                            </td>
                            <td valign="top">'''+h3+'''<br>
                            </td>
                            <td valign="top">15:00<br>
                            </td>
                            <td valign="top">'''+h15+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">4:00<br>
                            </td>
                            <td valign="top">'''+h4+'''<br>
                            </td>
                            <td valign="top">16:00<br>
                            </td>
                            <td valign="top">'''+h16+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">5:00<br>
                            </td>
                            <td valign="top">'''+h5+'''<br>
                            </td>
                            <td valign="top">17:00<br>
                            </td>
                            <td valign="top">'''+h17+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">6:00<br>
                            </td>
                            <td valign="top">'''+h6+'''<br>
                            </td>
                            <td valign="top">18:00<br>
                            </td>
                            <td valign="top">'''+h18+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">7:00<br>
                            </td>
                            <td valign="top">'''+h7+'''<br>
                            </td>
                            <td valign="top">19:00<br>
                            </td>
                            <td valign="top">'''+h19+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">8:00<br>
                            </td>
                            <td valign="top">'''+h8+'''<br>
                            </td>
                            <td valign="top">20:00<br>
                            </td>
                            <td valign="top">'''+h20+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">9:00<br>
                            </td>
                            <td valign="top">'''+h9+'''<br>
                            </td>
                            <td valign="top">21:00<br>
                            </td>
                            <td valign="top">'''+h21+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">10:00<br>
                            </td>
                            <td valign="top">'''+h10+'''<br>
                            </td>
                            <td valign="top">22:00<br>
                            </td>
                            <td valign="top">'''+h22+'''<br>
                            </td>
                          </tr>
                          <tr>
                            <td valign="top">11:00<br>
                            </td>
                            <td valign="top">'''+h11+'''<br>
                            </td>
                            <td valign="top">23:00<br>
                            </td>
                            <td valign="top">'''+h23+'''<br>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <br>
                      <a href="https://opsware.nl/easyenergy/index.html">Klik hier voor de
                        grafiek</a><br>
                      <br>
                      Het meest voordelige tarief voor morgen is om '''+hour+''':00 uur want dan is het tarief <b>€'''+lowest_tariff+'''</b> per Kwh!<br>
                      <br>
                      Met vriendelijke groeten,<br>
                      Uw easyEneryBot - powered by Operations Orchestration<br>
                      <br>
                      <table width="100%" cellspacing="2" cellpadding="2" border="0">
                        <tbody>
                          <tr>
                            <td valign="top" bgcolor="#ff6600"><br>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <br>
                    </body>
                  </html>

                  '''}
              - html_email: 'true'
          break:
            - FAILURE
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_cheapest_hour:
        do:
          io.cloudslang.base.lists.find_all:
            - list: '${tariff_list}'
            - element: '${lowest_tariff}'
        publish:
          - hour: '${indices}'
        navigate:
          - SUCCESS: send_mail
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_flow_variables:
        x: 80
        'y': 120
      send_mail:
        x: 280
        'y': 120
        navigate:
          1a39a656-3146-5530-4852-3fc8fcaefed1:
            targetId: f4ee02f9-c25f-3833-a02e-8d30fd92c165
            port: SUCCESS
      get_cheapest_hour:
        x: 120
        'y': 400
    results:
      SUCCESS:
        f4ee02f9-c25f-3833-a02e-8d30fd92c165:
          x: 520
          'y': 120
