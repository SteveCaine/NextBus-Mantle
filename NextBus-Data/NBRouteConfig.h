//
//  NBRouteConfig.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

#import "MapKitStructs.h"
#import "MapBounds.h"

// ----------------------------------------------------------------------

@interface NBRouteStop : MTLModel <MTLXMLSerializing>
// attributes
@property (  copy, nonatomic, readonly) NSString *tag;
@property (  copy, nonatomic, readonly) NSString *title;
@property (  copy, nonatomic, readonly) NSString *stopId;
// calculated
@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
@end

// ----------------------------------------------------------------------

@interface NBRoutePath : MTLModel <MTLXMLSerializing>
// attributes
@property (strong, nonatomic, readonly) NSArray *tags;	// of NSString
// calculated
@property (strong, nonatomic, readonly) NSArray *points; // of NSValue-MKCoordinateValue
@end

// ----------------------------------------------------------------------

@interface NBRouteDirection : MTLModel <MTLXMLSerializing>
// attributes
@property (  copy, nonatomic, readonly) NSString *tag;
@property (  copy, nonatomic, readonly) NSString *title;
@property (  copy, nonatomic, readonly) NSString *name;
// NOTE: for 32-bit compatibility, BOOL properties must be implemented as NSNumber internally
@property (assign, nonatomic, readonly) BOOL	  useForUI;
// children
@property (strong, nonatomic, readonly) NSArray	 *stops; // of stop tags
// multiple paths associated with each direction?
@end

// ----------------------------------------------------------------------

@interface NBRouteConfig : MTLModel <MTLXMLSerializing>
// attributes
@property (  copy, nonatomic, readonly) NSString *tag;
@property (  copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) UIColor  *color;
@property (strong, nonatomic, readonly) UIColor  *oppositeColor;
// children
@property (strong, nonatomic)			NSArray	 *directions;
// calculated
@property (strong, nonatomic)			NSDictionary *stops; // by tag
@property (assign, nonatomic, readonly) MapBounds	  bounds;
// when object was created
@property (strong, nonatomic, readonly)	NSDate  *timestamp;

- (void)finish;

//- (NSArray *)visibleDirectionsForStopId:(NSString *)stopId;

- (NSArray *)visibleDirectionsForStopTag:(NSString *)stopTag;

- (NSArray *)stopsForDirectionTag:(NSString *)directionTag;

- (NSArray *)pathsForDirectionTag:(NSString *)directionTag;
@end

// ----------------------------------------------------------------------
