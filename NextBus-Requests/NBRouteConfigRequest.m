//
//  NBRouteConfigRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRouteConfigRequest.h"
#import "NBRequest_private.h"

// ----------------------------------------------------------------------

static NSString * const str_key			= @"routeConfig&a=mbta";
static NSString * const str_key_routeTag= @"r";

static NSString * const option_terse	= @"terse";
static NSString * const option_verbose	= @"verbose";

// ----------------------------------------------------------------------

@interface NBRouteConfigRequest ()
@property (  copy, nonatomic) NSString				  *routeTag;
@property (assign, nonatomic) RouteConfigRequestOption option;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation NBRouteConfigRequest

- (instancetype)initForRoute:(NSString *)routeTag option:(RouteConfigRequestOption)option {
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

- (NSString *)key {
#if 1
	NSMutableString *result = [str_key mutableCopy];
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
	NSString *result = [NSString stringWithFormat:@"%@&r=%@", str_key, self.routeTag];
	switch (self.option) {
		case RouteConfigRequestOption_Terse:
			result = [result stringByAppendingFormat:@"&%@", option_terse];
			break;
		case RouteConfigRequestOption_Verbose:
			result = [result stringByAppendingFormat:@"&%@", option_verbose];
			break;
		case RouteConfigRequestOption_Default:
		default:
			break;
	}
	return result;
#endif
}

// ----------------------------------------------------------------------

- (double)staleAge {
	double staleAge = [super.class staleAgeForType:NBRequest_routeList];
	if (staleAge <= 0)
		staleAge = 30.0 * 24 * 3600; // default: 30 days
	return staleAge;
}

// ----------------------------------------------------------------------

- (NSDictionary *)params {
	NSMutableDictionary *result = [@{ str_key_routeTag : self.routeTag } mutableCopy];
	
	switch (self.option) {
		case RouteConfigRequestOption_Terse:
			result[option_terse] = @"";
			break;
		case RouteConfigRequestOption_Verbose:
			result[option_verbose] = @"";
			break;
		case RouteConfigRequestOption_Default:
		default:
			break;
	}
	return result;
}

@end

// ----------------------------------------------------------------------
