namespace: io.cloudslang.energy_project.email_and_html_reports
flow:
  name: create_all_cost_chart
  inputs:
    - cost_list
    - tax_list
    - storage_list
    - gvo_list
    - fixed_list
    - net_management_list
    - bgcolor1: ' #5dade2 '
    - bgcolor2: ' #5499c7 '
    - bgcolor3: ' #DAF7A6 '
    - bgcolor4: ' #FFC300 '
    - bgcolor5: ' #FF5733 '
    - bgcolor6: ' #C70039 '
    - date
    - sum_cost
    - sum_tax
    - sum_storage
    - sum_gvo
    - sum_net_management
    - sum_fixed
    - sum_total
    - p1_date
  workflow:
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: /tmp/c2.html
            - text: "${'''\n<!DOCTYPE html>\n<html>\n\n<head>\n\t<title>ChartJS Stacked Bar Chart Example</title>\n\t<script src=\n\"https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js\">\n\t</script>\n\t<script src=\n\"https://cdn.jsdelivr.net/npm/chart.js@4.0.1/dist/chart.umd.min.js\">\n\t</script>\n</head>\n\n<body>\n\t<H1 style=\"font-family: Arial;\"><center>\n\t\tStroomkosten voor '''+date+''' (per uur)\n\t</center></h1>\n\n\n\t<div>\n\t\t<canvas id=\"stackedChartID\"></canvas>\n\t</div>\n\n\n\t<script>\n\n\t\t// Get the drawing context on the canvas\n\t\tvar myContext = document.getElementById(\n\t\t\t\"stackedChartID\").getContext('2d');\n\t\tvar myChart = new Chart(myContext, {\n\t\t\ttype: 'bar',\n\t\t\tdata: {\n\t\t\t\tlabels: [\"00:00\", \"01:00\", \"02:00\",\n\t\t\t\t\t \"03:00\", \"04:00\", \"05:00\",\n\t\t\t\t\t \"06\",\"07\",\"08\",\"09\",\n\t\t\t\t\t \"10\",\"11\",\"12\",\"13\",\"14\",\"15\",\"16\",\n\t    \t\t\t\t \"17\",\"18\",\"19\",\"20\",\"21\",\"22\",\"23\"],\n\t\t\t\tdatasets: [{\n\t\t\t\t\tlabel: 'Verbruik',\n\t\t\t\t\tbackgroundColor: \"'''+bgcolor1+'''\",\n\t\t\t\t\tdata: ['''+cost_list+'''],\n\t\t\t\t}, {\n\t\t\t\t\tlabel: 'Opslag',\n\t\t\t\t\tbackgroundColor: \"'''+bgcolor2+'''\",\n\t\t\t\t\tdata: ['''+storage_list+'''],\n\t\t\t\t}, {\n\t\t\t\t\tlabel: 'GvOs uit wind',\n\t\t\t\t\tbackgroundColor: \"'''+bgcolor3+'''\",\n\t\t\t\t\tdata: ['''+gvo_list+'''],\n\t\t\t\t}, {\n\t\t\t\t\tlabel: 'Vaste leveringskosten',\n\t\t\t\t\tbackgroundColor: \"'''+bgcolor4+'''\",\n\t\t\t\t\tdata: ['''+fixed_list+'''],\n\t\t\t\t}, {\n\t\t\t\t\tlabel: 'Netbeheer',\n\t\t\t\t\tbackgroundColor: \"'''+bgcolor5+'''\",\n\t\t\t\t\tdata: ['''+net_management_list+'''],\n\t\t\t\t}, {\n\t\t\t\t\tlabel: 'Energiebelasting*',\n\t\t\t\t\tbackgroundColor: \"'''+bgcolor6+'''\",\n\t\t\t\t\tdata: ['''+tax_list+'''],\n\t\t\t\t}],\n\t\t\t},\n\t\t\toptions: {\n\t\t\t\tplugins: {\n\t\t\t\t\ttitle: {\n\t\t\t\t\t\tdisplay: true,\n\t\t\t\t\t\ttext: 'Stoomkosten per uur uitgesplitst'\n\t\t\t\t\t},\n\t\t\t\t},\n\t\t\t\tscales: {\n\t\t\t\t\tx: {\n\t\t\t\t\t\tstacked: true,\n\t\t\t\t\t},\n\t\t\t\t\ty: {\n\t\t\t\t\t\tstacked: true\n\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t</script>\n\n<H4 style=\"font-family: Arial;\">\n<center>\nVerbruik: €'''+sum_cost+''' |\nOpslag: €'''+sum_storage+''' |\nGvOs uit wind: €'''+sum_gvo+''' |\nVaste leveringskosten: €'''+sum_fixed+''' |\nNetbeheer: €'''+sum_net_management+''' |\nEnergiebelasting: €'''+sum_tax+'''*\n</center>\n</h4>\n<H4 style=\"font-family: Arial;\">\n<center>\nTotale kosten voor '''+date+''': €'''+sum_total+'''\n</center>\n</h4>\n<h5 style=\"font-family: Arial;\">\n<center>\n* Compensatie energiebelasting is verrekend in deze gegevens (€0.001 per Kwh)\n</center>\n</h5>\n</body>\n\n</html>\n'''}"
        navigate:
          - SUCCESS: scp_copy_file
          - FAILURE: on_failure
    - scp_copy_file:
        do:
          io.cloudslang.base.remote_file_transfer.scp.scp_copy_file:
            - host: "${get_sp('easyenergy_project.web_host')}"
            - username: "${get_sp('easyenergy_project.web_host_user')}"
            - password:
                value: "${get_sp('easyenergy_project.web_host_password')}"
                sensitive: true
            - local_file: /tmp/c2.html
            - copy_action: to
            - remote_file: /var/www/virtual/opsware.nl/easyenergy/c2.html
        navigate:
          - SUCCESS: scp_copy_file_1
          - FAILURE: on_failure
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: /tmp/c2.html
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - scp_copy_file_1:
        do:
          io.cloudslang.base.remote_file_transfer.scp.scp_copy_file:
            - host: "${get_sp('easyenergy_project.web_host')}"
            - username: "${get_sp('easyenergy_project.web_host_user')}"
            - password:
                value: "${get_sp('easyenergy_project.web_host_password')}"
                sensitive: true
            - local_file: /tmp/c2.html
            - copy_action: to
            - remote_file: "${'/var/www/virtual/opsware.nl/easyenergy/cost'+p1_date+'.html'}"
        navigate:
          - SUCCESS: delete
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      write_to_file:
        x: 80
        'y': 120
      scp_copy_file:
        x: 200
        'y': 280
      delete:
        x: 400
        'y': 120
        navigate:
          a6789780-9555-b10c-d302-43e9226c4d93:
            targetId: 0e955a3b-f1ab-3da5-0c56-6a2dc21b5ae3
            port: SUCCESS
      scp_copy_file_1:
        x: 360
        'y': 360
    results:
      SUCCESS:
        0e955a3b-f1ab-3da5-0c56-6a2dc21b5ae3:
          x: 520
          'y': 280
