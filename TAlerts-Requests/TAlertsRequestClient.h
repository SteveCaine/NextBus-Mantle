//
//  TAlertsRequestClient.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <AFNetworking/AFNetworking.h>

@interface TAlertsRequestClient : AFHTTPSessionManager

+ (TAlertsRequestClient *)sharedInstance;

- (NSString *)requestV2_success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
					  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSString *)requestV4_success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
					  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
