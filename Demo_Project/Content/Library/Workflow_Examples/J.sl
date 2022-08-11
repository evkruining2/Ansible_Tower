namespace: Workflow_Examples
operation:
  name: J
  inputs:
    - json_result
    - index: '0'
  python_action:
    use_jython: false
    script: "def execute(json_result,index): \n\n    import json\n    \n    data = json.loads(json_result)\n    index = int(index)\n    \n    gender      = data['results'][index]['gender']\n    first_name  = data['results'][index]['name']['first']\n    title       = data['results'][index]['name']['title']\n    last_name   = data['results'][index]['name']['last']\n    location_street_number  = data['results'][index]['location']['street']['number']\n    location_street_name    = data['results'][index]['location']['street']['name']\n    location_city           = data['results'][index]['location']['city']\n    location_state          = data['results'][index]['location']['state']\n    location_country        = data['results'][index]['location']['country']\n    location_postcode       = data['results'][index]['location']['postcode']\n    location_coordinates_latitude   = data['results'][index]['location']['coordinates']['latitude']\n    location_coordinates_longitude  = data['results'][index]['location']['coordinates']['longitude']\n    location_timezone_offset        = data['results'][index]['location']['timezone']['offset']\n    location_timezone_description   = data['results'][index]['location']['timezone']['description']\n    email = data['results'][index]['email']\n    login_uuid      = data['results'][index]['login']['uuid']\n    login_username  = data['results'][index]['login']['username']\n    login_password  = data['results'][index]['login']['password']\n    login_salt      = data['results'][index]['login']['salt']\n    login_md5       = data['results'][index]['login']['md5']\n    login_sha1      = data['results'][index]['login']['sha1']\n    login_sha256    = data['results'][index]['login']['sha256']\n    dob_date    = data['results'][index]['dob']['date']\n    dob_age     = data['results'][index]['dob']['age']\n    registered_date     = data['results'][index]['registered']['date']\n    registered_age      = data['results'][index]['registered']['age']\n    phone   = data['results'][index]['phone']\n    cell    = data['results'][index]['cell']\n    id_name     = data['results'][index]['id']['name']\n    id_value    = data['results'][index]['id']['value']\n    picture_large       = data['results'][index]['picture']['large']\n    picture_medium      = data['results'][index]['picture']['medium']\n    picture_thumbnail   = data['results'][index]['picture']['thumbnail']\n    nat = data['results'][index]['nat']  \n    \n    return locals()"
  outputs:
    - gender
    - first_name
    - last_name
    - title
    - email
    - login_username
    - phone
    - cell
    - id_value
    - nat
  results:
    - SUCCESS
