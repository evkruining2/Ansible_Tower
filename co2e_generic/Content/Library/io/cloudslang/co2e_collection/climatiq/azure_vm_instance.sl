########################################################################################################################
#!!
#! @description: Calculates the average CO2e per 24hr based on the number of CPUs and memory of the Azure instance and its location
#!
#! @input climatiq_url: Climatiq.io API URL. Example: https://beta3.api.climatiq.io
#! @input climatiq_token: Climatiq.io API access token
#! @input provider: Name of the cloud provider to use. Example: azure
#! @input region: Region of the cloud provider to use. Example: useast1
#! @input cpu_count: Number of CPUs to calculate the CO2e for
#! @input memory: Amount of memory (MB) to calculate the CO2e for
#! @input storage_amount: Amount of storage (GB)
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input worker_group: Optional - RAS worker group to use. Default: RAS_Operator_Path
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#!
#! @output total_co2e: Cumulative CO2e for this instance
#!!#
########################################################################################################################
namespace: io.cloudslang.co2e_collection.climatiq
flow:
  name: azure_vm_instance
  inputs:
    - climatiq_url: "${get_sp('io.cloudslang.co2e_collection.climatiq_url')}"
    - climatiq_token:
        default: "${get_sp('io.cloudslang.co2e_collection.climatiq_token')}"
        sensitive: true
    - provider: azure
    - region
    - cpu_count
    - memory
    - storage_amount
    - trust_all_roots:
        default: "${get_sp('io.cloudslang.co2e_collection.trust_all_roots')}"
        required: false
    - x_509_hostname_verifier:
        default: "${get_sp('io.cloudslang.co2e_collection.x_509_hostname_verifier')}"
        required: false
    - worker_group:
        default: "${get_sp('io.cloudslang.co2e_collection.worker_group')}"
        required: false
    - proxy_host:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_host')}"
        required: false
    - proxy_port:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_port')}"
        required: false
    - proxy_username:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_username')}"
        required: false
    - proxy_password:
        default: "${get_sp('io.cloudslang.co2e_collection.proxy_password')}"
        required: false
        sensitive: true
  workflow:
    - calculate_co2e_cpu:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.climatiq.calculate_co2e_cpu:
            - climatiq_url: '${climatiq_url}'
            - climatiq_token: '${climatiq_token}'
            - provider: '${provider}'
            - region: '${region}'
            - cpu_count: '${cpu_count}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - worker_group: '${worker_group}'
        publish:
          - co2e
          - total_co2e: '0'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers
    - add_numbers:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: calculate_co2e_memory_1
          - FAILURE: on_failure
    - add_numbers_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: calculate_co2e_storage
          - FAILURE: on_failure
    - calculate_co2e_memory_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.climatiq.calculate_co2e_memory:
            - climatiq_url: '${climatiq_url}'
            - climatiq_token: '${climatiq_token}'
            - provider: '${provider}'
            - region: '${region}'
            - memory: '${memory}'
            - data_unit: MB
            - worker_group: '${worker_group}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - hostname_verifier: '${x_509_hostname_verifier}'
        publish:
          - co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers_1
    - calculate_co2e_storage:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.co2e_collection.climatiq.calculate_co2e_storage:
            - climatiq_url: '${climatiq_url}'
            - climatiq_token: '${climatiq_token}'
            - provider: '${provider}'
            - region: '${region}'
            - storage_amount: '${storage_amount}'
            - trust_all_roots: '${trust_all_roots}'
            - hostname_verifier: '${x_509_hostname_verifier}'
        publish:
          - co2e
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_numbers_1_1
    - add_numbers_1_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${total_co2e}'
            - value2: '${co2e}'
        publish:
          - total_co2e: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - total_co2e: '${total_co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      calculate_co2e_cpu:
        x: 120
        'y': 80
      add_numbers:
        x: 120
        'y': 280
      add_numbers_1:
        x: 320
        'y': 280
      calculate_co2e_memory_1:
        x: 320
        'y': 80
      calculate_co2e_storage:
        x: 520
        'y': 80
      add_numbers_1_1:
        x: 520
        'y': 280
        navigate:
          8d85ce71-b8de-b4c7-7635-cc09e592e69e:
            targetId: 86ef6df4-a299-8026-ab07-c27c49b8adb4
            port: SUCCESS
    results:
      SUCCESS:
        86ef6df4-a299-8026-ab07-c27c49b8adb4:
          x: 720
          'y': 160
