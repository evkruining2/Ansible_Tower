namespace: io.cloudslang.site_migration_use_case.ssh
flow:
  name: scp_payload
  inputs:
    - target
  workflow:
    - scp_sqldump:
        do:
          io.cloudslang.base.remote_file_transfer.scp.scp_remote_copy_file:
            - source_host: m2
            - source_username: root
            - source_password:
                value: "${get_sp('site_migration.m2Password')}"
                sensitive: true
            - source_path: /root/backup/joomla.sql
            - destination_host: '${target}'
            - destination_username: root
            - destination_password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
            - destination_path: /tmp/joomla.sql
        navigate:
          - SUCCESS: scp_website_payload
          - FAILURE: on_failure
    - scp_website_payload:
        do:
          io.cloudslang.base.remote_file_transfer.scp.scp_remote_copy_file:
            - source_host: m2
            - source_username: root
            - source_password:
                value: "${get_sp('site_migration.m2Password')}"
                sensitive: true
            - source_path: /root/backup/website.tgz
            - destination_host: '${target}'
            - destination_username: root
            - destination_password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
            - destination_path: /tmp/website.tgz
        navigate:
          - SUCCESS: extract_website_payload
          - FAILURE: on_failure
    - extract_website_payload:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: tar zxvf /tmp/website.tgz -C /var/www/html/
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: remove_index_dot_html
          - FAILURE: on_failure
    - remove_index_dot_html:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: rm -rf /var/www/html/index.html
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: chown_web_folder
          - FAILURE: on_failure
    - chown_web_folder:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: 'chown -R www-data:www-data /var/www/html'
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      scp_sqldump:
        x: 80
        'y': 120
      scp_website_payload:
        x: 280
        'y': 120
      extract_website_payload:
        x: 480
        'y': 120
      remove_index_dot_html:
        x: 680
        'y': 120
      chown_web_folder:
        x: 880
        'y': 120
        navigate:
          15acad84-0817-079a-5dc2-547f587fe905:
            targetId: 5b51713f-c1c2-532b-22ec-d562c3af0596
            port: SUCCESS
    results:
      SUCCESS:
        5b51713f-c1c2-532b-22ec-d562c3af0596:
          x: 880
          'y': 360
