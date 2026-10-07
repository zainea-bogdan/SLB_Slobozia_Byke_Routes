import json
import time
from itertools import combinations
from pathlib import Path
import requests

DATA_DIR = Path(__file__).parents[3] / "data_sample"
STATIONS_FILE = DATA_DIR / "slobozia_bike_stations.json"
ROUTES_DIR = DATA_DIR / "brouter_byke_ideal_routes"

BROUTER_URL = "https://brouter.de/brouter"
HEADERS = {"User-Agent": "SlobozaBikeRoutes/0.1 (learning project)"}
ROUTE_PROFILE = "trekking"
PAUSE_SECONDS = 2
TEST_LIMIT = None

def get_route(from_station, to_station):
    params = {
        "lonlats": f"{from_station['lng']},{from_station['lat']}|{to_station['lng']},{to_station['lat']}",
        "profile": ROUTE_PROFILE,
        "alternativeidx": 0,
        "format": "geojson",
    }
    response = requests.get(BROUTER_URL, params=params, headers=HEADERS, timeout=60)
    response.raise_for_status()
    return response.json()

with open(STATIONS_FILE, encoding="utf-8") as f:
    stations = json.load(f)

stations = sorted(stations, key=lambda s: s["uid"])
print("Stations:", len(stations))

pairs = list(combinations(stations, 2))
print("Pairs:", len(pairs))

first_from, first_to = pairs[0]
print("First pair:", first_from["name"], "->", first_to["name"])

ROUTES_DIR.mkdir(exist_ok=True)

todo = pairs[:TEST_LIMIT] if TEST_LIMIT else pairs
saved, skipped, failed = 0, 0, 0

for i, (from_station, to_station) in enumerate(todo, start=1):
    route_file = ROUTES_DIR / f"{from_station['uid']}_{to_station['uid']}.geojson"

    if route_file.exists():
        skipped += 1
        continue

    try:
        route = get_route(from_station, to_station)
    except requests.RequestException as error:
        print(f"[{i}/{len(todo)}] FAILED {from_station['name']} -> {to_station['name']}: {error}")
        failed += 1
        time.sleep(PAUSE_SECONDS)
        continue

    with open(route_file, "w", encoding="utf-8") as f:
        json.dump(route, f, ensure_ascii=False)

    length = route["features"][0]["properties"]["track-length"]
    print(f"[{i}/{len(todo)}] {from_station['name']} -> {to_station['name']}: {length} m")
    saved += 1
    time.sleep(PAUSE_SECONDS)

print(f"\nSaved: {saved}, skipped (already done): {skipped}, failed: {failed}")