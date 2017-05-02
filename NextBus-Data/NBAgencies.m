//
//  NBAgency.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBAgencies.h"

#import "NSValueTransformer+MTLXMLTransformerAdditions.h"

#import "MantleXMLMacros.h"

// ----------------------------------------------------------------------

@interface NBAgencyList ()
@property (strong, nonatomic, readwrite) NSDate *timestamp;
@end

// ----------------------------------------------------------------------

@implementation NBAgency

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 PROPERTY_FROM_XML_ATTRIBUTE( tag		  ),
			 PROPERTY_FROM_XML_ATTRIBUTE( title		  ),
			 PROPERTY_FROM_XML_ATTRIBUTE( shortTitle  ),
			 PROPERTY_FROM_XML_ATTRIBUTE( regionTitle ),
			 };
}

+ (NSString*)XPathPrefix {
	return @"./";
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"tag='%@', title='%@'", self.tag, self.title];
	if (self.shortTitle.length)
		[result appendFormat:@", (title)='%@'", self.shortTitle];
	[result appendFormat:@", region='%@'", self.regionTitle];
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation NBAgencyList

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 @"agencies" : @"agency"
			 };
}

+ (NSString*)XPathPrefix {
	return @"/body/";
}

+ (NSValueTransformer *)agenciesXMLTransformer {
	return [NSValueTransformer mtl_XMLArrayTransformerWithModelClass:NBAgency.class];
}

- (void)finish {
	self.timestamp = NSDate.date;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	
	int index = 0;
	for (NBAgency *agency in self.agencies) {
		[result appendFormat:@"\n%2i: %@", index++, agency];
	}
	
	return result;
}

@end

// ----------------------------------------------------------------------
