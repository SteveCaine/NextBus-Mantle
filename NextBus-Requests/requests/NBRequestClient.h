//
//  NBRequestClient.h
//  ReactiveCocoaTester
//
//  Created by Steve Caine on 06/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "NBRequestTypes.h"

// ----------------------------------------------------------------------

@interface NBRequestClient : AFHTTPSessionManager

+ (NBRequestClient *)sharedInstance;

- (NSString *)request:(NBRequestType)request
			   params:(NSDictionary *)params
			  success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
			  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

// ----------------------------------------------------------------------
