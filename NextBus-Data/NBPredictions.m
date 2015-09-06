//
//  NBPredictions.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBPredictions.h"

#import "NSValueTransformer+MTLXMLTransformerAdditions.h"

#import "MantleXMLMacros.h"
#import "NSDate+NextBus.h"
#import "NSString+NextBus.h"

#import "Debug_iOS.h"

static NSString * const attr_epochTime	= @"epochTime";

// ----------------------------------------------------------------------

@interface NBPredictionsResponse ()
@property (strong, nonatomic, readwrite) NSDate *timestamp;
@end

// ----------------------------------------------------------------------

@implementation NBPrediction

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( epochTime	),
			 PROPERTY_FROM_XML_ATTRIBUTE( seconds	),
			 PROPERTY_FROM_XML_ATTRIBUTE( minutes	),
			 PROPERTY_FROM_XML_ATTRIBUTE( dirTag	),
			 PROPERTY_FROM_XML_ATTRIBUTE( vehicle	)
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

+ (NSValueTransformer *)epochTimeXMLTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSArray *nodes) {
		NSDate *result = nil;
		
		DDXMLNode *aNode = [nodes firstObject];
		if (aNode && aNode.kind == DDXMLAttributeKind && [aNode.name isEqualToString:attr_epochTime]) {
			// NextBus's epochTime integer is milliseconds since Jan 1 1970
			NSString *epochString = aNode.stringValue;
			// moved logic into NSString+NextBus category
			result = [epochString epochTime];
//			if ([epochString length]) {
//				NSTimeInterval epoch = [epochString doubleValue] / 1000.0;
//				result = [NSDate dateWithTimeIntervalSince1970:epoch];
//			}
		}
		return result;
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	NSString *predictionString = [self.epochTime predictionString_short];
	[result appendFormat:@"epoch=%@, minutes=%i, vehicle='%@'", predictionString, (int) self.minutes, self.vehicle];
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBPredictionsDirection

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( title ),
			 // children
			 @"predictions" : @"prediction"
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

+ (NSValueTransformer *)predictionsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[NBPrediction class]];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"title='%@'", self.title];
	int index = 0;
	for (NBPrediction *prediction in self.predictions) {
		[result appendFormat:@"\n%2i: %@", index++, prediction];
	}
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBPredictions

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( routeTag	),
			 PROPERTY_FROM_XML_ATTRIBUTE( routeTitle	),
			 PROPERTY_FROM_XML_ATTRIBUTE( stopTag		),
			 PROPERTY_FROM_XML_ATTRIBUTE( stopTitle	),
			 // children
			 @"directions" : @"direction"
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

+ (NSValueTransformer *)directionsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[NBPredictionsDirection class]];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"route: tag = '%@', title='%@'", self.routeTag, self.routeTitle];
	[result appendFormat:@", stop: tag = '%@', title='%@'", self.stopTag, self.stopTitle];
	int index = 0;
	for (NBPredictionsDirection *direction in self.directions) {
		[result appendFormat:@"\n%2i: %@", index++, direction];
	}
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBPredictionsResponse

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_CHILD( predictions )
			 };
}

+ (NSString*)XPathPrefix {
	return @"/body/";
}

+ (NSValueTransformer *)predictionsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[NBPredictions class]];
}

- (void)finish {
	self.timestamp = [NSDate date];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	int index = 0;
	for (NBPrediction *prediction in self.predictions) {
		[result appendFormat:@"\n%2i: %@", index++, prediction];
	}
	return result;
}

- (NSString *)stopTitle {
	NSString *result = nil;
	for (NBPredictions *p in self.predictions) {
		if (p.stopTitle.length) {
			if (result.length && ![result isEqualToString:p.stopTitle])
				NSLog(@"WARNING: mismatch in NBPredictions stopTitles: '%@' != '%@'", result, p.stopTitle);
			result = p.stopTitle;
		}
	}
	return result;
}

- (NBPredictions *)predictionsForRoute:(NSString *)routeTag {
	NBPredictions *result = nil;
	
	if (routeTag.length) {
		for (NBPredictions *p in self.predictions) {
			if ([p.routeTag isEqualToString:routeTag]) {
				result = p;
				break;
			}
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
