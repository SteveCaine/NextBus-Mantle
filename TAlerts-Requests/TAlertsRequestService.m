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

static NSString * const talerts_file = @"talerts.xml";

// ----------------------------------------------------------------------

@implementation TAlertsRequestService

+ (void)request_success:(void(^)(id data))success
				failure:(void(^)(NSError *error))failure {
	
	TAlertsRequestClient *client = [TAlertsRequestClient sharedInstance];
	
	[client request_success:^(NSURLSessionDataTask *task, id responseObject) {
		NSError *error = nil;
		
		if (![responseObject isKindOfClass:[NSData class]]) {
			NSLog(@"Response is not NSData");
			// TODO: create/return error here
		}
		else {
			NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			MyLog(@" response = '%@'", str);
			
			id alerts = [TAlertsData alertsForXML:responseObject error:&error];
			if (error == noErr) {
				[AppDelegate cacheResponse:responseObject asFile:talerts_file];
				if (success)
					success(alerts);
			}
		}
		if (error)  {
			if (failure)
				failure(error);
			else
				MyLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
		}
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		if (failure)
			failure(error);
		else
			MyLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];
}

@end

// ----------------------------------------------------------------------
