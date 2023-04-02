namespace: io.cloudslang.tests
flow:
  name: test_string_delete
  inputs:
    - json: "{   \"aws_region\" : \"eu-west-1\",   \"reservation_id\" : \"r-06b42653f85a99108\",   \"instance_id\" : \"i-0e6c694b93889a7a0\",   \"instance_type\" : \"t2.micro\",   \"instance_state\" : \"stopped\",   \"instance_name\" : \"myvm\"},{   \"aws_region\" : \"eu-west-1\",   \"reservation_id\" : \"r-0a2b1fcf08a063ff0\",   \"instance_id\" : \"i-0f0a59fe6070a5447\",   \"instance_type\" : \"t2.micro\",   \"instance_state\" : \"stopped\",   \"instance_name\" : \"myvm2\"},\n\n {   \"aws_region\" : \"us-east-1\",   \"reservation_id\" : \"r-0980c9c73125ccfd8\",   \"instance_id\" : \"i-0b3370c7a2e5daef2\",   \"instance_type\" : \"t2.micro\",   \"instance_state\" : \"running\",   \"instance_name\" : \"myVM4\"},\n\n {   \"aws_region\" : \"us-west-1\",   \"reservation_id\" : \"r-0efd6ed343f1a53a3\",   \"instance_id\" : \"i-073ab686837457b35\",   \"instance_type\" : \"t2.micro\",   \"instance_state\" : \"running\",   \"instance_name\" : \"myVM3\"},\n\n "
  workflow:
    - trim:
        do:
          io.cloudslang.base.strings.trim:
            - origin_string: '${json}'
        publish:
          - json: '${new_string}'
        navigate:
          - SUCCESS: do_nothing
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: "${json.strip(',')}"
        publish:
          - output_0: "${cs_prepend(cs_append(input_0,']'),'[')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - output_0: '${output_0}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing:
        x: 200
        'y': 160
        navigate:
          c3da8c29-d5d1-7bbc-6599-bedbf5290d98:
            targetId: 34e45e7f-bf30-3283-e64a-feab56a79b71
            port: SUCCESS
      trim:
        x: 80
        'y': 120
    results:
      SUCCESS:
        34e45e7f-bf30-3283-e64a-feab56a79b71:
          x: 400
          'y': 160
