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

//static NSString * const str_path = @"rssfeed4";	// new format
static NSString * const str_path = @"rssfeed2";		// old format, backward compatible

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
			[self.class log_task:task];
			success(task, responseObject);
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		[self.class log_task:task];
		if (failure)
			failure(task, error);
		else
			NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];
	
	NSString *result = str_BaseURL;
	if (str_path.length)
		result = [result stringByAppendingString:str_path];
	// and no params
	
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

// ----------------------------------------------------------------------

+ (void)log_task:(NSURLSessionDataTask *)task {
#ifdef DEBUG_logResponses
	NSURLRequest *request = [task originalRequest];
	NSURL *url = request.URL;
	NSString *requestStr = [url absoluteString];
	MyLog(@" request = '%@'", requestStr);
	
#if DEBUG_logHeadersHTTP
	// log HTTP headers in request and response
	MyLog(@"\n requestHeaders = %@\n", [request allHTTPHeaderFields]);
	
	NSURLResponse *response = [task response];
	if ([response respondsToSelector:@selector(allHeaderFields)]) {
		NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
		MyLog(@" responseHeaders = %@", headers);
	}
#endif
#endif
}

@end

// ----------------------------------------------------------------------
