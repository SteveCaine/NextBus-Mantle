//
//	NBRoutesRequest.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRoutesRequest.h"
#import "NBRequest_private.h"

#import "NBRoutes.h"

#import "Categories.h"

// ----------------------------------------------------------------------

@implementation NBRoutesRequest

- (NBRouteList *)routeList {
	return [NBRouteList cast:self.data];
}

- (NBRequestType)type {
	return NBRequest_routeList;
}

- (double)staleAge {
#if DEBUG_cacheAllResponses
	return [[NSDate distantFuture] timeIntervalSinceNow];
#endif
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
