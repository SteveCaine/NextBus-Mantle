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

#import "AppDelegate.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const key_alertModes = @"alertModes";

static NSString * const elem_pubDate = @"pubDate";

// ----------------------------------------------------------------------

@interface TAlert ()
@property (copy, nonatomic) NSString *mode;
+ (AlertMode)modeForString:(NSString *)name;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TAlert

+ (AlertMode)modeForString:(NSString *)name {
	static NSArray *modeNames;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *mbtaData = [AppDelegate mbtaData];
		id array = mbtaData[key_alertModes];
		if ([array isKindOfClass:[NSArray class]])
			modeNames = (NSArray *)array;
	});

	AlertMode result = AlertMode_other;
	
	NSUInteger index = [modeNames indexOfObject:name];
	if (index <= (int) AlertMode_Subway)
		result = (AlertMode) index;
	return result;
}

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( messageid,	metadata ),
			 PROPERTY_FROM_XML_CONTENT(			guid ),
			 
			 PROPERTY_FROM_XML_CONTENT(			title ),
			 
			 @"desc"						: @"description/text()",
			 
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( mode,		metadata ),
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( line,		metadata ),
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( name,		metadata ),
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( direction,	metadata ),
			 
			 PROPERTY_FROM_XML_CONTENT(			pubDate ),
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

- (AlertMode)alertMode {
	return [TAlert modeForString:self.mode];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"date = '%@', direction = '%@', title = '%@', desc = '%@'", self.pubDate, self.direction, self.title, self.desc];
	NSString *mode = nil;
	switch (self.alertMode) {
		case AlertMode_Access:
			mode = @"access";
			break;
		case AlertMode_Bus:
			mode = @"bus";
			break;
		case AlertMode_Boat:
			mode = @"ferry";
			break;
		case AlertMode_Rail:
			mode = @"train";
			break;
		case AlertMode_Subway:
			mode = @"subway";
			break;
		default:
			break;
	}
	if (mode.length)
		[result appendFormat:@"mode='%@'", mode];
	return result;
}

- (NSDictionary *)plist {
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	
	if (self.messageid)	result[@"messageid"] = self.messageid;
	if (self.title)		result[@"title"] = self.title;
	if (self.desc)		result[@"desc"]  = self.desc;
	if (self.mode)		result[@"mode"]  = self.mode;
	if (self.guid)		result[@"guid"]  = self.guid;
	
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
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

- (NSDictionary *)plist {
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	
	NSMutableArray *alerts = [NSMutableArray arrayWithCapacity:self.alerts.count];
	for (TAlert *alert in self.alerts) {
		NSDictionary *plist = [alert plist];
		if (plist.count)
			[alerts addObject:plist];
	}
	result[@"TAlerts"] = alerts;

	return result;
}

@end

// ----------------------------------------------------------------------
