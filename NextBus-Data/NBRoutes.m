//
//  NBRoutes.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/18/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRoutes.h"

#import "NSValueTransformer+MTLXMLTransformerAdditions.h"

#import "MantleXMLMacros.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

@interface NBRouteList ()
@property (strong, nonatomic, readwrite) NSDate *timestamp;
@end

// ----------------------------------------------------------------------

@implementation NBRoute

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( tag	),
			 PROPERTY_FROM_XML_ATTRIBUTE( title	),
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"tag='%@', title='%@'", self.tag, self.title];
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation NBRouteList

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 @"routes" : @"route"
			 };
}

+ (NSString*)XPathPrefix {
	return @"/body/";
}

+ (NSValueTransformer *)routesXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:NBRoute.class];
}

- (void)finish {
	self.timestamp = NSDate.date;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	
	int index = 0;
	for (NBRoute *route in self.routes) {
		[result appendFormat:@"\n%2i: %@", index++, route];
	}
	
	return result;
}

@end

// ----------------------------------------------------------------------
