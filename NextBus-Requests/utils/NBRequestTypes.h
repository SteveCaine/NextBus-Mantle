//
//	NBRequestTypes.h
//	ReactiveCocoaTester
//
//	Created by Steve Caine on 06/24/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NBRequestTypes {
	NBRequest_invalid,
	NBRequest_agencyList,
	NBRequest_routeList,
	NBRequest_routeConfig,
	NBRequest_predictions, // including 'predictionsForMultiStops'
//	NBRequest_schedule,
//	NBRequest_messages,
	NBRequest_vehicleLocations,
	NBRequestType_end,
	NBRequestType_begin = NBRequest_agencyList
} NBRequestType;

@interface NBRequestTypes : NSObject

+ (NSUInteger)requestsCount;

+ (NSString *)nameOfRequest:(NBRequestType)requestType;

// searches -name- for request name as substring
+ (NBRequestType)findRequestTypeInName:(NSString *)name;

@end
