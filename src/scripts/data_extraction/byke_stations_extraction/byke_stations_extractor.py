import json
from pathlib import Path

import requests


NEXTBIKE_URL = "https://maps2.nextbike.net/maps/nextbike-live.json"
HEADERS = {"User-Agent": "SlobozaBikeRoutes/0.1 (learning project)"}
SLOBOZIA_CITY_ID = 978
OUTPUT_FILE = Path(__file__).parents[3] / "data_sample" / "slobozia_bike_stations.json"


response = requests.get(
    NEXTBIKE_URL,
    params={"city": SLOBOZIA_CITY_ID},
    headers=HEADERS,
    timeout=60,
)

response.raise_for_status()
data = response.json()

places = data["countries"][0]["cities"][0]["places"]
print("Places in feed:", len(places))

stations = [p for p in places if p["spot"]]
print("Stations:", len(stations))

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(stations, f, indent=2, ensure_ascii=False)

print("Saved to:", OUTPUT_FILE)
