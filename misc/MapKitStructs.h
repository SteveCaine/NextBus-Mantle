//
//  MapKitStructs.h
//	NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#ifndef MantleXMLTester_MapKitStructs_h
#define MantleXMLTester_MapKitStructs_h


// until we include CoreLocation and MapKit headers
typedef double CLLocationDegrees;

typedef struct {
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
} CLLocationCoordinate2D;

typedef double CLLocationDistance;

typedef struct {
	CLLocationDegrees latitudeDelta;
	CLLocationDegrees longitudeDelta;
} MKCoordinateSpan;

typedef struct {
	CLLocationCoordinate2D center;
	MKCoordinateSpan span;
} MKCoordinateRegion;


// until we include 'MapUtil'
typedef struct MapBounds {
	CLLocationDegrees north;
	CLLocationDegrees south;
	CLLocationDegrees east;
	CLLocationDegrees west;
} MapBounds;


#endif