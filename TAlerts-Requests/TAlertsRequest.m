//
//  TAlertsRequest.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "TAlertsRequest.h"

#import "TAlerts.h"
#import "TAlertsData.h"
#import "TAlertsRequestClient.h"
#import "TAlertsRequestService.h"

#import "AppDelegate.h"
#import "Categories.h"
#import "FilesUtil.h"

// ----------------------------------------------------------------------

static NSString * const key_talerts = @"talerts";

static NSString * const key_staleAges = @"staleAges";

// set each time we read a new TAlerts response
static double last_ttl;

// ----------------------------------------------------------------------

@interface TAlertsRequest ()

@property (strong, nonatomic) TAlertsList *data;

//+ (id)cachedAlertsForTTL:(double)ttl;
+ (double)timeToLive;

@end

// ----------------------------------------------------------------------

@implementation TAlertsRequest

+ (double)timeToLive {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *appData = [AppDelegate appData];
		NSDictionary *staleAges = appData[key_staleAges];
		// always 'get' here but 'set' current value in static var above
		NSNumber *default_timeToLive = staleAges[key_talerts];		// in days
		if (default_timeToLive == nil)
			default_timeToLive = [NSNumber numberWithDouble:0.1];	// double-default value: ~15 minutes
		last_ttl = [default_timeToLive doubleValue] * 24.0 * 3600;	// in seconds
	});
	return last_ttl;
}

+ (id)cachedAlertsForTTL:(double)ttl {
	id result = nil;
	
	NSString *path = [AppDelegate responseFileForKey:key_talerts];
	if (path.length) {
		NSString *name = [path lastPathComponent];
		NSError *error = nil;
		double age = [FilesUtil ageOfFile:path error:&error];
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
	
	id cachedObject = [self.class cachedAlertsForTTL:[self.class timeToLive]];
	
	if (cachedObject) {
		self.data = cachedObject;
		if (success)
			success(self);
	}
	else {
		[TAlertsRequestService request_success:^(id data) {
			self.data = data;
			TAlertsList *list = [TAlertsList cast:data];
			if (list)
				last_ttl = [list.timeToLive doubleValue];
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

- (TAlertsList *)alertsList {
	return self.data;
}

// ----------------------------------------------------------------------

- (BOOL)isDataStale {
	BOOL result = YES;
	
	if (self.data && [self.class timeToLive] > 0) {
		NSString *path = [AppDelegate responseFileForKey:key_talerts];
		if (path.length) {
			NSError *error = nil;
			double age = [FilesUtil ageOfFile:path error:&error];
			if (error == nil && age < [self.class timeToLive]) {
				result = NO;
			}
		}
	}
	
	return result;
}

@end

// ----------------------------------------------------------------------
