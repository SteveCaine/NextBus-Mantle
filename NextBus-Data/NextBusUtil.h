//
//  NextBusUtil.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
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
	
	NBRequestType_first = NBRequest_agencyList,
	NBRequestType_last  = NBRequest_vehicleLocations
} NBRequestType;

@interface NextBusUtil : NSObject

+ (NSString *)nameOfRequest:(NBRequestType)requestType;

// searches -name- for request name as substring
+ (NBRequestType)findRequestTypeInName:(NSString *)name;

@end
