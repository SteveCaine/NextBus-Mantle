//
//  TAlertsRequestClient.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "TAlertsRequestClient.h"

// ----------------------------------------------------------------------
// new format
static NSString * const str_BaseURL = @"http://realtime.mbta.com/alertsrss/";

static NSString * const str_path = @"rssfeed4";

// @"http://realtime.mbta.com/alertsrss/rssfeed2"; // backward compatible

// ----------------------------------------------------------------------

@implementation TAlertsRequestClient

+ (TAlertsRequestClient *)sharedInstance {
	static TAlertsRequestClient *_sharedInstance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[TAlertsRequestClient alloc] initWithBaseURL:[NSURL URLWithString:str_BaseURL]];
	});
	
	return _sharedInstance;
}

// ----------------------------------------------------------------------

- (NSString *)request_success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
					  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
	
	[self GET:str_path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
		if (success) {
			success(task, responseObject);
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		if (failure)
			failure(task, error);
		else
			NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];
	
	return str_BaseURL;
}

// ----------------------------------------------------------------------

- (instancetype)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		self.responseSerializer = [AFHTTPResponseSerializer serializer];
	}
	return self;
}

// ----------------------------------------------------------------------

@end

// ----------------------------------------------------------------------
