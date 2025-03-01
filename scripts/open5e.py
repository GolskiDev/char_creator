import requests
import time

base_url = "https://api.open5e.com/spells/"

def get_all_spells():
    spells = []
    url = base_url
    while url:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            spells.extend(data['results'])
            url = data['next']
            print(f"Current total number of results: {len(spells)}")
            #time.sleep(20)  # Add a delay
        else:
            print(f"Failed to retrieve spells: {response.status_code}")
            return None
    return spells

if __name__ == "__main__":
    spells = get_all_spells()
    if spells:
        print(f"Total spells retrieved: {len(spells)}")


