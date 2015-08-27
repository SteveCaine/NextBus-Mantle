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

@interface NBRequestService : NSObject

+ (void)request:(NBRequestType)type
		 params:(NSDictionary *)params
			key:(NSString *)key
		success:(void(^)(id data))success
		failure:(void(^)(NSError *error))failure;

@end

// ----------------------------------------------------------------------
