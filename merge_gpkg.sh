type=$1

for f in gpkg/$type*; do
    ogr2ogr -f 'gpkg' -append gpkg/$type.gpkg -append -nln $type $f
done
