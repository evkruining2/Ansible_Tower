namespace: My_First_Folder
operation:
  name: Hello_World
  sequential_action:
    gav: com.microfocus.seq:My_First_Folder.Hello_World:1.0.0
    skills:
    - Java
    - SAP
    - SAP NWBC Desktop
    - SAPUI5
    - SAPWDJ
    - SAPWebExt
    - Terminal Emulators
    - UI Automation
    - Web
    settings:
      sap:
        active: false
        auto_log_on: false
        close_on_exit: false
        ignore_existing_sessions: false
        remember_password: false
      windows:
        active: true
        apps:
          app_1:
            args: ''
            directory: c:\temp
            path: c:\windows\notepad.exe
      terminal_settings:
        active: false
      web:
        active: false
        close_on_exit: false
    steps:
    - step:
        id: '1'
        object_path: Window("Notepad").WinEditor("Edit")
        action: SetCaretPos
        default_args: 0,0
        snapshot: .\Snapshots\ssf1.png
        highlight_id: '721726'
    - step:
        id: '2'
        object_path: Window("Notepad").WinEditor("Edit")
        action: Type
        default_args: '"Hello and welcome to RPA!"'
        snapshot: .\Snapshots\ssf2.png
        highlight_id: '721726'
    - step:
        id: '3'
        object_path: Window("Notepad").WinEditor("Edit")
        action: Type
        default_args: micReturn
        snapshot: .\Snapshots\ssf3.png
        highlight_id: '721726'
    - step:
        id: '4'
        object_path: Window("Notepad").WinEditor("Edit")
        action: Type
        default_args: micReturn
        snapshot: .\Snapshots\ssf4.png
        highlight_id: '721726'
    - step:
        id: '5'
        object_path: Window("Notepad").WinEditor("Edit")
        action: Type
        default_args: '"Have a nice day!"'
        snapshot: .\Snapshots\ssf5.png
        highlight_id: '721726'
    - step:
        id: '6'
        object_path: Window("Notepad").WinEditor("Edit")
        action: Type
        default_args: micReturn
        snapshot: .\Snapshots\ssf6.png
        highlight_id: '721726'
    - step:
        id: '7'
        object_path: Window("Notepad").WinEditor("Edit")
        action: Type
        default_args: micReturn
        snapshot: .\Snapshots\ssf7.png
        highlight_id: '721726'
  outputs:
  - return_result: ${return_result}
  - error_message: ${error_message}
  results:
  - SUCCESS
  - WARNING
  - FAILURE
object_repository:
  objects:
  - object:
      class: Window
      name: Notepad
      properties:
      - property:
          value:
            value: Notepad
            regular_expression: false
          name: regexpwndtitle
          hidden: false
          read_only: false
          type: STRING
      - property:
          value:
            value: Notepad
            regular_expression: false
          name: regexpwndclass
          hidden: false
          read_only: false
          type: STRING
      - property:
          value:
            value: '0'
            regular_expression: false
          name: is owned window
          hidden: false
          read_only: false
          type: BOOL
      - property:
          value:
            value: '0'
            regular_expression: false
          name: is child window
          hidden: false
          read_only: false
          type: BOOL
      basic_identification:
        property_ref:
        - regexpwndtitle
        - regexpwndclass
        - is owned window
        - is child window
        ordinal_identifier: ''
      smart_identification: ''
      custom_replay:
        behavior:
          value: Notepad
          name: simclass
          type: STRING
      comments: ''
      visual_relations: ''
      last_update_time: Wednesday, April 8, 2020 5:04:24 PM
      child_objects:
      - object:
          class: WinEditor
          name: Edit
          properties:
          - property:
              value:
                value: Edit
                regular_expression: false
              name: nativeclass
              hidden: false
              read_only: false
              type: STRING
          basic_identification:
            property_ref:
            - nativeclass
            ordinal_identifier: ''
          smart_identification: ''
          custom_replay:
            behavior:
              value: Edit
              name: simclass
              type: STRING
          comments: ''
          visual_relations: ''
          last_update_time: Wednesday, April 8, 2020 5:04:24 PM
          child_objects: []
  check_points_and_outputs: []
  parameters: []
