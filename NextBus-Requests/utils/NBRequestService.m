//
//	NBRequestService.m
//	ReactiveCocoaTester
//
//	Created by Steve Caine on 06/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRequestService.h"

#import "NBRequest.h"
#import "NBRequestTypes.h"
#import "NBRequestClient.h"

#import "NBData.h"

#import "AppDelegate.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const xml_file_extension = @"xml";

// ----------------------------------------------------------------------

@implementation NBRequestService

+ (void)request:(NBRequestType)type
		 params:(NSDictionary *)params
			key:(NSString *)key
		success:(void(^)(id data))success
		failure:(void(^)(NSError *error))failure {
	NBRequestClient *client = [NBRequestClient sharedInstance];
	
	[client request:type params:params success:^(NSURLSessionDataTask *task, id responseObject) {
		NSError *error = nil; // for several possible error states
		
		if (![responseObject isKindOfClass:[NSData class]]) {
			NSLog(@"Response is not NSData");
			// TODO: create/return error here
		}
		else {
			NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			MyLog(@" response = '%@'", str);
			
			id data = [NBData dataForXML:responseObject type:type error:&error];
			if (error == noErr) {
				if (key.length) {
					NSString *file = [key stringByAppendingPathExtension:xml_file_extension];
					[AppDelegate cacheResponse:responseObject asFile:file];
				}
				if (success)
					success(data);
			}
		}
		if (error) {
			if (failure)
				failure(error);
			else
				NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];
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
