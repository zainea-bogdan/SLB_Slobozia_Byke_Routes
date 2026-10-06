import json
import sys
from pathlib import Path

import requests

MAP_URL = "https://api.openstreetmap.org/api/0.6/map.json"
HEADERS = {"User-Agent": "SlobozaBikeRoutes/0.1 (learning project)"}

# west, south, east, north
TEST_BBOX = "27.360,44.562,27.364,44.565"
CITY_BBOX = "27.305918,44.532187,27.409430,44.587655"

OUTPUT_DIR = Path(__file__).parents[2] / "data_sample"
SAMPLE_FILE = OUTPUT_DIR / "slobozia_sample.json"
FINAL_FILE = OUTPUT_DIR / "slobozia_final_map.json"


def fetch_map(bbox):
    response = requests.get(
        MAP_URL,
        params={"bbox": bbox},
        headers=HEADERS,
        timeout=180,
    )
    if response.status_code == 400:
        sys.exit(f"Refused by the API: {response.text}")
    response.raise_for_status()
    return response.json()


def save_json(data, path, indent=None):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=indent, ensure_ascii=False)
    size_mb = path.stat().st_size / 1_000_000
    print(f"  Saved {len(data['elements'])} elements to {path.name} ({size_mb:.1f} MB)")


def main():
    print("Step 1: test request (small box)")
    sample = fetch_map(TEST_BBOX)
    save_json(sample, SAMPLE_FILE, indent=2)

    print("Step 2: final request (whole city)")
    city = fetch_map(CITY_BBOX)
    save_json(city, FINAL_FILE)

    print("Done.")


if __name__ == "__main__":
    main()
