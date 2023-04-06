########################################################################################################################
#!!
#! @description: Place one record in the ODL table
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project.optic_data_lake
flow:
  name: odl_load_data
  inputs:
    - odl_url: 'https://optic.advantageinc.org:30001/itom-data-ingestion-receiver'
    - schema_name: dcoe_esg
    - timestamp
    - scope2_co2e
    - scope3_co2e: '0'
    - powerusage
    - cmdb_id:
        default: '0'
        required: true
    - cmdb_global_id:
        default: '0'
        required: true
    - node_fqdn
    - node_ip_address
    - cpu_util_avg: '0'
    - cloudvendor:
        default: ' '
        required: false
    - cloudregion:
        default: ' '
        required: false
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - get_token:
        do:
          io.cloudslang.carbon_footprint_project.optic_data_lake.get_token:
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
        publish:
          - token
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: on_failure
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${odl_url}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: "${'Authorization: Bearer '+token+'\\r\\nx-monitoredcollection: '+schema_name}"
            - body: "${'{'+\\\n'   \"timestamp_utc_s\": '+timestamp+','+\\\n'   \"scope2_co2e\": '+scope2_co2e+','+\\\n'   \"scope3_co2e\": '+scope3_co2e+','+\\\n'   \"powerUsage\": '+powerusage+','+\\\n'   \"cmdb_id\": \"'+cmdb_id+'\",'+\\\n'   \"cmdb_global_id\": \"'+cmdb_global_id+'\",'+\\\n'   \"node_fqdn\": \"'+node_fqdn+'\",'+\\\n'   \"node_ip_address\": \"'+node_ip_address+'\",'+\\\n'   \"cloudvendor\": \"'+cloudvendor+'\",'+\\\n'   \"cloudregion\": \"'+cloudregion+'\",'+\\\n'   \"cpu_util_avg\": \"'+cpu_util_avg+'\"'+\\\n'}'}"
            - content_type: application/json
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - odl_result: '${return_result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_token:
        x: 120
        'y': 120
      http_client_post:
        x: 320
        'y': 201
        navigate:
          4433f714-c162-1864-bf32-8490afa36836:
            targetId: f56b79ea-ffbb-8d3b-7ca5-f9e0c05748ad
            port: SUCCESS
    results:
      SUCCESS:
        f56b79ea-ffbb-8d3b-7ca5-f9e0c05748ad:
          x: 520
          'y': 200

