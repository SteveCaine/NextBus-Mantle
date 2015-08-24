//
//  TAlertsRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "TAlertsRequest.h"

#import "TAlerts.h"
#import "TAlertsData.h"
#import "TAlertsRequestClient.h"
#import "TAlertsRequestService.h"

#import "AppDelegate.h"

// ----------------------------------------------------------------------

static NSString * const key_talerts = @"talerts";

// set each time we read a new TAlerts response
static double last_ttl;

// ----------------------------------------------------------------------

@interface TAlertsRequest ()

@property (strong, nonatomic) TAlertsList *data;

+ (id)cachedAlertsForTTL:(double)ttl;

@end

// ----------------------------------------------------------------------

@implementation TAlertsRequest

+ (id)cachedAlertsForTTL:(double)ttl {
	id result = nil;
	
	if (ttl <= 0.0)
		ttl = 15 * 3600; // default: 15 minutes
	
	NSString *path = [AppDelegate responseFileForKey:key_talerts];
	if (path.length) {
		NSString *name = [path lastPathComponent];
		NSError *error = nil;
		double age = [AppDelegate ageOfFile:path error:&error];
		if (error && error.code != NSFileReadNoSuchFileError) {
			NSLog(@"Error checking age of cached file '%@': %@", name, [error localizedDescription]);
		}
		else if (age > 0 && age < ttl) {
			id obj = [TAlertsData alertsForFile:path error:&error];
			if (error) {
				NSLog(@"Error parsing cached file: %@", [error localizedDescription]);
			}
			else
				result = obj;
		}
	}
	return result;
}

- (void)refresh_success:(void(^)(TAlertsRequest *request))success
				failure:(void(^)(NSError *error))failure {
	
	if (last_ttl <= 0.0)
		last_ttl = 15 * 3600; // default: 15 minutes
	
	id cachedObject = [self.class cachedAlertsForTTL:last_ttl];
	
	if (cachedObject) {
		self.data = cachedObject;
		if (success)
			success(self);
	}
	else {
		[TAlertsRequestService request_success:^(id data) {
			self.data = data;
			if (success)
				success(self);
		} failure:^(NSError *error) {
			if (failure)
				failure(error);
			else
				NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
		}];
	}
}

- (id)response {
	return self.data;
}

@end

// ----------------------------------------------------------------------
