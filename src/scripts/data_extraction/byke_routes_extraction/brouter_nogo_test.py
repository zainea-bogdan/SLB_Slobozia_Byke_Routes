import json
from pathlib import Path

import requests

BROUTER_URL = "https://brouter.de/brouter"
HEADERS = {"User-Agent": "SlobozaBikeRoutes/0.1 (learning project)"}

START_END = "27.361085,44.56612|27.366171,44.565156"

# short line lying on Strada Mihai Viteazu: lon1,lat1,lon2,lat2
NOGO_LINE = "27.365053,44.566232,27.365430,44.565809"
# a point the normal route uses on that street
CHECK_POINT = (27.365053, 44.566232)

OUTPUT_DIR = Path(__file__).parents[3] / "data_sample"


def get_route(extra_params=None):
    params = {
        "lonlats": START_END,
        "profile": "trekking",
        "alternativeidx": 0,
        "format": "geojson",
    }
    if extra_params:
        params.update(extra_params)
    response = requests.get(BROUTER_URL, params=params, headers=HEADERS, timeout=60)
    response.raise_for_status()
    return response.json()


def length_and_time(route):
    props = route["features"][0]["properties"]
    return int(props["track-length"]), int(props["total-time"])


def passes_through(route, point):
    coords = route["features"][0]["geometry"]["coordinates"]
    return any(abs(c[0] - point[0]) < 1e-6 and abs(c[1] - point[1]) < 1e-6 for c in coords)


def main():
    normal = get_route()
    blocked = get_route({"polylines": NOGO_LINE})

    normal_len, normal_time = length_and_time(normal)
    blocked_len, blocked_time = length_and_time(blocked)

    print(f"Normal route:  {normal_len} m, {normal_time} s")
    print(f"Blocked route: {blocked_len} m, {blocked_time} s")
    print()
    print("Check 1, blocked route is longer:       ", blocked_len > normal_len)
    print("Check 2, normal uses Mihai Viteazu:     ", passes_through(normal, CHECK_POINT))
    print("Check 3, blocked avoids Mihai Viteazu:  ", not passes_through(blocked, CHECK_POINT))

    for name, route in [("normal", normal), ("blocked", blocked)]:
        with open(OUTPUT_DIR / f"brouter_{name}.geojson", "w", encoding="utf-8") as f:
            json.dump(route, f, indent=2, ensure_ascii=False)
    print("\nSaved brouter_normal.geojson and brouter_blocked.geojson")


if __name__ == "__main__":
    main()
