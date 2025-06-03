import json
import requests

BASE_URL = "http://localhost:4000"

def post(resource_type, attributes):
    headers = {"Accept": "application/vnd.api+json", "Content-Type": "application/vnd.api+json"}
    json_payload = {
       "data": {
           "type": resource_type,
            "attributes": attributes
        }
    }
    r = requests.post(BASE_URL+"/api/json/aws/"+resource_type, data=json.dumps(json_payload), headers=headers)

    if r.status_code != 201:
        print(f"Status Code: {r.status_code}, Response: {r.json()}")
        raise Exception("Error posting to " + BASE_URL)
    else:
        #print(f"Status Code: {r.status_code}, Response: {r.json()}")
        return r.json()['data']['id']


