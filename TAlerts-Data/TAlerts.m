//
//  TAlert.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/17/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "TAlerts.h"

#import "NSValueTransformer+MTLXMLTransformerAdditions.h"

#import "MantleXMLMacros.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const elem_pubDate = @"pubDate";

// ----------------------------------------------------------------------

@implementation TAlert

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_CONTENT(title),
			 @"desc"		: @"description/text()",
			 @"direction"	: @"metadata/@direction",
			 PROPERTY_FROM_XML_CONTENT(pubDate),
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

+ (NSValueTransformer *)pubDateXMLTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSArray *nodes) {
		NSDate *result = nil;
		
		DDXMLNode *aNode = [nodes firstObject];
		if (aNode && aNode.kind == DDXMLTextKind && [aNode.parent.name isEqualToString:elem_pubDate]) {
			NSString *pubDateString = aNode.stringValue;
			if ([pubDateString length]) {
				// pubDate is in format 'Fri, 12 Sep 2014 02:26:24 GMT'
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
				result = [formatter dateFromString:pubDateString];
			}
		}
		return result;
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"date = '%@', direction = '%@', title = '%@', desc = '%@'", self.pubDate, self.direction, self.title, self.desc];
	/** /
	[result appendFormat:@"route: tag = '%@', title='%@'", self.routeTag, self.routeTitle];
	[result appendFormat:@", stop: tag = '%@', title='%@'", self.stopTag, self.stopTitle];
	int index = 0;
	for (NBPredictionsDirection *direction in self.directions) {
		[result appendFormat:@"\n%2i: %@", index++, direction];
	}
	/ **/
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation TAlertsList

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 @"alerts"	: @"item"
			 };
}

+ (NSString*)XPathPrefix {
	return @"/rss/channel/";
}

+ (NSValueTransformer *)alertsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[TAlert class]];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	int index = 0;
	for (TAlert *alert in self.alerts) {
		[result appendFormat:@"\n%2i: %@", index++, alert];
	}
	return result;
}

@end

// ----------------------------------------------------------------------
