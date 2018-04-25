# Code for 'Extracting Patterns of Functional Space'

This code serves as a proof of concept for the methods presented in the extended
abstract 'Extracting Patterns of Functional Space' at GIScience 2018.

All data are downloaded from OpenStreetMap and stored locally as GeoPackage
files.

Each composition rule is implemented in a way that it may only result in a
boolean value, so every feature under consideration ends up having a set of
values indicating whether or not a certain composition rule is met. Iterating a
number of input features, this results in a boolean matrix, which can be
analyzed further. In this specific example, the places under consideration are
shopping malls. The features used to apply the composition rules to are shops,
amenities, public transport stations, primary and secondary highways, as well as
highway junctions.
