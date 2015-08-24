//
//  TAlertsRequestClient.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface TAlertsRequestClient : AFHTTPSessionManager

+ (TAlertsRequestClient *)sharedInstance;

- (NSString *)request_success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
					  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
