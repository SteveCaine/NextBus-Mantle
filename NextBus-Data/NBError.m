//
//  NBError.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/23/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBError.h"

#import "MantleXMLMacros.h"

// ----------------------------------------------------------------------

@interface NBError ()
@property (copy, nonatomic, readwrite) NSString	*message;
@property (assign, nonatomic, readonly) NSNumber *shouldRetry_; // external property is BOOL
@end

// ----------------------------------------------------------------------

@implementation NBError

+ (NSDictionary *)XMLKeyPathsByPropertyKey {
	return @{
			 @"message"	: @"text()",
			 PROPERTY_FROM_XML_ATTRIBUTE( shouldRetry )
			 };
}

+ (NSString*)XPathPrefix {
	return @"/body/Error/";
}

- (NSString *)message {
	if ([_message length]) {
		 _message = [_message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	return _message;
}

- (BOOL)shouldRetry {
	return [self.shouldRetry_ boolValue];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	[result appendFormat:@"shouldRetry=%s", (self.shouldRetry ? "YES" : "NO")];
	[result appendFormat:@", message='%@'", self.message];
	return result;
}

@end

// ----------------------------------------------------------------------
