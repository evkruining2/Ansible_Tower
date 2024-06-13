namespace: io.cloudslang.site_migration_use_case.ssh
flow:
  name: populate_sql_db
  inputs:
    - target
  workflow:
    - create_database:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: 'mysql -u root -e "create database Joomla"; '
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: restore_sqldump
          - FAILURE: on_failure
    - restore_sqldump:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: mysql -u root < /tmp/joomla.sql
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: create_user
          - FAILURE: on_failure
    - create_user:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: "mysql -u root -e \"CREATE USER joomlauser@localhost IDENTIFIED BY 'Opsware123\\!'\";"
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: set_permissions
          - FAILURE: on_failure
    - set_permissions:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO 'joomlauser'@'localhost'\";"
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: flush_permissions
          - FAILURE: on_failure
    - flush_permissions:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: 'mysql -u root -e "FLUSH PRIVILEGES";'
            - username: root
            - password:
                value: "${get_sp('site_migration.pvePassword')}"
                sensitive: true
        navigate:
          - SUCCESS: restart_apache
          - FAILURE: on_failure
    - restart_apache:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${target}'
            - command: systemctl restart apache2
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
      create_database:
        x: 80
        'y': 120
      restore_sqldump:
        x: 80
        'y': 320
      create_user:
        x: 320
        'y': 120
      set_permissions:
        x: 320
        'y': 320
      flush_permissions:
        x: 520
        'y': 120
      restart_apache:
        x: 520
        'y': 320
        navigate:
          f12eedf1-a4ad-6c22-2f32-fa0192f3c5cb:
            targetId: 85569758-2b95-6621-358d-1b0b3b304db5
            port: SUCCESS
    results:
      SUCCESS:
        85569758-2b95-6621-358d-1b0b3b304db5:
          x: 720
          'y': 240
