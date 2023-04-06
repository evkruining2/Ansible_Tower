########################################################################################################################
#!!
#! @description: For future release
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input scopes: Scopes that you might need to request to access Google Compute APIs, depending on the level of access
#!                you need. One or more scopes may be specified delimited by the scopes_delimiter.
#!                Example: 'https://www.googleapis.com/auth/compute.readonly'
#!                Note: It is recommended to use the minimum necessary scope in order to perform the requests.
#!                For a full list of scopes see https://developers.google.com/identity/protocols/googlescopes#computev1
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.gcp
flow:
  name: collect_co2e_for_gcp_project
  inputs:
    - json_token:
        sensitive: true
    - scopes
  workflow:
    - get_access_token:
        do:
          io.cloudslang.google.authentication.get_access_token:
            - json_token:
                value: '${json_token}'
                sensitive: true
            - scopes: '${scopes}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_access_token:
        x: 120
        'y': 120
        navigate:
          0c76b5c0-a44c-9e7e-0fa5-d1aa4bea5bf3:
            targetId: afe5f3d8-ef48-2832-7678-e02d306a8bd0
            port: SUCCESS
    results:
      SUCCESS:
        afe5f3d8-ef48-2832-7678-e02d306a8bd0:
          x: 320
          'y': 120
