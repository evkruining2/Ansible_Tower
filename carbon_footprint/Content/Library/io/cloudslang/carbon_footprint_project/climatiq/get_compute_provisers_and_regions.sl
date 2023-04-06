########################################################################################################################
#!!
#! @input climatiq_url: Climatic url
#!!#
########################################################################################################################
namespace: io.cloudslang.carbon_footprint_project.climatiq
flow:
  name: get_compute_provisers_and_regions
  inputs:
    - climatiq_url: 'https://beta3.api.climatiq.io/compute'
    - climatiq_token: Y3Q5BATS8TM2ARKBB18Y8MN95HX1
  workflow:
    - http_client_get:
        worker_group:
          value: "${get_sp('io.cloudslang.carbon_footprint_project.worker_group')}"
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${climatiq_url}'
            - proxy_host: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.carbon_footprint_project.proxy_port')}"
            - headers: "${'Authorization: Bearer '+climatiq_token}"
        publish:
          - json_result: '${return_result}'
        navigate:
          - SUCCESS: get_aws_cpu_regions
          - FAILURE: on_failure
    - get_aws_cpu_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.aws.cpu_regions
        publish:
          - aws_cpu_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_gcp_cpu_regions
          - FAILURE: on_failure
    - get_aws_memory_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.aws.memory_regions
        publish:
          - aws_memory_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_gcp_memory_regions
          - FAILURE: on_failure
    - get_aws_storage_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.aws.storage_regions
        publish:
          - aws_storage_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_gcp_storage_regions
          - FAILURE: on_failure
    - get_gcp_cpu_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.gcp.cpu_regions
        publish:
          - gcp_cpu_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_azure_cpu_regions
          - FAILURE: on_failure
    - get_azure_cpu_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.azure.cpu_regions
        publish:
          - azure_cpu_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_aws_memory_regions
          - FAILURE: on_failure
    - get_gcp_memory_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.gcp.memory_regions
        publish:
          - gcp_memory_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_azure_memory_regions
          - FAILURE: on_failure
    - get_azure_memory_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.azure.memory_regions
        publish:
          - azure_memory_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_aws_storage_regions
          - FAILURE: on_failure
    - get_gcp_storage_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.gcp.storage_regions
        publish:
          - gcp_storage_regions: "${cs_replace(return_result.strip('[').strip(']'),'\"','',)}"
        navigate:
          - SUCCESS: get_azure_storage_regions
          - FAILURE: on_failure
    - get_azure_storage_regions:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: $.cloud_providers.azure.storage_regions
        publish:
          - azure_storage_regions: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - aws_cpu_regions: '${aws_cpu_regions}'
    - gcp_cpu_regions: '${gcp_cpu_regions}'
    - azure_cpu_regions: '${azure_cpu_regions}'
    - aws_memory_regions: '${aws_memory_regions}'
    - gcp_memory_regions: '${gcp_memory_regions}'
    - azure_memory_regions: '${azure_memory_regions}'
    - aws_storage_regions: '${aws_storage_regions}'
    - gcp_storage_regions: '${gcp_storage_regions}'
    - azure_storage_regions: '${azure_storage_regions}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_azure_storage_regions:
        x: 640
        'y': 400
        navigate:
          42c89ea8-9119-b800-2d73-20e706e086e7:
            targetId: 2c2d10db-e888-e3ba-f167-e60ab32ee826
            port: SUCCESS
      get_gcp_storage_regions:
        x: 440
        'y': 400
      get_aws_memory_regions:
        x: 240
        'y': 240
      get_azure_cpu_regions:
        x: 240
        'y': 400
      get_aws_storage_regions:
        x: 440
        'y': 240
      get_gcp_cpu_regions:
        x: 40
        'y': 400
      get_gcp_memory_regions:
        x: 240
        'y': 80
      http_client_get:
        x: 40
        'y': 80
      get_azure_memory_regions:
        x: 440
        'y': 80
      get_aws_cpu_regions:
        x: 40
        'y': 240
    results:
      SUCCESS:
        2c2d10db-e888-e3ba-f167-e60ab32ee826:
          x: 640
          'y': 240
