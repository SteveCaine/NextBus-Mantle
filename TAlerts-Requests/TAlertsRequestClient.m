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

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const str_BaseURL = @"http://realtime.mbta.com/alertsrss/";

static NSString * const str_path_rss2 = @"rssfeed2"; // newer format
static NSString * const str_path_rss4 = @"rssfeed4"; // backward compatible

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

- (NSString *)requestV2_success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
						failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
	return [self request_path:str_path_rss2 success:success failure:failure];
}

// ----------------------------------------------------------------------

- (NSString *)requestV4_success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
						failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
	return [self request_path:str_path_rss4 success:success failure:failure];
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (NSString *)request_path:(NSString *)path
				   success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
				   failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
	
	NSString *result = [NSString stringWithFormat:@"%@%@", str_BaseURL, path];
	
	[self GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//		log_NSURLSessionDataTask(task, NO);
		if (success) {
			success(task, responseObject);
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		log_NSURLSessionDataTask(task, YES);
		if (failure)
			failure(task, error);
		else
			NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];
	MyLog(@"%s returns '%@'", __FUNCTION__, result);
	
	return result;
}

// ----------------------------------------------------------------------

- (instancetype)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		self.responseSerializer = [AFHTTPResponseSerializer serializer];
	}
	return self;
}

@end

// ----------------------------------------------------------------------
