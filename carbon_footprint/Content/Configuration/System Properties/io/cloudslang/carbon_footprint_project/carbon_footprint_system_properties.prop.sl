########################################################################################################################
#!!
#! @system_property climatiq_url: Climatiq API URL
#! @system_property climatiq_token: Climatiq token to get access to the API
#! @system_property provider_uuid: Energy provider uuid according to Climatiq for the off-cloud data center
#! @system_property azure_subscription_id: The Azure Subsciption ID
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project
properties:
  - proxy_host: ''
  - proxy_port: ''
  - worker_group: RAS_Operator_Path
  - climatiq_url:
      value: 'https://beta3.api.climatiq.io'
      sensitive: false
  - climatiq_token:
      value: Y3Q5BATS8TM2ARKBB18Y8MN95HX1
      sensitive: false
  - provider_uuid:
      value: 0bd33651-72bd-4b1d-ad84-8cacaf574b5e
      sensitive: false
  - azure_subscription_id:
      value: 4d08f192-8c63-49fa-a461-5cdd32ce42dc
      sensitive: false
