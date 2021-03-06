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
	
	[self GET:path
   parameters:nil
	 headers:nil
	 progress:NULL
	  success:^(NSURLSessionDataTask *task, id responseObject) {
//		log_NSURLSessionDataTask(task, NO);
		if (success) {
#if DEBUG && 0
#warning SIMULATE BROKEN T-ALERTS RESPONSE
			// original bug was a ~30 delay followed by an empty response: '<rss >\n  <channel />\n</rss>'
			// here we simulate that delay by failing to pass on the response XML
#else
			// normal handing - pass XML on to 'success' handler
			success(task, responseObject);
#endif
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		log_NSURLSessionDataTask(task, YES);
		if (failure)
			failure(task, error);
		else
			NSLog(@"%s %@", __FUNCTION__, error.localizedDescription);
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
