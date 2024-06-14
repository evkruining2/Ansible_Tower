namespace: io.cloudslang.energy_project.email_and_html_reports
flow:
  name: email_tariff_information
  inputs:
    - users: 'Erwin,Rilana'
    - tariff_list
    - date
  workflow:
    - set_flow_variables:
        do:
          io.cloudslang.energy_project.tools.set_flow_variables:
            - list: '${tariff_list}'
        publish:
          - h0
          - h1
          - h2
          - h3
          - h4
          - h5
          - h6
          - h7
          - h8
          - h9
          - h10
          - h11
          - h12
          - h13
          - h14
          - h15
          - h16
          - h17
          - h18
          - h19
          - h20
          - h21
          - h22
          - h23
        navigate:
          - SUCCESS: send_mail
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
                        bgcolor="#ff9200">
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
                      Met vriendelijke groeten,<br>
                      Uw easyEneryBot - powered by Operations Orchestration<br>
                      <br>
                      <table width="100%" cellspacing="2" cellpadding="2" border="0">
                        <tbody>
                          <tr>
                            <td valign="top" bgcolor="#ff9200"><br>
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
    results:
      SUCCESS:
        f4ee02f9-c25f-3833-a02e-8d30fd92c165:
          x: 520
          'y': 120
