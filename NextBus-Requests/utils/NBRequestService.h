//
//	NBRequestService.h
//	ReactiveCocoaTester
//
//	Created by Steve Caine on 06/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Foundation/Foundation.h>

#import "NBRequestTypes.h"

// ----------------------------------------------------------------------

extern NSString * const NextBusErrorDomain;

typedef NS_ENUM(NSInteger, NBErrorCode) {
	NextBusInvalidParams = 1,
	NextBusInvalidResponse
};

// ----------------------------------------------------------------------

@interface NBRequestService : NSObject

+ (void)request:(NBRequestType)type
		 params:(NSDictionary *)params
			key:(NSString *)key
		success:(void(^)(id data))success
		failure:(void(^)(NSError *error))failure;

@end

// ----------------------------------------------------------------------
