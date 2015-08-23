//
//  NBRequestService.m
//  ReactiveCocoaTester
//
//  Created by Steve Caine on 06/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRequestService.h"

#import "NBRequestTypes.h"
#import "NBRequestClient.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

@implementation NBRequestService

+ (void)request:(NBRequestType)type
		 params:(NSDictionary *)params
		success:(void(^)(id data))success_
		failure:(void(^)(NSError *error))failure_ {
	
	NBRequestClient *client = [NBRequestClient sharedInstance];
	
	NSString *url = [client request:type params:params success:^(NSURLSessionDataTask *task, id responseObject) {
		if ([responseObject isKindOfClass:[NSData class]]) {
			NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			MyLog(@" response = '%@'", str);
		}
		// here is where we would create NB object from XML data
		id data = nil;
		
		if (success_)
			success_(data);
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		if (failure_)
			failure_(error);
		else
			MyLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];
	MyLog(@" request URL = '%@'", url);
}

// ----------------------------------------------------------------------

+ (void)log_task:(NSURLSessionDataTask *)task {
#ifdef DEBUG
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
