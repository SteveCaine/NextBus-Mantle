//
//  NSValue+MapKit.h
//  Marinalife-oceanalert
//
//  Created by Steve Caine on 05/13/15.
//  Copyright (c) 2015 EarthNC, Inc. All rights reserved.
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
