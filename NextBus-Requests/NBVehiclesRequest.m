//
//  NBVehiclesRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBVehiclesRequest.h"
#import "NBRequest_private.h"

#import "NBVehicleLocations.h"

#import "Categories.h"

// ----------------------------------------------------------------------

static NSString * const request_key		= @"vehicleLocations&a=mbta";
static NSString * const key_routeTag	= @"routeTag";
static NSString * const key_sinceWhen	= @"t";

// ----------------------------------------------------------------------

@interface NBVehiclesRequest ()
@property (strong, nonatomic) NSDictionary *params_;
@end

// ----------------------------------------------------------------------

@implementation NBVehiclesRequest

- (NBVehicleLocations *)vehicles {
	return [NBVehicleLocations cast:self.data];
}

- (instancetype)initWithRoute:(NSString *)routeTag /*sinceWhen:(NSDate *)epoch*/ {
	self = [super init];
	if (self) {
		if (routeTag.length)
			_params_ = @{ key_routeTag : routeTag, key_sinceWhen : @"0" };
	}
	return self;
}

- (NBRequestType)type {
	return NBRequest_vehicleLocations;
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

@end

// ----------------------------------------------------------------------
