library (dplyr)
library (magrittr)
library (osmdata)
library (sf)

crs_utm_london <- 32630
osm_l <- osmdata::getbb ("London", format_out = "polygon") %>% extract2 (1) %>% extract2 (1)
wkt <- paste0 ("SRID=4326;POLYGON((",
                              paste (paste (osm_l [, 1], osm_l [, 2]), collapse
                                     = ","),
                              "))")
aoi <- st_as_sfc (wkt) %>% st_set_crs (4326) %>% st_transform (crs_utm_london)

bbox_coords <- c (-0.510375, 51.286758, 0.334015, 51.691875)

osm_to_sf <- function (bbox, crs, geom_type, key, value)
{
    feat <- opq (bbox = bbox)
    if (missing (value))
    {
        feat %<>% add_osm_feature (key = key)
    } else
        feat %<>% add_osm_feature (key = key, value = value)
    feat %<>% osmdata_sf %>%
        extract2 (geom_type) %>%
        st_as_sf %>%
        st_transform (crs)

    return (feat)
}

# bus
highway_bus_stop <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "highway", value = "bus_stop", geom_type = "osm_points")
amenity_bus_station <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "amenity", value = "bus_station", geom_type = "osm_points")
public_transport_platform <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "public_transport", value = "platform", geom_type = "osm_points")

# train
public_transport_station <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "public_transport", value = "station", geom_type = "osm_points")
railway_station <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "railway", value = "station", geom_type = "osm_points")

# subway
station_subway <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "station", value = "subway", geom_type = "osm_points")
railway_subway_entrance <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "railway", value = "subway_entrance", geom_type = "osm_points")

# car-related
amenity_parking <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "amenity", value = "parking", geom_type = "osm_points")
amenity_taxi <- osm_to_sf (bbox = bbox_coords, crs = crs_utm_london, key = "amenity", value = "taxi", geom_type = "osm_points")

clip_pts_by_poly <- function (pts, pol)
{
    keep <- st_contains (st_geometry (pol), st_geometry (pts)) %>% extract2 (1)
    pts %<>% extract (keep, )

    return (pts)
}

highway_bus_stop %<>% clip_pts_by_poly (aoi)
amenity_bus_station %<>% clip_pts_by_poly (aoi)
public_transport_platform %<>% clip_pts_by_poly (aoi)
public_transport_station %<>% clip_pts_by_poly (aoi)
railway_station %<>% clip_pts_by_poly (aoi)
station_subway %<>% clip_pts_by_poly (aoi)
railway_subway_entrance %<>% clip_pts_by_poly (aoi)
amenity_parking %<>% clip_pts_by_poly (aoi)
amenity_taxi %<>% clip_pts_by_poly (aoi)

highway_bus_stop %<>% select (c ("name", "geometry"))
amenity_bus_station %<>% select (c ("name", "geometry"))
public_transport_platform %<>% select (c ("name", "geometry"))
public_transport_station %<>% select (c ("name", "geometry"))
railway_station %<>% select (c ("name", "geometry"))
station_subway %<>% select (c ("name", "geometry"))
railway_subway_entrance %<>% select (c ("name", "geometry"))
amenity_parking %<>% select (c ("name", "geometry"))
amenity_taxi %<>% select (c ("name", "geometry"))

fout <- "osm-transport-london.gpkg"
# bus
st_write (highway_bus_stop, layer = "bus - highway:bus_stop", fout)
st_write (amenity_bus_station, layer = "bus - amenity:bus_station", fout)
st_write (public_transport_platform, layer = "bus - public_transport:platform", fout)
# train
st_write (public_transport_station, layer = "train - public_transport:station", fout)
st_write (railway_station, layer = "train - railway:station", fout)
# subway
st_write (station_subway, layer = "subway - station:subway", fout)
st_write (railway_subway_entrance, layer = "subway - railway:subway_entrance", fout)
# car-related
st_write (amenity_parking, layer = "car-related - amenity:parking", fout)
st_write (amenity_taxi, layer = "car-related - amenity:taxi", fout)
st_write (aoi, layer = "london-outline", fout)
