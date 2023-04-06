namespace: io.cloudslang.carbon_footprint_project.oneview.subflows
flow:
  name: calculate_co2e_scope3
  workflow:
    - set_dcoe_co2e_scope3:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - dcoe_scope3_co2e: '0.9781'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - dcoe_scope3_co2e: '${dcoe_scope3_co2e}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_dcoe_co2e_scope3:
        x: 160
        'y': 120
        navigate:
          ec5b5c7b-1f9f-9a02-ffcd-fd85ebd97ea8:
            targetId: ff4da119-3d5e-1dfb-2239-2175bba07512
            port: SUCCESS
    results:
      SUCCESS:
        ff4da119-3d5e-1dfb-2239-2175bba07512:
          x: 320
          'y': 120
