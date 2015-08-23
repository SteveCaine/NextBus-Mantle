//
//  NextBusRequests.m
//  ReactiveCocoaTester
//
//  Created by Steve Caine on 06/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRequestTypes.h"

static NSString * const requestTypes[] = {
	@"",
	// ----------
	@"agencyList",
	@"routeList",
	@"routeConfig",
	@"predictions", // including 'predictionsForMultiStops'
//	@"schedule",
//	@"messages",
	@"vehicleLocations"
	// ----------------
};
static NSUInteger num_requestTypes = sizeof(requestTypes)/sizeof(requestTypes[0]);

// ----------------------------------------------------------------------

@implementation NextBusRequests

+ (NSUInteger)requestsCount {
	return num_requestTypes;
}

+ (NSString *)nameOfRequest:(NBRequestType)requestType {
	if (requestType > 0 && requestType < num_requestTypes)
		return requestTypes[requestType];
	return nil;
}

+ (NBRequestType)findRequestTypeInName:(NSString *)name {
	if ([name length]) {
		for (NBRequestType type = NBRequestType_begin; type != NBRequestType_end; ++type) {
			if ([name rangeOfString:requestTypes[type]].location != NSNotFound)
				return type;
		}
	}
	return NBRequest_invalid;
}

@end

// ----------------------------------------------------------------------
