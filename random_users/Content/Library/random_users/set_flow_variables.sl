########################################################################################################################
#!!
#! @input index: the index number of the array to use
#!!#
########################################################################################################################
namespace: random_users
operation:
  name: set_flow_variables
  inputs:
    - json_list
    - index
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(json_list,index):\n    # code goes here\n    import json\n\n    data = json.loads(json_list)\n    index = int(index)\n\n    gender = data['results'][index]['gender']\n    name_title = data['results'][index]['name']['title']\n    name_first = data['results'][index]['name']['first']\n    name_last = data['results'][index]['name']['last']\n    location_street_number = data['results'][index]['location']['street']['number']\n    location_street_name = data['results'][index]['location']['street']['name']\n    location_city = data['results'][index]['location']['city']\n    location_state = data['results'][index]['location']['state']\n    location_country = data['results'][index]['location']['country']\n    location_postcode = data['results'][index]['location']['postcode']\n    location_coordinates_latitude = data['results'][index]['location']['coordinates']['latitude']\n    location_coordinates_longitude = data['results'][index]['location']['coordinates']['longitude']\n    location_timezone_offset = data['results'][index]['location']['timezone']['offset']\n    location_timezone_description = data['results'][index]['location']['timezone']['description']\n    email = data['results'][index]['email']\n    login_uuid = data['results'][index]['login']['uuid']\n    login_username = data['results'][index]['login']['username']\n    login_password = data['results'][index]['login']['password']\n    login_salt = data['results'][index]['login']['salt']\n    login_md5 = data['results'][index]['login']['md5']\n    login_sha1 = data['results'][index]['login']['sha1']\n    login_sha256 = data['results'][index]['login']['sha256']\n    dob_date = data['results'][index]['dob']['date']\n    dob_age = data['results'][index]['dob']['age']\n    registered_date = data['results'][index]['registered']['date']\n    registered_age = data['results'][index]['registered']['age']\n    phone = data['results'][index]['phone']\n    cell = data['results'][index]['cell']\n    id_name = data['results'][index]['id']['name']\n    id_value = data['results'][index]['id']['value']\n    picture_large = data['results'][index]['picture']['large']\n    picture_medium = data['results'][index]['picture']['medium']\n    picture_thumbnail = data['results'][index]['picture']['thumbnail']\n    nat = data['results'][index]['nat']\n    \n    return locals()\n    # you can add additional helper methods below."
  outputs:
    - gender
    - name_title
    - name_first
    - name_last
    - location_street_number
    - location_street_name
    - location_city
    - location_state
    - location_country
    - location_postcode
    - location_coordinates_latitude
    - location_coordinates_longitude
    - location_timezone_offset
    - location_timezone_description
    - email
    - login_uuid
    - login_username
    - login_password
    - login_salt
    - login_md5
    - login_sha1
    - login_sha256
    - dob_date
    - dob_age
    - registered_date
    - registered_age
    - phone
    - cell
    - id_name
    - id_value
    - picture_large
    - picture_medium
    - picture_thumbnail
    - nat
  results:
    - SUCCESS
