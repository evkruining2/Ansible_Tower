namespace: io.cloudslang.tests
flow:
  name: test_power_state
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: |-
                {
                    "name": "DCASaaSVM235538",
                    "id": "/subscriptions/4d08f192-8c63-49fa-a461-5cdd32ce42dc/resourceGroups/Merlion/providers/Microsoft.Compute/virtualMachines/DCASaaSVM235538",
                    "type": "Microsoft.Compute/virtualMachines",
                    "location": "southeastasia",
                    "properties": {
                        "vmId": "052359fc-a07f-455c-b124-abb31fb8b8fd",
                        "hardwareProfile": {
                            "vmSize": "Standard_B1s"
                        },
                        "storageProfile": {
                            "imageReference": {
                                "publisher": "OpenLogic",
                                "offer": "CentOS",
                                "sku": "7.4",
                                "version": "latest",
                                "exactVersion": "7.4.20200220"
                            },
                            "osDisk": {
                                "osType": "Linux",
                                "name": "DCASaaSVM235538_osDisk",
                                "createOption": "FromImage",
                                "caching": "ReadWrite",
                                "managedDisk": {
                                    "storageAccountType": "Standard_LRS",
                                    "id": "/subscriptions/4d08f192-8c63-49fa-a461-5cdd32ce42dc/resourceGroups/Merlion/providers/Microsoft.Compute/disks/DCASaaSVM235538_osDisk"
                                },
                                "deleteOption": "Detach",
                                "diskSizeGB": 30
                            },
                            "dataDisks": [
                                {
                                    "lun": 0,
                                    "name": "DCASaaSVM235538_dataDisk",
                                    "createOption": "Empty",
                                    "caching": "None",
                                    "managedDisk": {
                                        "storageAccountType": "Standard_LRS",
                                        "id": "/subscriptions/4d08f192-8c63-49fa-a461-5cdd32ce42dc/resourceGroups/Merlion/providers/Microsoft.Compute/disks/DCASaaSVM235538_dataDisk"
                                    },
                                    "deleteOption": "Detach",
                                    "diskSizeGB": 10,
                                    "toBeDetached": false
                                }
                            ]
                        },
                        "osProfile": {
                            "computerName": "DCASaaSVM2355",
                            "adminUsername": "mok",
                            "linuxConfiguration": {
                                "disablePasswordAuthentication": false,
                                "provisionVMAgent": true,
                                "patchSettings": {
                                    "patchMode": "ImageDefault",
                                    "assessmentMode": "ImageDefault"
                                },
                                "enableVMAgentPlatformUpdates": false
                            },
                            "secrets": [],
                            "allowExtensionOperations": true,
                            "requireGuestProvisionSignal": true
                        },
                        "networkProfile": {
                            "networkInterfaces": [
                                {
                                    "id": "/subscriptions/4d08f192-8c63-49fa-a461-5cdd32ce42dc/resourceGroups/Merlion/providers/Microsoft.Network/networkInterfaces/DCASaaSVM235538",
                                    "properties": {
                                        "primary": true
                                    }
                                }
                            ]
                        },
                        "provisioningState": "Succeeded",
                        "instanceView": {
                            "computerName": "DCASaaSVM2355",
                            "osName": "centos",
                            "osVersion": "7.4.1708",
                            "vmAgent": {
                                "vmAgentVersion": "2.8.0.11",
                                "statuses": [
                                    {
                                        "code": "ProvisioningState/succeeded",
                                        "level": "Info",
                                        "displayStatus": "Ready",
                                        "message": "Guest Agent is running",
                                        "time": "2023-03-31T11:50:06+00:00"
                                    }
                                ],
                                "extensionHandlers": []
                            },
                            "disks": [
                                {
                                    "name": "DCASaaSVM235538_osDisk",
                                    "statuses": [
                                        {
                                            "code": "ProvisioningState/succeeded",
                                            "level": "Info",
                                            "displayStatus": "Provisioning succeeded",
                                            "time": "2022-09-27T08:24:47.6204278+00:00"
                                        }
                                    ]
                                },
                                {
                                    "name": "DCASaaSVM235538_dataDisk",
                                    "statuses": [
                                        {
                                            "code": "ProvisioningState/succeeded",
                                            "level": "Info",
                                            "displayStatus": "Provisioning succeeded",
                                            "time": "2022-09-27T08:24:47.6204278+00:00"
                                        }
                                    ]
                                }
                            ],
                            "hyperVGeneration": "V1",
                            "statuses": [
                                {
                                    "code": "ProvisioningState/succeeded",
                                    "level": "Info",
                                    "displayStatus": "Provisioning succeeded",
                                    "time": "2022-09-27T08:26:03.4008132+00:00"
                                },
                                {
                                    "code": "PowerState/running",
                                    "level": "Info",
                                    "displayStatus": "VM running"
                                }
                            ]
                        },
                        "timeCreated": "2022-09-27T08:24:45.9484706+00:00"
                    }
                }
            - json_path: $.properties.instanceView.statuses..displayStatus
        publish:
          - return_result
        navigate:
          - SUCCESS: string_occurrence_counter
          - FAILURE: on_failure
    - string_occurrence_counter:
        do:
          io.cloudslang.base.strings.string_occurrence_counter:
            - string_in_which_to_search: '${return_result}'
            - string_to_find: stopped
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      string_occurrence_counter:
        x: 360
        'y': 240
        navigate:
          d8a81986-087f-57c6-3a79-60f6869d864a:
            targetId: 874d7bf1-1d4b-bc07-9165-9d53f613e9b9
            port: SUCCESS
      json_path_query:
        x: 160
        'y': 160
    results:
      SUCCESS:
        874d7bf1-1d4b-bc07-9165-9d53f613e9b9:
          x: 600
          'y': 240
