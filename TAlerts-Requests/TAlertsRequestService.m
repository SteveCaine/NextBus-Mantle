//
//  TAlertsRequestService.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "TAlertsRequestService.h"

#import "TAlerts.h"
#import "TAlertsData.h"
#import "TAlertsRequestClient.h"

#import "AppDelegate.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

NSString * const TAlertsErrorDomain = @"TAlertsErrorDomain";

// ----------------------------------------------------------------------

static NSString * const talertsV2_file = @"talerts-rss2.xml";
static NSString * const talertsV4_file = @"talerts-rss4.xml";

// ----------------------------------------------------------------------

typedef void (^block_success)(id data);

typedef void (^block_failure)(NSError *error);

// ----------------------------------------------------------------------

static void do_success(NSURLSessionDataTask *task, id responseObject, NSString *cacheFile,
					   block_success success, block_failure failure) {
	NSError *error = nil;
	
//	log_NSURLSessionDataTask(task, NO);
	
	if (![responseObject isKindOfClass:[NSData class]]) {
		NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Response object is not JSON data." };
		error = [NSError errorWithDomain:TAlertsErrorDomain code:TAlertsInvalidResponse userInfo:userInfo];
	}
	else {
//		NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//		MyLog(@" response = '%@'", str);
		
		id alerts = [TAlertsData alertsForXML:responseObject error:&error];
		if (error == noErr) {
			[AppDelegate cacheResponse:responseObject asFile:cacheFile];
			if (success)
				success(alerts);
		}
	}
	if (error)  {
		if (failure)
			failure(error);
		else
			NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TAlertsRequestService

+ (void)requestV2_success:(void(^)(id data))success
				  failure:(void(^)(NSError *error))failure {
	
	if (success) { // but failure can be nil
		TAlertsRequestClient *client = [TAlertsRequestClient sharedInstance];
		
		[client requestV2_success:^(NSURLSessionDataTask *task, id responseObject) {
			do_success(task, responseObject, talertsV2_file, success, failure);
			
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			log_NSURLSessionDataTask(task, YES);
			if (failure)
				failure(error);
			else
				NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
		}];
	}
}

// ----------------------------------------------------------------------

+ (void)requestV4_success:(void(^)(id data))success
				  failure:(void(^)(NSError *error))failure {
	
	if (success) { // but failure can be nil
		TAlertsRequestClient *client = [TAlertsRequestClient sharedInstance];
		
		[client requestV4_success:^(NSURLSessionDataTask *task, id responseObject) {
			do_success(task, responseObject, talertsV4_file, success, failure);
			
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			log_NSURLSessionDataTask(task, YES);
			if (failure)
				failure(error);
			else
				NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
		}];
	}
}

@end

// ----------------------------------------------------------------------
