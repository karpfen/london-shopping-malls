for f in gpkg/amenity*; do
    echo "$f"
    ogr2ogr -f 'gpkg' -append amenity.gpkg -append -nln amenity $f
done
for f in gpkg/shop*; do
    echo "$f"
    ogr2ogr -f 'gpkg' -append shop.gpkg -append -nln shop $f
done
