//
//  NBVehicleLocations.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

#import "MapKitStructs.h"

// ----------------------------------------------------------------------

@interface NBVehicle : MTLModel <MTLXMLSerializing>
// attributes
@property (  copy, nonatomic, readonly) NSString *ID;
@property (  copy, nonatomic, readonly) NSString *routeTag;
@property (  copy, nonatomic, readonly) NSString *dirTag;
@property (assign, nonatomic, readonly) CLLocationDegrees lat, lon;
// (ignore 'secsSinceReport')
// (ignore 'predictable')
// (ignore 'heading')
// calculated
@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
@end

// ----------------------------------------------------------------------

@interface NBVehicleLocations : MTLModel <MTLXMLSerializing>
// attribute from child element
@property (strong, nonatomic, readonly) NSDate	*lastTime;
// children
@property (strong, nonatomic, readonly) NSArray *vehicles;
@end

// ----------------------------------------------------------------------
