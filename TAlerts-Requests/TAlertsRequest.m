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

// AppData keys
static NSString * const key_talerts	  = @"talerts";
static NSString * const key_staleAges = @"staleAges";

// cached file key (== name of cached file)
static NSString * const key_talertsV4 = @"talerts-rss4";

// set each time we read a new TAlerts response
static double last_ttl_NOW;

// ----------------------------------------------------------------------

typedef void (^block_success)(TAlertsRequest *request);

typedef void (^block_failure)(NSError *error);

// ----------------------------------------------------------------------

@interface TAlertsRequest ()

@property (strong, nonatomic) TAlertsList *data;

+ (double)timeToLive;
+ (void)setTimeToLive:(double)ttl;

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

static TAlertsList* do_success(id data) {
	TAlertsList *result = [TAlertsList cast:data];
	if (result) {
		[TAlertsRequest setTimeToLive:[result.timeToLive doubleValue] * 24.0 * 3600];
	}
	return result;
}

//static void do_failure() {
//}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TAlertsRequest

+ (double)timeToLive {
	static dispatch_once_t onceToken;
	
	// set each time we read a new TAlerts response
	static double last_ttl_default;
	
	// always 'get' here but 'set' current value in static var above
	dispatch_once(&onceToken, ^{
		NSDictionary *appData = [AppDelegate appData];
		NSDictionary *staleAges = appData[key_staleAges];
		NSNumber *default_timeToLive = staleAges[key_talerts];		// in days
		if (default_timeToLive == nil)
			default_timeToLive = [NSNumber numberWithDouble:0.1];	// double-default value: ~15 minutes
		last_ttl_default = [default_timeToLive doubleValue] * 24.0 * 3600;	// in seconds
	});
	return last_ttl_default;
}

+ (void)setTimeToLive:(double)ttl {
	last_ttl_NOW = ttl;
}

// ----------------------------------------------------------------------

+ (id)cachedAlertsForTTL:(double)ttl {
	id result = nil;
	
	if (ttl > 0.0) {
		NSString *path = [AppDelegate responseFileForKey:key_talertsV4];
		if (path.length) {
			NSError *error = nil;
			double age = [FilesUtil ageOfFile:path error:&error];
			if (error && error.code != NSFileReadNoSuchFileError) {
				NSString *name = [path lastPathComponent];
				NSLog(@"Error checking age of cached file '%@': %@", name, [error localizedDescription]);
			}
			else if (age > 0
#if DEBUG_alwaysUseCache
					 && YES
#elif DEBUG_neverUseCache
					 && NO
#else
					 && age < ttl
#endif
					 ) {
				id obj = [TAlertsData alertsForFile:path error:&error];
				if (error) {
					NSLog(@"Error parsing cached file: %@", [error localizedDescription]);
				}
				else
					result = obj;
			}
		}
	}
	return result;
}

// ----------------------------------------------------------------------

- (void)refresh_success:(void(^)(TAlertsRequest *request))success
				failure:(void(^)(NSError *error))failure {
	
	id cachedObject = [self.class cachedAlertsForTTL:last_ttl_NOW];
	
	if (cachedObject) {
		self.data = cachedObject;
		if (success)
			success(self);
	}
	else
		[self forcedRefresh_success:success failure:failure];
}

- (void)forcedRefresh_success:(void(^)(TAlertsRequest *request))success
					  failure:(void(^)(NSError *error))failure {
	[TAlertsRequestService requestV4_success:^(id data) {
		self.data = do_success(data);
		if (success)
			success(self);
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}];
}

- (TAlertsList *)alertsList {
	return self.data;
}

// ----------------------------------------------------------------------

- (BOOL)isDataStale {
	BOOL result = YES;
	
	if (self.data && ![self isCacheStale]) {
		result = NO;
	}
	
	return result;
}

// ----------------------------------------------------------------------

- (BOOL)isCacheStale {
#if DEBUG_neverUseCache
	return YES;
#else
	BOOL result = YES;
#endif
	
	double ttl = last_ttl_NOW;
#if DEBUG_alwaysUseCache
	ttl = [[NSDate distantFuture] timeIntervalSinceNow];
#endif
	
	if (ttl > 0) {
		NSString *path = [AppDelegate responseFileForKey:key_talertsV4];
		if (path.length) {
			NSError *error = nil;
			double age = [FilesUtil ageOfFile:path error:&error];
			if (error == nil && age < ttl) {
				result = NO;
			}
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
