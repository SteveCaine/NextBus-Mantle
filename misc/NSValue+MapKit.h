//
//  NSValue+MapKit.h
//	NextBus-Mantle
//
//  Created by Steve Caine on 05/13/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Foundation/Foundation.h>

#import "MapKitStructs.h"

@interface NSValue (MapKit)

// if MapKit is not @import'ed
#if 1
// NSValue <=> CLLocationCoordinate2D
+ (NSValue *)valueWithMKCoordinate:(CLLocationCoordinate2D)coordinate;
- (CLLocationCoordinate2D) MKCoordinateValue;

// NSValue <=> MKCoordinateSpan
+ (NSValue *)valueWithMKCoordinateSpan:(MKCoordinateSpan)span;
- (MKCoordinateSpan) MKCoordinateSpanValue;
#endif

// NSValue => MKCoordinateRegion
- (MKCoordinateRegion) MKCoordinateRegionValue;

// NSValue <= MKCoordinateRegion
+ (NSValue *)valueWithMKCoordinateRegion:(MKCoordinateRegion)region;

@end
