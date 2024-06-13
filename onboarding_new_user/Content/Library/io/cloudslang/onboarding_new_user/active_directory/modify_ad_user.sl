########################################################################################################################
#!!
#! @input ad_host: The domain controller to connect to.
#! @input ad_username: The user to connect to Active Directory as.
#! @input ad_password: The password of the user to connect to Active Directory.
#! @input distinguished_name: The Organizational Unit DN of the user to set attributes to.
#!                            Example: OU=OUTest1,DC=battleground,DC=ad.
#! @input first_name: User first name to change.
#!                    Optional
#! @input last_name: User last name to change.
#!                   Optional
#!!#
########################################################################################################################
namespace: io.cloudslang.onboarding_new_user.active_directory
flow:
  name: modify_ad_user
  inputs:
    - ad_host: "${get_sp('ad_server')}"
    - ad_username: "${get_sp('ad_user')}"
    - ad_password:
        default: "${get_sp('ad_password')}"
        sensitive: true
    - distinguished_name: 'cn=users,dc=example,dc=com'
    - original_name
    - first_name
    - last_name
    - login_name
    - email_address
    - phone_number
    - employee_id
  workflow:
    - update_user_details:
        do:
          io.cloudslang.base.active_directory.users.update_user_details:
            - host: '${ad_host}'
            - username: '${ad_username}'
            - password:
                value: '${ad_password}'
                sensitive: true
            - distinguished_name: '${distinguished_name}'
            - user_common_name: '${original_name}'
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
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      update_user_details:
        x: 240
        'y': 240
        navigate:
          53984a92-8e82-71a8-d00f-b39b7f43cb94:
            targetId: 9c342547-0d42-dee8-c2de-da6da28151df
            port: SUCCESS
    results:
      SUCCESS:
        9c342547-0d42-dee8-c2de-da6da28151df:
          x: 440
          'y': 240
