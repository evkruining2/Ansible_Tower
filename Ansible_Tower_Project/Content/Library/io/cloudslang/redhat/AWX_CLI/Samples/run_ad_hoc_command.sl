########################################################################################################################
#!!
#! @description: Run an ad-hoc command to target servers in the specified inventory ID, using the specified credential ID
#!
#! @input awx_cli_host: Hostname of IP address of the host that has the AWX CLI tools installed. Example: awxcli.example.com
#! @input awx_cli_username: Username of the awx cli host. Example: root
#! @input awx_cli_password: Password for the (root) user on the awx cli host
#! @input awx_host: AWX/Tower URL. Example: http://awx.example.com
#! @input awx_username: AWX/Tower username. Example: admin
#! @input awx_password: AWX/Tower user password
#! @input inventory: Inventory ID
#! @input credential: Credentials ID
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.AWX_CLI.Samples
flow:
  name: run_ad_hoc_command
  inputs:
    - awx_cli_host
    - awx_cli_username
    - awx_cli_password:
        sensitive: true
    - awx_host
    - awx_username
    - awx_password:
        sensitive: true
    - inventory
    - credential


  results:
    - SUCCESS
extensions:
  graph:
    results:
      SUCCESS:
        8948f088-0b38-969e-bedc-3b1eede33695:
          x: 775
          'y': 536
