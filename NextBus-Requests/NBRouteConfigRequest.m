//
//  NBRouteConfigRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRouteConfigRequest.h"
#import "NBRequest_private.h"

#import "NBRouteConfig.h"

#import "Categories.h"

// ----------------------------------------------------------------------

static NSString * const request_key		= @"routeConfig&a=mbta";
static NSString * const key_routeTag	= @"r";

static NSString * const option_terse	= @"terse";
static NSString * const option_verbose	= @"verbose";

// ----------------------------------------------------------------------

@interface NBRouteConfigRequest ()
@property (  copy, nonatomic) NSString				  *routeTag;
@property (assign, nonatomic) NBRouteConfigOption option;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBRouteConfigRequest

- (NBRouteConfig *)routeConfig {
	return [NBRouteConfig cast:self.data];
}

- (instancetype)init {
	self = [super init];
	if (self) {
		NSAssert(false, @"Route Config requests must specify a route.");
	}
	return self;
}

- (instancetype)initWithRoute:(NSString *)routeTag option:(NBRouteConfigOption)option {
	self = [super init];
	if (self) {
		_routeTag = routeTag;
		_option = option;
	}
	return self;
}

// ----------------------------------------------------------------------

- (NBRequestType)type {
	return NBRequest_routeConfig;
}

// ----------------------------------------------------------------------
/** /
- (NSString *)key {
#if 1
	NSMutableString *result = [request_key mutableCopy];
	NSDictionary *params = [self params];
	NSArray *allKeys = [params allKeys];
	for (NSString *key in allKeys) {
		NSString *val = params[key];
		if (val.length)
			[result appendFormat:@"&%@=%@", key, val];
		else
			[result appendFormat:@"&%@", key];
	}
	return result;
#else
	NSString *result = [NSString stringWithFormat:@"%@&r=%@", request_key, self.routeTag];
	switch (self.option) {
		case NBRouteConfigOption_Terse:
			result = [result stringByAppendingFormat:@"&%@", option_terse];
			break;
		case NBRouteConfigOption_Verbose:
			result = [result stringByAppendingFormat:@"&%@", option_verbose];
			break;
		case NBRouteConfigOption_Default:
		default:
			break;
	}
	return result;
#endif
}
/ **/
// ----------------------------------------------------------------------

- (double)staleAge {
	double staleAge = [super.class staleAgeForType:NBRequest_routeList];
	if (staleAge <= 0)
		staleAge = 30.0 * 24 * 3600; // default: 30 days
	return staleAge;
}

// ----------------------------------------------------------------------

- (NSDictionary *)params {
	NSMutableDictionary *result = nil;
	
	if (self.routeTag.length)
		result = [@{ key_routeTag : self.routeTag } mutableCopy];
	
	switch (self.option) {
		case NBRouteConfigOption_Terse:
			result[option_terse] = @"";
			break;
		case NBRouteConfigOption_Verbose:
			result[option_verbose] = @"";
			break;
		case NBRouteConfigOption_Default:
		default:
			break;
	}
	return result;
}

@end

// ----------------------------------------------------------------------
