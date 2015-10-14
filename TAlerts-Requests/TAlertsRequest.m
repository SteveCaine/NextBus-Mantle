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

static NSString * const key_talerts	  = @"talerts";

static NSString * const key_talertsV2 = @"talerts-rss2";
static NSString * const key_talertsV4 = @"talerts-rss4";

static NSString * const key_staleAges = @"staleAges";

// set each time we read a new TAlerts response
static double last_ttl_rss2;
static double last_ttl_rss4;

// ----------------------------------------------------------------------

typedef void (^block_success)(TAlertsRequest *request);

typedef void (^block_failure)(NSError *error);

// ----------------------------------------------------------------------

@interface TAlertsRequest ()

@property (assign, nonatomic) TAlertFeed   feed;
@property (strong, nonatomic) TAlertsList *data;

+ (double)timeToLiveForFeed:(TAlertFeed)feed;
+ (void)setTimeToLive:(double)ttl forFeed:(TAlertFeed)feed;

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

static TAlertsList* do_success(id data, TAlertFeed feed) {
	TAlertsList *result = [TAlertsList cast:data];
	if (result) {
		[TAlertsRequest setTimeToLive:[result.timeToLive doubleValue] * 24.0 * 3600 forFeed:feed];
	}
	return result;
}

//static void do_failure() {
//}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TAlertsRequest

- (instancetype)init {
	self = [super init];
	if (self) {
		NSAssert(false, @"TAlertsRequest must -init with choice of RSS feed.");
	}
	return self;
}

- (instancetype)initWithFeed:(TAlertFeed)feed {
	self = [super init];
	if (self) {
		_feed = feed;
	}
	return self;
}

// ----------------------------------------------------------------------

+ (double)timeToLiveForFeed:(TAlertFeed)feed {
	static dispatch_once_t onceToken;
	
	static double last_ttl_default;
	
	// always 'get' here but 'set' current value in static vars above
	dispatch_once(&onceToken, ^{
		NSDictionary *appData = [AppDelegate appData];
		NSDictionary *staleAges = appData[key_staleAges];
		NSNumber *default_timeToLive = staleAges[key_talerts];		// in days
		if (default_timeToLive == nil)
			default_timeToLive = [NSNumber numberWithDouble:0.1];	// double-default value: ~15 minutes
		last_ttl_default = [default_timeToLive doubleValue] * 24.0 * 3600;	// in seconds
		last_ttl_rss2 = last_ttl_rss4 = last_ttl_default;
	});
	
	switch (feed) {
		case talerts_rss2:
			return last_ttl_rss2;
			break;
		case talerts_rss4:
			return last_ttl_rss4;
			break;
		default:
			return last_ttl_default;
			break;
	}
}

+ (void)setTimeToLive:(double)ttl forFeed:(TAlertFeed)feed {
	switch (feed) {
		case talerts_rss2:
			last_ttl_rss2 = ttl;
			break;
		case talerts_rss4:
			last_ttl_rss4 = ttl;
			break;
		default:
			break;
	}
}

// ----------------------------------------------------------------------

+ (id)cachedAlertsForFeed:(TAlertFeed)feed { //TTL:(double)ttl
	id result = nil;
	
	NSString *key = nil;
	switch (feed) {
		case talerts_rss2:
			key = key_talertsV2;
			break;
		case talerts_rss4:
			key = key_talertsV4;
			break;
		default:
			break;
	}
	double ttl = [TAlertsRequest timeToLiveForFeed:feed];
	
	if (key.length && ttl > 0.0) {
		NSString *path = [AppDelegate responseFileForKey:key];
		if (path.length) {
			NSString *name = [path lastPathComponent];
			NSError *error = nil;
			double age = [FilesUtil ageOfFile:path error:&error];
			if (error && error.code != NSFileReadNoSuchFileError) {
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
	
	id cachedObject = [self.class cachedAlertsForFeed:self.feed];
	
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
	switch (self.feed) {
		
		case talerts_rss2: {
			[TAlertsRequestService requestV2_success:^(id data) {
				self.data = do_success(data, self.feed);
				if (success)
					success(self);
			} failure:^(NSError *error) {
				if (failure)
					failure(error);
				else
					NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
			}];
		}	break;
		
		case talerts_rss4: {
			[TAlertsRequestService requestV4_success:^(id data) {
				self.data = do_success(data, self.feed);
				if (success)
					success(self);
			} failure:^(NSError *error) {
				if (failure)
					failure(error);
				else
					NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
			}];
		}	break;
		default:
			break;
	}
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
	BOOL result = YES;
	
	if ([self.class timeToLiveForFeed:self.feed] > 0) {
		NSString *path = [AppDelegate responseFileForKey:key_talerts];
		if (path.length) {
			NSError *error = nil;
			double age = [FilesUtil ageOfFile:path error:&error];
			if (error == nil && age < [self.class timeToLiveForFeed:self.feed]) {
				result = NO;
			}
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
