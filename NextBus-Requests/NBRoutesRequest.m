//
//	NBRoutesRequest.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRoutesRequest.h"

#import "NBRequest_private.h"

#import "NBRequestTypes.h"

// ----------------------------------------------------------------------

static NSString * const str_key = @"routeList&a=mbta";

// ----------------------------------------------------------------------

@implementation NBRoutesRequest

- (NBRequestType)type {
	return NBRequest_routeList;
}

- (NSString *)key {
	return str_key;
}

- (double)staleAge {
	double staleAge = [super.class staleAgeForType:NBRequest_routeList];
	if (staleAge <= 0)
		staleAge = 30.0 * 24 * 3600; // default: 30 days
	return staleAge;
}

- (NSDictionary *)params {
	return nil;
}

@end

// ----------------------------------------------------------------------
