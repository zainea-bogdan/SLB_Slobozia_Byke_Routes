import json
from pathlib import Path

import oracledb
from dotenv import load_dotenv
import os

SRC_DIR = Path(__file__).resolve().parents[2]
load_dotenv(SRC_DIR.parent / ".env")
OUTPUT_FILE = SRC_DIR / "data_sample" / "byke_chain_loop.gpx"

QUERY = """
select ch.step,
       sdo_util.to_geojson(
          case
             when ch.from_station_uid < ch.to_station_uid then r.geom
             else sdo_util.reverse_linestring(r.geom)
          end
       ) as leg_geojson
  from slb_byke_chain ch
  join slb_byke_routes r
    on r.from_station_uid = least(ch.from_station_uid, ch.to_station_uid)
   and r.to_station_uid   = greatest(ch.from_station_uid, ch.to_station_uid)
 order by ch.step
"""

oracledb.defaults.fetch_lobs = False

with oracledb.connect(
    user=os.getenv("ORACLE_USER"),
    password=os.getenv("ORACLE_PASSWORD"),
    dsn=os.getenv("ORACLE_DSN"),
) as connection:
    with connection.cursor() as cursor:
        cursor.execute(QUERY)
        rows = cursor.fetchall()

points = []
for step, leg_geojson in rows:
    coordinates = json.loads(leg_geojson)["coordinates"]
    if points:
        coordinates = coordinates[1:]
    points.extend(coordinates)

track_points = "\n".join(
    f'      <trkpt lat="{lat}" lon="{lon}"/>' for lon, lat in points
)

gpx = f"""<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="SLB Slobozia Byke Routes" xmlns="http://www.topografix.com/GPX/1/1">
  <trk>
    <name>Slobozia Bike City - all stations loop</name>
    <trkseg>
{track_points}
    </trkseg>
  </trk>
</gpx>
"""

OUTPUT_FILE.write_text(gpx, encoding="utf-8")
print(f"Legs: {len(rows)}, points: {len(points)}, saved to {OUTPUT_FILE}")


