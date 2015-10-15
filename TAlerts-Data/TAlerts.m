//
//  TAlert.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/17/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
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

@property (strong, nonatomic) NSNumber	*messageid;
@property (  copy, nonatomic) NSString	*guid;
@property (  copy, nonatomic) NSString	*mode;
@property (  copy, nonatomic) NSString	*category;

+ (AlertMode)modeForString:(NSString *)name;

@end

// ----------------------------------------------------------------------

@interface TAlertsList ()
@property (strong, nonatomic, readwrite) NSDate *timestamp;
@property (strong, nonatomic)			 NSDictionary *alertsByID;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TAlert

+ (AlertMode)modeForString:(NSString *)name {
	static NSArray *modeNames;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *appData = [AppDelegate appData];
		id array = appData[key_alertModes];
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
			 // for calculated values
			 PROPERTY_FROM_XML_CONTENT(			guid ),
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( messageid,	metadata ),
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( mode,		metadata ),
			 
			 // RSS2 & RSS4
			 PROPERTY_FROM_XML_CONTENT(			title ),
			 @"desc"						: @"description/text()",
			 PROPERTY_FROM_XML_CONTENT(			pubDate ),
			 
			 // RSS2 ONLY
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( line,		metadata ),
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( name,		metadata ),
			 PROPERTY_FROM_XML_CHILD_ATTRIBUTE( direction,	metadata ),
			 
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

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (NSNumber *)ID {
	NSNumber *result = [NSNumber numberWithInteger:0];
	
	if (self.messageid)
		// RSS2: <metadata messageid="70691" ...>
		result = self.messageid;
	else
	if (self.guid.length) {
		// RSS2: <guid isPermaLink="false">talerts70691</guid>
		// RSS4: <guid isPermaLink="false">T-Alert ID 70691</guid>
		// so we trim non-digits from ends of string, then validate what remains is just digits
		NSCharacterSet *nondigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
		NSString *digits = [self.guid stringByTrimmingCharactersInSet:nondigits];
		NSRange range = [digits rangeOfCharacterFromSet:nondigits];
		if (range.location == NSNotFound) {
			result = [NSNumber numberWithInteger:[digits integerValue]];
		}
	}
	return result;
}

- (AlertMode)alertMode {
	if (self.mode.length)
		return [TAlert modeForString:self.mode];
	else
	if (self.category.length)
		return [TAlert modeForString:self.category];
	return AlertMode_other;
}

- (NSString *)description {
#if 1
	NSMutableString *result = [NSMutableString string];
	[result appendFormat:@"alert #%@", self.ID];
//	[result appendFormat:@", lines = '%@'", self.line];
	return result;
#else
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	
	[result appendFormat:@", ID = %@", self.ID];
	[result appendFormat:@", date = '%@'", self.pubDate];
	
	// any of these may be empty/nil
	if (self.direction.length)
		[result appendFormat:@", direction = '%@'", self.direction];
	if (self.title.length)
		[result appendFormat:@", title = '%@'", self.title];
	
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
		[result appendFormat:@", mode='%@'", mode];

	if (self.desc.length)
		[result appendFormat:@", desc = '%@'", self.desc];
	
	return result;
#endif
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TAlertsList

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 @"alerts"		: @"item",
			 @"timeToLive"	: @"ttl"
			 };
}

+ (NSString*)XPathPrefix {
	return @"/rss/channel/";
}

+ (NSValueTransformer *)alertsXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:[TAlert class]];
}

- (void)finish {
	self.timestamp = [NSDate date];
}

- (TAlert *)alertByID:(NSNumber *)inID {
	TAlert *result = nil;
	
	if ([inID integerValue]) {
		if (self.alertsByID == nil) {
			NSMutableDictionary *alertsByID = [NSMutableDictionary dictionaryWithCapacity:self.alerts.count];
			for (TAlert *alert in self.alerts) {
				alertsByID[alert.ID] = alert;
			}
			self.alertsByID = [alertsByID copy];
		}
		result = self.alertsByID[inID];
	}
	return result;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	[result appendFormat:@", ttl = '%@'", self.timeToLive];
	int index = 0;
	for (TAlert *alert in self.alerts) {
		[result appendFormat:@"\n\n%2i: %@", index++, alert];
	}
	return result;
}

@end

// ----------------------------------------------------------------------
