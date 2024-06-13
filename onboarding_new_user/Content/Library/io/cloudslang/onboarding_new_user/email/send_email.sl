########################################################################################################################
#!!
#! @input smtp_server: The hostname or ip address of the smtp server.
#! @input port: The port of the smtp service.
#! @input email_from: From email address.
#! @input email_to: A delimiter separated list of email address(es) or recipients where the email will be sent.
#! @input subject: The email subject. If a subject spans on multiple lines, it is formatted to a single one.
#! @input body: The body of the email.
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user.email
flow:
  name: send_email
  inputs:
    - smtp_server: mail.example.com
    - port: '25'
    - email_from: administrator@example.com
    - email_to: erwin@example.com
    - subject
    - body
  workflow:
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: '${smtp_server}'
            - port: '${port}'
            - from: '${email_from}'
            - to: '${email_to}'
            - subject: '${subject}'
            - body: '${body}'
            - html_email: 'false'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      send_mail:
        x: 160
        'y': 200
        navigate:
          371b48eb-2992-79cf-54b7-9c7ec774abe3:
            targetId: 01191957-a25a-3c19-54d5-fbdf81684845
            port: SUCCESS
    results:
      SUCCESS:
        01191957-a25a-3c19-54d5-fbdf81684845:
          x: 440
          'y': 240
