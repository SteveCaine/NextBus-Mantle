//
//  NBPredictionsRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBPredictionsRequest.h"
#import "NBRequest_private.h"

// ----------------------------------------------------------------------
/** /
typedef enum NBPredictionsOptions {
	NBPredictionsOption_Unknown,
	NBPredictionsOption_StopID,
	NBPredictionsOption_StopIDandRoute,
	NBPredictionsOption_StopTagAndRoute
} NBPredictionsOption;
/ **/
// ----------------------------------------------------------------------

static NSString * const request_key		= @"predictions&a=mbta";
static NSString * const key_stopID		= @"stopId";
static NSString * const key_routeTag	= @"routeTag";

static NSString * const key_stopTag		= @"s";
static NSString * const key_routeTag2	= @"r";


// ----------------------------------------------------------------------

@interface NBPredictionsRequest()
@property (strong, nonatomic) NSDictionary *params_;
@end

// ----------------------------------------------------------------------

@implementation NBPredictionsRequest

// TODO: handle invalid input params

- (instancetype)initWithStopID:(NSString *)stopID {
	self = [super init];
	if (self) {
		// predictions&a=mbta&stopId=02021
		if (stopID.length)
			_params_ = @{ key_stopID : stopID };
	}
	return self;
}

- (instancetype)initWithStopID:(NSString *)stopID routeTag:(NSString *)routeTag {
	self = [super init];
	if (self) {
		// predictions&a=mbta&stopId=02021&routeTag=71
		if (stopID.length && routeTag.length)
			_params_ = @{ key_stopID : stopID, key_routeTag : routeTag };
	}
	return self;
}

- (instancetype)initWithStopTag:(NSString *)stopTag routeTag:(NSString *)routeTag {
	self = [super init];
	if (self) {
		// predictions&a=mbta&r=71&s=2021
		if (stopTag.length && routeTag.length)
			_params_ = @{ key_routeTag2 : routeTag, key_stopID : stopTag };
	}
	return self;
}

// ----------------------------------------------------------------------

- (NBRequestType)type {
	return NBRequest_predictions;
}

//-staleAge is 0 - never cache response

- (NSDictionary *)params {
	return self.params_;
}

// ----------------------------------------------------------------------
/** /
- (NSString *)key {
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
}
/ **/
// ----------------------------------------------------------------------

@end

// ----------------------------------------------------------------------
