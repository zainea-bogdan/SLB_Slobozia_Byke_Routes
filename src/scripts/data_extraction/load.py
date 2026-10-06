import json
import os
from pathlib import Path

import oracledb
from dotenv import load_dotenv

DATA_FILE = Path(__file__).parents[2] / "data_sample" / "slobozia_final_map.json"

INSERT_SQL = """
    INSERT INTO stg_osm_map (bbox_north, bbox_west, bbox_south, bbox_east, payload)
    VALUES (:north, :west, :south, :east, :payload)
"""

with open(DATA_FILE, encoding="utf-8") as f:
    payload_text = f.read()

data = json.loads(payload_text)

bounds = data["bounds"]

load_dotenv()

with oracledb.connect(
    user=os.environ["ORACLE_USER"],
    password=os.environ["ORACLE_PASSWORD"],
    dsn=os.environ["ORACLE_DSN"],
) as connection:
    with connection.cursor() as cursor:
        cursor.setinputsizes(payload=oracledb.DB_TYPE_CLOB)
        cursor.execute(INSERT_SQL, {
            "north": bounds["maxlat"],
            "west": bounds["minlon"],
            "south": bounds["minlat"],
            "east": bounds["maxlon"],
            "payload": payload_text,
        })
    connection.commit()
    print("Inserted 1 row with", len(data["elements"]), "elements")
