import psycopg2
import time
from geopy.geocoders import Nominatim

con = psycopg2.connect(database="dvdrental", user="postgres",
                       password="postgres", host="127.0.0.1", port="5432")

geolocator = Nominatim(user_agent="curl")

cur = con.cursor()
cur.execute('ALTER TABLE address ADD COLUMN IF NOT EXISTS latitude VARCHAR(255) DEFAULT (\'0\');')
cur.execute('ALTER TABLE address ADD COLUMN IF NOT EXISTS longitude VARCHAR(255) DEFAULT (\'0\');')
con.commit()
cur.callproc('get_address_and_city_for_ex1')
rows = cur.fetchall()
for row in rows:
    print(row[0])
    location = geolocator.geocode(row[0], timeout=None)
    lat = 0
    lon = 0
    if location is not None:
        print(location.address)
        print((location.latitude, location.longitude))
        lat = location.latitude
        lon = location.longitude

    addr = row[0].split(', ')
    cur.execute(f'UPDATE address SET latitude=\'{lat}\', longitude=\'{lon}\' WHERE address=\'{addr[0]}\' and city_id=\'{addr[1]}\'')
    time.sleep(1)

con.commit()
