########################################################################################################################
#!!
#! @description: This workflow uses the Random User Generator (https://randomuser.me) web service, a free, open-source API for generating random user data. Like Lorem Ipsum, but for people, useful to generate random user data for application testing.
#!                
#!               The flow will save the user list in XML format on the given (local) file system: 
#!                
#!               number of users: the amount of users you want to generate
#!               nationality: You can request a different nationality of a randomuser.
#!               filepath: The path and filename of the output xml file
#!
#! @input number_of_users: Random User Generator allows you to fetch up to 5,000 generated users in one request
#! @input nationality: You can request a different nationality of a randomuser. Currently, randomuser offers these nationalities: AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NO, NL, NZ, TR, US. Use at least one of these country codes but you can mix them around too
#! @input filepath: The path and filename to store the userdata in XML format. Example: c:\temp\randomusers.xml
#!!#
########################################################################################################################
namespace: random_users
flow:
  name: Generate_random_users_to_XML_file
  inputs:
    - number_of_users: '5'
    - nationality:
        default: 'nl,us,gb'
        required: true
    - filepath: "c:\\Temp\\randomusers.xml"
  workflow:
    - request_randomusers:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://randomuser.me/api/?format=xml&nat='+nationality+'&results='+number_of_users}"
            - auth_type: anonymous
        publish:
          - xml_result: '${return_result}'
        navigate:
          - SUCCESS: write_to_xml_file
          - FAILURE: on_failure
    - write_to_xml_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: '${filepath}'
            - text: '${xml_result}'
            - encode_type: utf_8
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      request_randomusers:
        x: 87
        'y': 74
      write_to_xml_file:
        x: 288
        'y': 109
        navigate:
          d890ae4b-541b-d8f1-49a1-41a919c20eef:
            targetId: 17c290db-cae9-a690-7bba-72d6c17aa2c0
            port: SUCCESS
    results:
      SUCCESS:
        17c290db-cae9-a690-7bba-72d6c17aa2c0:
          x: 470
          'y': 77
