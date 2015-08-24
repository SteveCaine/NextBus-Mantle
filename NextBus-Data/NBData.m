//
//	NBData.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBData.h"

#import "DDXML.h"
#import "DDXMLElementAdditions.h"

#import "NBError.h"
#import "NBAgencies.h"
#import "NBRoutes.h"
#import "NBRouteConfig.h"
#import "NBPredictions.h"
#import "NBVehicleLocations.h"

#import "NBRequestTypes.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

@implementation NBData

+ (id)dataForFile:(NSString *)path type:(NBRequestType)type error:(NSError **)errorP {
	
	if (path.length && type >= NBRequestType_begin && type < NBRequestType_end) {
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			NSData *data = [NSData dataWithContentsOfFile:path];
			
			if (data.length)
				return [self dataForXML:data type:type error:errorP];
		}
	}
	return nil;
}

// ----------------------------------------------------------------------

+ (id)dataForXML:(NSData *)data type:(NBRequestType)requestType error:(NSError **)errorP {
	id result = nil;
	
	if ([data length]) {
		NSError *error = nil;
		DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
		if (error)
			NSLog(@"Error (1): %@", [error debugDescription]);
		else {
			id obj = nil;
			// standard practice: check every NextBus response for an error;
			// if none found, move on to process response
			obj = [MTLXMLAdapter modelOfClass:[NBError class] fromXMLNode:doc error:&error];
			if (obj) {
				NBError *error = (NBError *)obj;
				// TODO: create/return NSError object here
				NSLog(@"Error (2) - NextBus error in response: %@", error.message);
			}
			else {
				switch (requestType) {
					case NBRequest_agencyList:
						obj = [MTLXMLAdapter modelOfClass:[NBAgencyList class] fromXMLNode:doc error:&error];
						break;
					case NBRequest_routeList:
						obj = [MTLXMLAdapter modelOfClass:[NBRouteList class] fromXMLNode:doc error:&error];
						break;
					case NBRequest_routeConfig:
						obj = [MTLXMLAdapter modelOfClass:[NBRouteConfig class] fromXMLNode:doc error:&error];
						break;
					case NBRequest_predictions:
						obj = [MTLXMLAdapter modelOfClass:[NBPredictionsResponse class] fromXMLNode:doc error:&error];
						break;
					case NBRequest_vehicleLocations:
						obj = [MTLXMLAdapter modelOfClass:[NBVehicleLocations class] fromXMLNode:doc error:&error];
						break;
					default:
						break;
				}
				if (error) {
					if (errorP)
						*errorP = error;
				}
				else
					result = obj;
			}
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
