//
//  NBVehiclesRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBVehiclesRequest.h"
#import "NBRequest_private.h"

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

- (NSDictionary *)params {
	return self.params_;
}

@end

// ----------------------------------------------------------------------
