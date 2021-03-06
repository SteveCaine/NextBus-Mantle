//
//  NBPredictionsRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBPredictionsRequest.h"
#import "NBRequest_private.h"

#import "NBPredictions.h"

#import "Categories.h"

// ----------------------------------------------------------------------

static NSString * const key_stopId		= @"stopId";
static NSString * const key_routeTag	= @"routeTag";

static NSString * const key_stopTag		= @"s";
static NSString * const key_routeTag2	= @"r";


// ----------------------------------------------------------------------

@interface NBPredictionsRequest()
@property (strong, nonatomic) NSDictionary *params_;
@end

// ----------------------------------------------------------------------

@implementation NBPredictionsRequest

- (NBPredictionsResponse *)predictionsResponse {
	return [NBPredictionsResponse cast:self.data];
}

// TODO: handle invalid input params

- (instancetype)initWithStopID:(NSString *)stopID {
	self = [super init];
	if (self) {
		// predictions&a=mbta&stopId=02021
		if (stopID.length)
			_params_ = @{ key_stopId : stopID };
	}
	return self;
}

- (instancetype)initWithStopID:(NSString *)stopID routeTag:(NSString *)routeTag {
	self = [super init];
	if (self) {
		// predictions&a=mbta&stopId=02021&routeTag=71
		if (stopID.length && routeTag.length)
			_params_ = @{ key_stopId : stopID, key_routeTag : routeTag };
	}
	return self;
}

- (instancetype)initWithStopTag:(NSString *)stopTag routeTag:(NSString *)routeTag {
	self = [super init];
	if (self) {
		// predictions&a=mbta&r=71&s=2021
		if (stopTag.length && routeTag.length)
			_params_ = @{ key_routeTag2 : routeTag, key_stopTag : stopTag };
	}
	return self;
}

// ----------------------------------------------------------------------

- (NBRequestType)type {
	return NBRequest_predictions;
}

//-staleAge is 0 - never cache response
#if DEBUG_cacheAllResponses
- (double)staleAge {
	return [[NSDate distantFuture] timeIntervalSinceNow];
}
#endif

- (NSDictionary *)params {
	return self.params_;
}

// ----------------------------------------------------------------------

@end

// ----------------------------------------------------------------------
