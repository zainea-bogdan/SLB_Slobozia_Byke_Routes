import json

import requests
from pathlib import Path


BROUTER_URL = "https://brouter.de/brouter"
HEADERS = {"User-Agent": "SlobozaBikeRoutes/0.1 (learning project)"}
OUTPUT_FILE = Path(__file__).parents[3] / "data_sample" / "brouter_test_route.geojson"


params = {
    "lonlats": "27.361085,44.56612|27.366171,44.565156",
    "nogos": "27.355249,44.568197,177",
    "profile": "trekking",
    "alternativeidx": 0,
    "format": "geojson",
}

response = requests.get(BROUTER_URL, params=params, headers=HEADERS, timeout=60)
response.raise_for_status()
route = response.json()

props = route["features"][0]["properties"]
coords = route["features"][0]["geometry"]["coordinates"]

print("Length:", props["track-length"], "m")
print("Time:", props["total-time"], "s")
print("Points:", len(coords))

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(route, f, indent=2, ensure_ascii=False)

print("Saved to:", OUTPUT_FILE)
