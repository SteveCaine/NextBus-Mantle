//
//  TAlertsRequestService.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

extern NSString * const TAlertsErrorDomain;

typedef NS_ENUM(NSInteger, TAlertsErrorCode) {
	TAlertsInvalidParams = 1,
	TAlertsInvalidResponse
};

// ----------------------------------------------------------------------

@interface TAlertsRequestService : NSObject

+ (void)requestV2_success:(void(^)(id data))success
				  failure:(void(^)(NSError *error))failure;

+ (void)requestV4_success:(void(^)(id data))success
				  failure:(void(^)(NSError *error))failure;

@end

// ----------------------------------------------------------------------
