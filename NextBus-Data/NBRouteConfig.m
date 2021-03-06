//
//  NBRouteConfig.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRouteConfig.h"

#import "NSValueTransformer+MTLXMLTransformerAdditions.h"

#import "NSString+NextBus.h"
#import "NSValue+MapKit.h"

#import "MantleXMLMacros.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const elem_stop			= @"stop";
static NSString * const elem_tag			= @"tag";
static NSString * const elem_point			= @"point";

static NSString * const attr_color			= @"color";
static NSString * const attr_oppositeColor	= @"oppositeColor";

static NSString * const attr_tag			= @"tag";
static NSString * const attr_id				= @"id";
static NSString * const attr_lat			= @"lat";
static NSString * const attr_lon			= @"lon";

// ----------------------------------------------------------------------

@interface NBRouteStop ()
// attributes
@property (assign, nonatomic, readonly) CLLocationDegrees lat, lon;
@end

// ----------------------------------------------------------------------

@interface NBRouteDirection ()
@property (strong, nonatomic, readonly) NSNumber *useForUI_; // external property is BOOL
@end

// ----------------------------------------------------------------------

@interface NBRouteConfig ()
// attributes
@property (assign, nonatomic, readonly ) CLLocationDegrees latMin, latMax, lonMin, lonMax;
// children
@property (strong, nonatomic, readonly ) NSArray	*a_stops;
@property (strong, nonatomic, readonly ) NSArray	*a_paths;
// calculated
@property (assign, nonatomic, readwrite) MapBounds	bounds;
@property (strong, nonatomic, readwrite) NSDate		*timestamp;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBRouteStop

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( tag		),
			 PROPERTY_FROM_XML_ATTRIBUTE( title		),
			 PROPERTY_FROM_XML_ATTRIBUTE( lat		),
			 PROPERTY_FROM_XML_ATTRIBUTE( lon		),
			 PROPERTY_FROM_XML_ATTRIBUTE( stopId	),
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

// ----------------------------------------------------------------------

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D result = {
		self.lat, self.lon
	};
	return result;
}

// ----------------------------------------------------------------------

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"tag='%@', title='%@'", self.tag, self.title];
	CLLocationCoordinate2D coordinate = self.coordinate;
	[result appendFormat:@", coordinate={ %f, %f } (lat/lon)", coordinate.latitude, coordinate.longitude];
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBRoutePath

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 // children
			 @"tags"	: @"tag", // just strings (route path IDs?)
			 @"points"	: @"point",
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

// ----------------------------------------------------------------------

+ (NSValueTransformer *)tagsXMLTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *nodes, BOOL *success, NSError **error) {
		
		NSMutableArray *result = [NSMutableArray arrayWithCapacity:nodes.count];
		for (DDXMLElement *elem in nodes) {
			
			NSString *tag_id = [elem attributeForName:attr_id].stringValue;
			if (tag_id.length)
				[result addObject:tag_id];
		}
		return result;
	}];
}

+ (NSValueTransformer *)pointsXMLTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *nodes, BOOL *success, NSError **error) {
		
		NSMutableArray *result = [NSMutableArray arrayWithCapacity:nodes.count];
		for (DDXMLElement *elem in nodes) {
			
			NSString *str_lat = [elem attributeForName:attr_lat].stringValue;
			NSString *str_lon = [elem attributeForName:attr_lon].stringValue;
			
			if (str_lat.length && str_lon.length) {
				CLLocationCoordinate2D coordinate = { str_lat.doubleValue, str_lon.doubleValue };
				NSValue *value = [NSValue valueWithMKCoordinate:coordinate];
				[result addObject:value];
			}
		}
		return result;
	}];
}

// ----------------------------------------------------------------------

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	
	[result appendFormat:@"\n with %lu tags", self.tags.count];
#if 0
	int index = 0;
	for (NSString *tag_id in self.tags) {
		[result appendFormat:@"\n%3i: %@", index++, tag_id];
	}
#endif
	
	[result appendFormat:@"\n with %lu points", self.points.count];
#if 0
	int index = 0;
	for (NSValue *point in self.points) {
		CLLocationCoordinate2D coordinate = [point MKCoordinateValue];
		[result appendFormat:@"\n%3i: coordinate={ %f, %f } (lat/lon)", index++, coordinate.latitude, coordinate.longitude];
	}
#endif
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBRouteDirection

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( tag		),
			 PROPERTY_FROM_XML_ATTRIBUTE( title		),
			 PROPERTY_FROM_XML_ATTRIBUTE( name		),
			 @"useForUI_"				: @"@useForUI",

			 // children
			 @"stops"					: @"stop" // just stop tags
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

// ----------------------------------------------------------------------

+ (NSValueTransformer *)stopsXMLTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *nodes, BOOL *success, NSError **error) {
		
		NSMutableArray *result = [NSMutableArray arrayWithCapacity:nodes.count];
		for (DDXMLElement *elem in nodes) {
			NSString *tag = [elem attributeForName:attr_tag].stringValue;
			if (tag.length)
				[result addObject:tag];
		}
		return result;
	}];
}

- (BOOL)useForUI {
	return self.useForUI_.boolValue;
}

// ----------------------------------------------------------------------

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"tag='%@', title='%@', name='%@', useForUI=%s", self.tag, self.title, self.name, (self. useForUI ? "YES" : "NO")];
	[result appendFormat:@"\n with %lu stops", self.stops.count];
#if 0
	int index = 0;
	for (NBRouteStop *stop in self.stops) {
		[result appendFormat:@"\n%3i: %@", index++, stop];
	}
#endif
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBRouteConfig

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( tag			),
			 PROPERTY_FROM_XML_ATTRIBUTE( title			),
			 PROPERTY_FROM_XML_ATTRIBUTE( color			),
			 PROPERTY_FROM_XML_ATTRIBUTE( oppositeColor	),
			 PROPERTY_FROM_XML_ATTRIBUTE( latMin		),
			 PROPERTY_FROM_XML_ATTRIBUTE( latMax		),
			 PROPERTY_FROM_XML_ATTRIBUTE( lonMin		),
			 PROPERTY_FROM_XML_ATTRIBUTE( lonMax		),
			 // children
			 @"directions"  : @"direction",
			 @"a_stops"		: @"stop",
			 @"a_paths"		: @"path",
			 };
}

+ (NSString*)XPathPrefix {
	return @"/body/route/";
}

// ----------------------------------------------------------------------

+ (NSValueTransformer *)colorXMLTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *nodes, BOOL *success, NSError **error) {
		NSString *colorString = nil;
		
		DDXMLNode *aNode = nodes.firstObject;
		if (aNode && aNode.kind == DDXMLAttributeKind && [aNode.name isEqualToString:attr_color])
			colorString = aNode.stringValue;
		return colorString.colorValue;
	}];
}

+ (NSValueTransformer *)oppositeColorXMLTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *nodes, BOOL *success, NSError **error) {
		NSString *colorString = nil;
		
		DDXMLNode *aNode = nodes.firstObject;
		if (aNode && aNode.kind == DDXMLAttributeKind && [aNode.name isEqualToString:attr_oppositeColor])
			colorString = aNode.stringValue;
		return colorString.colorValue;
	}];
}

+ (NSValueTransformer *)directionsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:NBRouteDirection.class];
}

+ (NSValueTransformer *)a_stopsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:NBRouteStop.class];
}

+ (NSValueTransformer *)a_pathsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:NBRoutePath.class];
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (void)finish {
	self.timestamp = NSDate.date;

	NSMutableDictionary *stops = [NSMutableDictionary dictionary];
	for (NBRouteStop *stop in self.a_stops) {
		stops[stop.tag] = stop;
	}
	self.stops = [stops copy];
	
	MapBounds bounds = {
		self.latMax, self.latMin, self.lonMax, self.lonMin
	};
	self.bounds = bounds;
}

// ----------------------------------------------------------------------

- (NSArray *)visibleDirectionsForStopTag:(NSString *)stopTag {
	NSMutableArray *result = nil;
	
	if (stopTag.length) {
		for (NBRouteDirection *direction in self.directions) {
			if (direction.useForUI) {
				for (NSString *stop in direction.stops) {
					if ([stop isEqualToString:stopTag]) {
						if (result == nil)
							result = @[].mutableCopy;
						[result addObject:direction];
						break;
					}
				}
			}
		}
	}
//	MyLog(@"%s (%@ : %@) returns %lu directions", __FUNCTION__, self.tag, stopTag, result.count);
	return result;
}

// ----------------------------------------------------------------------

- (NSArray *)stopsForDirectionTag:(NSString *)directionTag {
	NSMutableArray *result = nil;
	
	if (directionTag.length) {
		for (NBRouteDirection *direction in self.directions) {
			if ([direction.tag isEqualToString:directionTag]) {
				for (NSString *stopTag in direction.stops) {
					NBRouteStop *stop = self.stops[stopTag];
					if (stop) {
						if (result == nil)
							result = @[].mutableCopy;
						[result addObject:stop];
					}
				}
				break;
			}
		}
	}
//	MyLog(@"%s (%@ : %@) returns %lu stops", __FUNCTION__, self.tag, directionTag, result.count);
	return result;
}

// ----------------------------------------------------------------------
// path tags begin with a direction tag; each path can have multiple tags

- (NSArray *)pathsForDirectionTag:(NSString *)directionTag {
	NSMutableArray *result = nil;
	
	if (directionTag.length) {
		for (NBRoutePath *path in self.a_paths) {
			for (NSString *tag in path.tags) {
				if ([tag hasPrefix:directionTag]) {
					if (result == nil)
						result = @[].mutableCopy;
					[result addObject:path];
					break;
				}
			}
		}
	}
//	MyLog(@"%s (%@ : %@) returns %lu paths", __FUNCTION__, self.tag, directionTag, result.count);
	return result;
}

// ----------------------------------------------------------------------

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"tag='%@', title='%@'", self.tag, self.title];
	[result appendFormat:@", color='%@', oppositeColor='%@'", self.color, self.oppositeColor];
	MapBounds bounds = self.bounds;
	[result appendFormat:@", bounds={ %f, %f, %f, %f } (NSEW)", bounds.north, bounds.south, bounds.east, bounds.west];
	
	[result appendFormat:@"\n with %lu stops",		self.a_stops.count];
	[result appendFormat:@"\n with %lu directions",	self.directions.count];
#if 1
	[result appendFormat:@"\n with %lu paths",		self.a_paths.count];
#elif 0
	[result appendFormat:@"\n\n with %lu stops",	self.a_stops.count];
	int index = 0;
	for (NBRouteStop *stop in self.a_stops) {
		[result appendFormat:@"\n%3i: %@", index++, stop];
	}
	[result appendFormat:@"\n\n with %lu directions", self.directions.count];
	index = 0;
	for (NBRouteDirection *direction in self.directions) {
		[result appendFormat:@"\n\n%2i: %@", index++, direction];
	}
#else
	[result appendFormat:@"\n\n with %lu paths", self.a_paths.count];
	int index = 0;
	for (NBRouteStop *path in self.a_paths) {
		[result appendFormat:@"\n\n%2i: %@", index++, path];
	}
#endif
	return result;
}

@end

// ----------------------------------------------------------------------
