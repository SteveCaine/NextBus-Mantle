//
//	NBRequest.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRequest.h"
#import "NBRequest_private.h"

#import "AppDelegate.h"
#import "NBData.h"
#import "NBRequestService.h"

// ----------------------------------------------------------------------

static NSString * const str_urlRoot = @"http://webservices.nextbus.com/service/publicXMLFeed?command=";

static NSString * const key_staleAges = @"staleAges";

// ----------------------------------------------------------------------

@implementation NBRequest

+ (id)cachedObjectForKey:(NSString *)key staleAge:(double)staleAge {
	id result = nil;
	
	if (key.length && staleAge > 0) {
		NSString *path = [AppDelegate responseFileForKey:key];
		if (path.length) {
			NSString *name = [path lastPathComponent];
			NSError *error = nil;
			double age = [AppDelegate ageOfFile:path error:&error];
			if (error && error.code != NSFileReadNoSuchFileError) {
				NSLog(@"Error checking age of cached file '%@': %@", name, [error localizedDescription]);
			}
			else if (age > 0 && age < staleAge) {
				// string up to first '&' should be name of request
				NSRange range = [name rangeOfString:@"&"];
				if (range.location != NSNotFound) {
					NSString *prefix = [name substringToIndex:range.location];
					NBRequestType type = [NBRequestTypes findRequestTypeInName:prefix];
					if (type != NBRequest_invalid) {
						id obj = [NBData dataForFile:path type:type error:&error];
						if (error)
							NSLog(@"Error reading cached XML file: %@", [error localizedDescription]);
						else
							result = obj; // SUCCESS
					}
				}
			}
		}
	}
	
	return result;
}

// ----------------------------------------------------------------------

+ (double)staleAgeForType:(NBRequestType)type  {
	double result = 0.0;
	
	NSDictionary *appData = [AppDelegate appData];
	if (appData) {
		NSDictionary *staleAges = appData[key_staleAges];
		if (staleAges) {
			NSString *name = [NBRequestTypes nameOfRequest:type];
			if (name.length) {
				NSNumber *staleAge = staleAges[name];		 // in days
				result = [staleAge doubleValue] * 24 * 3600; // seconds
			}
		}
	}
	return result;
}

// ----------------------------------------------------------------------

- (void)refresh_success:(void(^)(NBRequest *request))success
				failure:(void(^)(NSError *error))failure {
	// check for existing response file in our cache
	id cachedObject = [self.class cachedObjectForKey:[self key] staleAge:[self staleAge]];
	if (cachedObject) {
		self.data = cachedObject;
		if (success)
			success(self);
	}
	else {
		// make request to web service
		[NBRequestService request:[self type] params:[self params] key:[self key] success:^(id data) {
			self.data = data;
			if (success) {
				success(self);
			}
		} failure:^(NSError *error) {
			if (failure)
				failure(error);
			else
				NSLog(@"Error: %@", [error localizedDescription]);
		}];
	}
}

// ----------------------------------------------------------------------

- (id)response {
	return self.data;
}

// ----------------------------------------------------------------------

- (NSDictionary *)params {
	NSAssert(false, @"Abstract class 'NBRequest' should never be instantiated.");
	return nil;
}

- (NBRequestType)type {
	NSAssert(false, @"Abstract class 'NBRequest' should never be instantiated.");
	return NBRequest_invalid;
}

- (NSString *)key {
	NSAssert(false, @"Abstract class 'NBRequest' should never be instantiated.");
	return nil;
}

- (double)staleAge {
	NSAssert(false, @"Abstract class 'NBRequest' should never be instantiated.");
	return 0.0;
}

@end

// ----------------------------------------------------------------------
