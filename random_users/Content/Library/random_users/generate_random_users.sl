########################################################################################################################
#!!
#! @description: This workflow uses the Random User Generator (https://randomuser.me) web service, a free, open-source API for generating random user data. Like Lorem Ipsum, but for people, useful to generate random user data for application testing.
#!                
#!               The flow has two inputs: 
#!                
#!               number of users: the amount of users you want to generate
#!               nationality: You can request a different nationality of a randomuser.
#!                
#!               The flow doesn't do anything in particular other than pushing the user properties in flow variables for further processing. So if you want to populate a database, PAM, AD or a mail system with these ramdomusers, you'll have to add some operations to the flow to make that happen.
#!
#! @input number_of_users: Random User Generator allows you to fetch up to 5,000 generated users in one request
#! @input nationality: You can request a different nationality of a randomuser. Currently, randomuser offers these nationalities: AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NO, NL, NZ, TR, US. Use at least one of these country codes but you can mix them around too
#!!#
########################################################################################################################
namespace: random_users
flow:
  name: Generate_random_users
  inputs:
    - number_of_users: '5'
    - nationality:
        default: 'nl,us,gb'
        required: true
  workflow:
    - request_randomusers:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://randomuser.me/api/?nat='+nationality+'&results='+number_of_users}"
            - auth_type: anonymous
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: Create_list_of_indices
          - FAILURE: on_failure
    - Do_all_kinds_of_stuff:
        do:
          io.cloudslang.base.utils.do_nothing: []
        navigate:
          - SUCCESS: cycle_through_randomusers_arrays
          - FAILURE: on_failure
    - Create_list_of_indices:
        do:
          io.cloudslang.base.utils.do_nothing:
            - li: '${number_of_users}'
        publish:
          - li: "${str(list(range(int(li)))).strip('[').strip(']').replace(' ','')}"
          - list: '${li}'
        navigate:
          - SUCCESS: cycle_through_randomusers_arrays
          - FAILURE: on_failure
    - cycle_through_randomusers_arrays:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${list}'
            - separator: ','
        publish:
          - index: '${result_string}'
        navigate:
          - HAS_MORE: Set_Flow_Variables
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - Set_Flow_Variables:
        do:
          Randomusers.Set_Flow_Variables:
            - json_list: '${json_result}'
            - index: '${index}'
        publish:
          - name_first
          - name_last
          - email
        navigate:
          - SUCCESS: Do_all_kinds_of_stuff
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      request_randomusers:
        x: 87
        'y': 74
      cycle_through_randomusers_arrays:
        x: 474
        'y': 82
        navigate:
          19beb09e-51d9-278c-a0c5-053457f7343c:
            targetId: 17c290db-cae9-a690-7bba-72d6c17aa2c0
            port: NO_MORE
      Do_all_kinds_of_stuff:
        x: 476
        'y': 428
      Create_list_of_indices:
        x: 287
        'y': 77
      Set_Flow_Variables:
        x: 287
        'y': 263
    results:
      SUCCESS:
        17c290db-cae9-a690-7bba-72d6c17aa2c0:
          x: 672
          'y': 80
