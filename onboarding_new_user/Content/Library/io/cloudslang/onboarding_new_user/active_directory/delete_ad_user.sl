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
  name: delete_ad_user
  inputs:
    - ad_host: "${get_sp('onboarding.ad_server')}"
    - ad_username: "${get_sp('onboarding.ad_user')}"
    - ad_password:
        default: "${get_sp('onboarding.ad_password')}"
        sensitive: true
    - distinguished_name: 'cn=users,dc=example,dc=com'
    - first_name
    - last_name
  workflow:
    - delete_user:
        do:
          io.cloudslang.base.active_directory.users.delete_user:
            - host: '${ad_host}'
            - username: '${ad_username}'
            - password:
                value: '${ad_password}'
                sensitive: true
            - distinguished_name: '${distinguished_name}'
            - user_common_name: "${first_name+' '+last_name}"
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
      delete_user:
        x: 80
        'y': 120
        navigate:
          37fd0f35-f158-7f6a-9f17-d004d24406e4:
            targetId: 4f7fead8-2e47-4134-d409-0ff6badfabc7
            port: SUCCESS
    results:
      SUCCESS:
        4f7fead8-2e47-4134-d409-0ff6badfabc7:
          x: 400
          'y': 120
