# Code for 'Extracting Patterns of Functional Space'

This code serves as a proof of concept for the methods presented in the extended
abstract 'Extracting Patterns of Functional Space' at GIScience 2018.

All data are downloaded from OpenStreetMap and stored locally as GeoPackage
files.

For this experiment, the four composition rules distribution, correlation,
occurrence and proximity have been implemented. A set of 63 polygons, outlining
shopping malls in London, UK has been obtained from OpenStreetMap to act as the
individual study areas, along with point geometries of shops, amenities and
public transport stops in a 500m radius and junction points and primary and
secondary highway line geometries in a 5000m radius. Using on these data as
input, a set of composition rules have been applied to each mall. They are
implemented as follows:

```
correlation(c1, c2)
    return (size (c1)/size(c2))
```
```
distribution(c1)
    cc = class-count(c1) # count how many times each class is present
    d = dists(c1) # calculate distance matrix
    return(morans_i (cc, d))
```
```
occurence(c1)
    return(size(c1)) # return the number of features in c1
```
```
proximity(c1, c2)
    p1 = centroid(c1)
    d_total = 0
    for each c2:
        d_total += distance(p1, c2)
    return(d_total/size(c2))
```


- Occurrence shops 500m: Count all shops within a 500m radius
- Occurrence amenities 500m: Count all amenities within a 500m radius
- Occurrence shops: Count all shops within the mall
- Occurrence amenities: Count all amenities within the mall
- Occurrence junctions 5000m: Count all junctions within a 5000m radius
- Occurrence highways 5000m: Count all primary or secondary  within a 5000m
  radius
- Distribution shops 500m: Calculate the spatial autocorrelation for all shops
  within a 500m radius
- Distribution amenities 500m: Calculate the spatial autocorrelation for all
  amenities within a 500m radius
- Proximity shops 500m: Calculate the mean distance from mall center to every
  shop within a 500m radius
- Proximity amenities 500m: Calculate the mean distance from mall center to
  every amenity within a 500m radius
- Proximity transport 500m: Calculate the mean distance from mall center to
  every public transport station within a 500m radius
- Proximity shops: Calculate the mean distance from mall center to every shop
  within the mall
- Proximity amenities: Calculate the mean distance from mall center to every
  amenity within the mall
- Proximity junction 5000m: Calculate the mean distance from mall center to
  every junction within a 5000m radius
- Proximity highway 5000m: Calculate the mean distance from mall center to
  every primary or secondary within a 5000m radius
- Correlation shops/amenities: Calculate the ratio of shops/amenities within the
  mall
