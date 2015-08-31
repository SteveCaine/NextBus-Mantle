//
//  NBVehicleLocations.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBVehicleLocations.h"

#import "NSValueTransformer+MTLXMLTransformerAdditions.h"

#import "MantleXMLMacros.h"
#import "NSDate+NextBus.h"

#import "Debug_iOS.h"

static NSString * const elem_lastTime = @"lastTime";

static NSString * const attr_time	  = @"time";

// ----------------------------------------------------------------------

@implementation NBVehicle

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 // attributes
			 @"ID"						: @"@id",
			 PROPERTY_FROM_XML_ATTRIBUTE( routeTag	),
			 PROPERTY_FROM_XML_ATTRIBUTE( dirTag	),
			 PROPERTY_FROM_XML_ATTRIBUTE( lat		),
			 PROPERTY_FROM_XML_ATTRIBUTE( lon		),
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D result = {
		self.lat, self.lon
	};
	return result;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"id=%@, route='%@', dir='%@'", self.ID, self.routeTag, self.dirTag];
	CLLocationCoordinate2D coord = self.coordinate;
	[result appendFormat:@", coordinate = { %f, %f } (lat/lon)", coord.latitude, coord.longitude];
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation NBVehicleLocations

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 // children
			 @"vehicles"			: @"vehicle",
			 PROPERTY_FROM_XML_CHILD( lastTime )
			 };
}

+ (NSString*)XPathPrefix {
	return @"/body/";
}

+ (NSValueTransformer *)vehiclesXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[NBVehicle class]];
}

+ (NSValueTransformer *)lastTimeXMLTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSArray *nodes) {
		NSDate *result = nil;
		
		DDXMLNode *aNode = [nodes firstObject];
		if (aNode && aNode.kind == DDXMLElementKind && [aNode.name isEqualToString:elem_lastTime]) {
			
			DDXMLElement *elem = (DDXMLElement *)aNode;
			DDXMLNode *bNode = [elem attributeForName:attr_time];
			if (bNode && bNode.kind == DDXMLAttributeKind && [bNode.name isEqualToString:attr_time]) {
				
				// NextBus's epochTime integer is milliseconds since Jan 1 1970
				NSString *epochString = bNode.stringValue;
				if ([epochString length]) {
					NSTimeInterval epoch = [epochString doubleValue] / 1000.0;
					result = [NSDate dateWithTimeIntervalSince1970:epoch];
				}
			}
		}
		return result;
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	NSString *lastTime = [self.lastTime predictionString_short];
	[result appendFormat:@"lastTime='%@'", lastTime];
	int index = 0;
	for (NBVehicle *vehicle in self.vehicles) {
		[result appendFormat:@"\n%2i: %@", index++, vehicle];
	}
	return result;
}

// ----------------------------------------------------------------------

- (NBVehicle *)vehicleForID:(NSString *)vehicleID {
	NBVehicle *result = nil;
	
	if (vehicleID.length) {
		for (NBVehicle *vehicle in self.vehicles) {
			if ([vehicle.ID isEqualToString:vehicleID]) {
				result = vehicle;
				break;
			}
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
