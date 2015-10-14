//
//	NBRequestClient.m
//	ReactiveCocoaTester
//
//	Created by Steve Caine on 06/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRequestClient.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const str_BaseURL = @"http://webservices.nextbus.com/service/"; //publicXMLFeed?command=

static NSString * const format_path = @"publicXMLFeed?command=%@&a=mbta%@";

// ----------------------------------------------------------------------

@implementation NBRequestClient

+ (NBRequestClient *)sharedInstance {
	static NBRequestClient *_sharedInstance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[NBRequestClient alloc] initWithBaseURL:[NSURL URLWithString:str_BaseURL]];
	});
	
	return _sharedInstance;
}

// ----------------------------------------------------------------------

- (NSString *)request:(NBRequestType)request
			   params:(NSDictionary *)params
			  success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
			  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
	MyLog(@"%s command='%@' params=%@", __FUNCTION__, [NBRequestTypes nameOfRequest:request], params);
	
	NSString *result = nil;

	NSString *command = [NBRequestTypes nameOfRequest:request];

	NSMutableString *str_params = [NSMutableString string];
	NSArray *keys = [params allKeys];
	for (NSString *key in keys) {
		NSString *val = params[key];
		if (val.length)
			[str_params appendFormat:@"&%@=%@", key, val];
		else
			[str_params appendFormat:@"&%@", key];
	}
	
	NSString *path = [NSString stringWithFormat:format_path, command, str_params];
	
	result = [NSString stringWithFormat:@"%@%@", str_BaseURL, path];

	[self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
		log_NSURLSessionDataTask(task, NO);
		if (success) {
			success(task, responseObject);
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		log_NSURLSessionDataTask(task, NO);
		if (failure)
			failure(task, error);
		else
			NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];

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
