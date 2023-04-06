namespace: io.cloudslang.carbon_footprint_project.azure
flow:
  name: query_vm_details
  inputs:
    - image_name
  workflow:
    - get_azure_vm_sizes:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - json_result: |-
              ${'''
              {
                  "value": [
                      {
                          "name": "Standard_A0",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 20480,
                          "memoryInMB": 768,
                          "maxDataDiskCount": 1
                      },
                      {
                          "name": "Standard_A1",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 71680,
                          "memoryInMB": 1792,
                          "maxDataDiskCount": 2
                      },
                      {
                          "name": "Standard_A2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 138240,
                          "memoryInMB": 3584,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_A3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 291840,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_A5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 138240,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_A4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 619520,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_A6",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 291840,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_A7",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 619520,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Basic_A0",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 20480,
                          "memoryInMB": 768,
                          "maxDataDiskCount": 1
                      },
                      {
                          "name": "Basic_A1",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 40960,
                          "memoryInMB": 1792,
                          "maxDataDiskCount": 2
                      },
                      {
                          "name": "Basic_A2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 61440,
                          "memoryInMB": 3584,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Basic_A3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 122880,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Basic_A4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 245760,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D1_v2",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 51200,
                          "memoryInMB": 3584,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D2_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D3_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D4_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D5_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_D11_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D12_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D13_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D14_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_D15_v2",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1024000,
                          "memoryInMB": 143360,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_D2_v2_Promo",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D3_v2_Promo",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D4_v2_Promo",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D5_v2_Promo",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_D11_v2_Promo",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D12_v2_Promo",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D13_v2_Promo",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D14_v2_Promo",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_F1",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384,
                          "memoryInMB": 2048,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_F2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 4096,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_F4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_F8",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_F16",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_A1_v2",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 10240,
                          "memoryInMB": 2048,
                          "maxDataDiskCount": 2
                      },
                      {
                          "name": "Standard_A2m_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 20480,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_A2_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 20480,
                          "memoryInMB": 4096,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_A4m_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 40960,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_A4_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 40960,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_A8m_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 81920,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_A8_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 81920,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_B1ls",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096,
                          "memoryInMB": 512,
                          "maxDataDiskCount": 2
                      },
                      {
                          "name": "Standard_B1ms",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096,
                          "memoryInMB": 2048,
                          "maxDataDiskCount": 2
                      },
                      {
                          "name": "Standard_B1s",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096,
                          "memoryInMB": 1024,
                          "maxDataDiskCount": 2
                      },
                      {
                          "name": "Standard_B2ms",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_B2s",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8192,
                          "memoryInMB": 4096,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_B4ms",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_B8ms",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_B12ms",
                          "numberOfCores": 12,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 98304,
                          "memoryInMB": 49152,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_B16ms",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_B20ms",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 163840,
                          "memoryInMB": 81920,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS2_v2_Promo",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 14336,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_DS3_v2_Promo",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 28672,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS4_v2_Promo",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS5_v2_Promo",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 114688,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_DS11_v2_Promo",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 28672,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_DS12_v2_Promo",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS13_v2_Promo",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 114688,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS14_v2_Promo",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 229376,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_D2_v3",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 51200,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4_v3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48_v3",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1638400,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2_v3",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 51200,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4_v3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20_v3",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 512000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48_v3",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1638400,
                          "memoryInMB": 442368,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D1",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 51200,
                          "memoryInMB": 3584,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D11",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D12",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D13",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D14",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_DS1_v2",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 7168,
                          "memoryInMB": 3584,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_DS2_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 14336,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_DS3_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 28672,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS4_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS5_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 114688,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_DS11-1_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 28672,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_DS11_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 28672,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_DS12-1_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS12-2_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS12_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS13-2_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 114688,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS13-4_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 114688,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS13_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 114688,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS14-4_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 229376,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_DS14-8_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 229376,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_DS14_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 229376,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_DS15_v2",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 286720,
                          "memoryInMB": 143360,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_F1s",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096,
                          "memoryInMB": 2048,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_F2s",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8192,
                          "memoryInMB": 4096,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_F4s",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_F8s",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_F16s",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_D2s_v3",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4s_v3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8s_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16s_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32s_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48s_v3",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 393216,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64s_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2s_v3",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4-2s_v3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E4s_v3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8-2s_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8-4s_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8s_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16-4s_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16-8s_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16s_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20s_v3",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 327680,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-8s_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-16s_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32s_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48s_v3",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 786432,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-16s_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 884736,
                          "memoryInMB": 442368,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-32s_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 884736,
                          "memoryInMB": 442368,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64s_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 884736,
                          "memoryInMB": 442368,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS1",
                          "numberOfCores": 1,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 7168,
                          "memoryInMB": 3584,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_DS2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 14336,
                          "memoryInMB": 7168,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_DS3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 28672,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS11",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 28672,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_DS12",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 57344,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_DS13",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 114688,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_DS14",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 229376,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_E2d_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4d_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8d_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16d_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20d_v4",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 768000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32d_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48d_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64d_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 516096,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2ds_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4-2ds_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E4ds_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8-2ds_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8-4ds_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8ds_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16-4ds_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16-8ds_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16ds_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20ds_v4",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 768000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-8ds_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-16ds_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32ds_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48ds_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-16ds_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 516096,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-32ds_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 516096,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64ds_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 516096,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E80ids_v4",
                          "numberOfCores": 80,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4362240,
                          "memoryInMB": 516096,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_D2d_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4d_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8d_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16d_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32d_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48d_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64d_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2ds_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4ds_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8ds_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16ds_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32ds_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48ds_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64ds_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_F2s_v2",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384,
                          "memoryInMB": 4096,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_F4s_v2",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_F8s_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_F16s_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_F32s_v2",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_F48s_v2",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 393216,
                          "memoryInMB": 98304,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_F64s_v2",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_F72s_v2",
                          "numberOfCores": 72,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 589824,
                          "memoryInMB": 147456,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M64",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8192000,
                          "memoryInMB": 1024000,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384000,
                          "memoryInMB": 2048000,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M32ls",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1024000,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M32ts",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1024000,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M64ls",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2048000,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M64s",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2097152,
                          "memoryInMB": 1048576,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128s",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096000,
                          "memoryInMB": 2048000,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M32dms_v2",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1048576,
                          "memoryInMB": 896000,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M64dms_v2",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2097152,
                          "memoryInMB": 1835008,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M64ds_v2",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2097152,
                          "memoryInMB": 1048576,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128ds_v2",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4194304,
                          "memoryInMB": 2097152,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M192ids_v2",
                          "numberOfCores": 192,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4194304,
                          "memoryInMB": 2097152,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M64m",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8192000,
                          "memoryInMB": 1792000,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128m",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384000,
                          "memoryInMB": 3891200,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M8-2ms",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 256000,
                          "memoryInMB": 224000,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_M8-4ms",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 256000,
                          "memoryInMB": 224000,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_M8ms",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 256000,
                          "memoryInMB": 224000,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_M16-4ms",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 512000,
                          "memoryInMB": 448000,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_M16-8ms",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 512000,
                          "memoryInMB": 448000,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_M16ms",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 512000,
                          "memoryInMB": 448000,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_M32-8ms",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1024000,
                          "memoryInMB": 896000,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M32-16ms",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1024000,
                          "memoryInMB": 896000,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M32ms",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1024000,
                          "memoryInMB": 896000,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M64-16ms",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2048000,
                          "memoryInMB": 1792000,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M64-32ms",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2048000,
                          "memoryInMB": 1792000,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M64ms",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2048000,
                          "memoryInMB": 1792000,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128-32ms",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096000,
                          "memoryInMB": 3891200,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128-64ms",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096000,
                          "memoryInMB": 3891200,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128ms",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4096000,
                          "memoryInMB": 3891200,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M128dms_v2",
                          "numberOfCores": 128,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4194304,
                          "memoryInMB": 3985408,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M192idms_v2",
                          "numberOfCores": 192,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4194304,
                          "memoryInMB": 4194304,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_E64i_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1638400,
                          "memoryInMB": 442368,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64is_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 884736,
                          "memoryInMB": 442368,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2ds_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4ds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8ds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16ds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32ds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48ds_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64ds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D96ds_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3686400,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2d_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4d_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8d_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16d_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32d_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48d_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64d_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D96d_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3686400,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2ds_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4-2ds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E4ds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8-2ds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8-4ds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E8ds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16-4ds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16-8ds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16ds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20ds_v5",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 768000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-8ds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-16ds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32ds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48ds_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-16ds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-32ds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64ds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96-24ds_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96-48ds_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96ds_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3686400,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E104ids_v5",
                          "numberOfCores": 104,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3891200,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_E2d_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4d_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8d_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16d_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20d_v5",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 768000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32d_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48d_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64d_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96d_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3686400,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E104id_v5",
                          "numberOfCores": 104,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3891200,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_E2bds_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4bds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8bds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16bds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32bds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48bds_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64bds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2lds_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 4096,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4lds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8lds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16lds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32lds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48lds_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 98304,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64lds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D96lds_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3686400,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L8s_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 81920,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_L16s_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 163840,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L32s_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 327680,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L48s_v3",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 491520,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L64s_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 655360,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L80s_v3",
                          "numberOfCores": 80,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 655360,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L8s_v2",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 81920,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_L16s_v2",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 163840,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L32s_v2",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 327680,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L48s_v2",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 491520,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L64s_v2",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 655360,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L80s_v2",
                          "numberOfCores": 80,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 655360,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2a_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 51200,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4a_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8a_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16a_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32a_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48a_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64a_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1638400,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D96a_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2as_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 16384,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4as_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8as_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16as_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32as_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48as_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 393216,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64as_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D96as_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 786432,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2a_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 51200,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4a_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 102400,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8a_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 204800,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16a_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 409600,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20a_v4",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 512000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32a_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48a_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64a_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1638400,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96a_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2as_v4",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 32768,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4-2as_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E4as_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8-2as_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8-4as_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8as_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16-4as_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16-8as_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16as_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20as_v4",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 327680,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-8as_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-16as_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32as_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 524288,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48as_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 786432,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-16as_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 884736,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-32as_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 884736,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64as_v4",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 884736,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96-24as_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1376256,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96-48as_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1376256,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96as_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1376256,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96ias_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1376256,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_HC44-16rs",
                          "numberOfCores": 44,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 716800,
                          "memoryInMB": 360448,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_HC44-32rs",
                          "numberOfCores": 44,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 716800,
                          "memoryInMB": 360448,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_HC44rs",
                          "numberOfCores": 44,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 716800,
                          "memoryInMB": 360448,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D2ads_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4ads_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8ads_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16ads_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32ads_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48ads_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64ads_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D96ads_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2ads_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4-2ads_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E4ads_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8-2ads_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8-4ads_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E8ads_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16-4ads_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16-8ads_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E16ads_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20ads_v5",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 768000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-8ads_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32-16ads_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32ads_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E48ads_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-16ads_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64-32ads_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E64ads_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96-24ads_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96-48ads_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E96ads_v5",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3686400,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E112iads_v5",
                          "numberOfCores": 112,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3891200,
                          "memoryInMB": 688128,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_NC4as_T4_v3",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 180224,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_NC8as_T4_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 360448,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_NC16as_T4_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 360448,
                          "memoryInMB": 112640,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_NC64as_T4_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2883584,
                          "memoryInMB": 450560,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L8as_v3",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 81920,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_L16as_v3",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 163840,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L32as_v3",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 327680,
                          "memoryInMB": 262144,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L48as_v3",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 491520,
                          "memoryInMB": 393216,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L64as_v3",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 655360,
                          "memoryInMB": 524288,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_L80as_v3",
                          "numberOfCores": 80,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 819200,
                          "memoryInMB": 655360,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2plds_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 4096,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4plds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8plds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16plds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32plds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48plds_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 98304,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64plds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D2pds_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 8192,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_D4pds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_D8pds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_D16pds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D32pds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D48pds_v5",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1843200,
                          "memoryInMB": 196608,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_D64pds_v5",
                          "numberOfCores": 64,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 2457600,
                          "memoryInMB": 212992,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E2pds_v5",
                          "numberOfCores": 2,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 76800,
                          "memoryInMB": 16384,
                          "maxDataDiskCount": 4
                      },
                      {
                          "name": "Standard_E4pds_v5",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 153600,
                          "memoryInMB": 32768,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_E8pds_v5",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 307200,
                          "memoryInMB": 65536,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_E16pds_v5",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 614400,
                          "memoryInMB": 131072,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E20pds_v5",
                          "numberOfCores": 20,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 768000,
                          "memoryInMB": 163840,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_E32pds_v5",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1228800,
                          "memoryInMB": 212992,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_NC24ads_A100_v4",
                          "numberOfCores": 24,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 65536,
                          "memoryInMB": 225280,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_NC48ads_A100_v4",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 131072,
                          "memoryInMB": 450560,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_NC96ads_A100_v4",
                          "numberOfCores": 96,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 262144,
                          "memoryInMB": 901120,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_M208ms_v2",
                          "numberOfCores": 208,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4194304,
                          "memoryInMB": 5836800,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M208s_v2",
                          "numberOfCores": 208,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 4194304,
                          "memoryInMB": 2918400,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M416-208s_v2",
                          "numberOfCores": 416,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8388608,
                          "memoryInMB": 5836800,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M416s_v2",
                          "numberOfCores": 416,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8388608,
                          "memoryInMB": 5836800,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M416-208ms_v2",
                          "numberOfCores": 416,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8388608,
                          "memoryInMB": 11673600,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_M416ms_v2",
                          "numberOfCores": 416,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 8388608,
                          "memoryInMB": 11673600,
                          "maxDataDiskCount": 64
                      },
                      {
                          "name": "Standard_NV6s_v2",
                          "numberOfCores": 6,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 344064,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 12
                      },
                      {
                          "name": "Standard_NV12s_v2",
                          "numberOfCores": 12,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 688128,
                          "memoryInMB": 229376,
                          "maxDataDiskCount": 24
                      },
                      {
                          "name": "Standard_NV24s_v2",
                          "numberOfCores": 24,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 1376256,
                          "memoryInMB": 458752,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_NV12s_v3",
                          "numberOfCores": 12,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 344064,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 12
                      },
                      {
                          "name": "Standard_NV24s_v3",
                          "numberOfCores": 24,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 688128,
                          "memoryInMB": 229376,
                          "maxDataDiskCount": 24
                      },
                      {
                          "name": "Standard_NV48s_v3",
                          "numberOfCores": 48,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 3018752,
                          "memoryInMB": 458752,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_NV4as_v4",
                          "numberOfCores": 4,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 90112,
                          "memoryInMB": 14336,
                          "maxDataDiskCount": 8
                      },
                      {
                          "name": "Standard_NV8as_v4",
                          "numberOfCores": 8,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 180224,
                          "memoryInMB": 28672,
                          "maxDataDiskCount": 16
                      },
                      {
                          "name": "Standard_NV16as_v4",
                          "numberOfCores": 16,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 360448,
                          "memoryInMB": 57344,
                          "maxDataDiskCount": 32
                      },
                      {
                          "name": "Standard_NV32as_v4",
                          "numberOfCores": 32,
                          "osDiskSizeInMB": 1047552,
                          "resourceDiskSizeInMB": 720896,
                          "memoryInMB": 114688,
                          "maxDataDiskCount": 32
                      }
                  ]
              }
              '''}
        navigate:
          - SUCCESS: get_cpu_cores
          - FAILURE: on_failure
    - get_cpu_cores:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: "${'$.value[?(@.name == \"'+image_name+'\")].numberOfCores'}"
        publish:
          - cpus: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: get_memory
          - FAILURE: on_failure
    - get_memory:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_result}'
            - json_path: "${'$.value[?(@.name == \"'+image_name+'\")].memoryInMB'}"
        publish:
          - memory: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - cpus: '${cpus}'
    - memory: '${memory}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_azure_vm_sizes:
        x: 80
        'y': 80
      get_cpu_cores:
        x: 280
        'y': 80
      get_memory:
        x: 480
        'y': 80
        navigate:
          6cd942f9-371f-8fbb-65f4-bc1f97d194bb:
            targetId: aef09dda-1b70-2509-d5b6-5d70986b0091
            port: SUCCESS
    results:
      SUCCESS:
        aef09dda-1b70-2509-d5b6-5d70986b0091:
          x: 680
          'y': 80

