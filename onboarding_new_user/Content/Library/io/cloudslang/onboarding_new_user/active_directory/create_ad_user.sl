########################################################################################################################
#!!
#! @input ad_host: The domain controller to connect to.
#! @input ad_username: The user to connect to Active Directory as.
#! @input ad_password: The password of the user to connect to Active Directory.
#! @input distinguished_name: The Organizational Unit DN or Common Name DN to add the user to.
#!                            Example: OU=OUTest1,DC=battleground,DC=ad.
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user.active_directory
flow:
  name: create_ad_user
  inputs:
    - ad_host: "${get_sp('onboarding.ad_server')}"
    - ad_username: "${get_sp('onboarding.ad_user')}"
    - ad_password:
        default: "${get_sp('onboarding.ad_password')}"
        sensitive: true
    - distinguished_name: 'cn=users,dc=example,dc=com'
    - first_name
    - last_name
    - login_name
    - email_address
    - employee_id
    - phone_number
  workflow:
    - create_user:
        do:
          io.cloudslang.base.active_directory.users.create_user:
            - host: '${ad_host}'
            - username: '${ad_username}'
            - password:
                value: '${ad_password}'
                sensitive: true
            - distinguished_name: '${distinguished_name}'
            - user_common_name: "${first_name+' '+last_name}"
            - user_password:
                value: '${ad_password}'
                sensitive: true
            - sam_account_name: '${login_name}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: update_user_details
          - FAILURE: on_failure
    - update_user_details:
        do:
          io.cloudslang.base.active_directory.users.update_user_details:
            - host: '${ad_host}'
            - username: '${ad_username}'
            - password:
                value: '${ad_password}'
                sensitive: true
            - distinguished_name: '${distinguished_name}'
            - user_common_name: "${first_name+' '+last_name}"
            - first_name: '${first_name}'
            - last_name: '${last_name}'
            - display_name: "${first_name+' '+last_name}"
            - attributes_list: "${'description:User created by OO\\ntelephoneNumber:'+phone_number+'\\nmail:'+email_address+'\\nemployeeID:'+employee_id+'\\nemployeeNumber:'+employee_id+'\\n'}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_user:
        x: 80
        'y': 120
      update_user_details:
        x: 280
        'y': 120
        navigate:
          ce9e9fa5-574f-7444-fe02-a3ef4fa6f43b:
            targetId: 4f7fead8-2e47-4134-d409-0ff6badfabc7
            port: SUCCESS
    results:
      SUCCESS:
        4f7fead8-2e47-4134-d409-0ff6badfabc7:
          x: 520
          'y': 120
