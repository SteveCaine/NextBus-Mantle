//
//	NBRequest.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRequest.h"
#import "NBRequest_private.h"

#import "AppDelegate.h"
#import "FilesUtil.h"

#import "NBData.h"
#import "NBRequestService.h"

// ----------------------------------------------------------------------

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
			double age = [FilesUtil ageOfFile:path error:&error];
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
	
	id cachedObject = nil;
	// if we cache these requests, check for existing response file in cache
	double staleAge = [self staleAge];
	if (staleAge > 0.0)
		cachedObject = [self.class cachedObjectForKey:[self key] staleAge:[self staleAge]];
	
	if (cachedObject) {
		self.data = cachedObject;
		if (success)
			success(self);
	}
	else {
		// only cache now if we cache such requests
		NSString *cache_key = (staleAge > 0 ? [self key] : nil);
		
		// make request to web service
		[NBRequestService request:[self type] params:[self params] key:cache_key success:^(id data) {
			self.data = data;
			if (success) {
				success(self);
			}
		} failure:^(NSError *error) {
			if (failure)
				failure(error);
			else
				NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
		}];
	}
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
//	NSAssert(false, @"Abstract class 'NBRequest' should never be instantiated.");
//	return nil;
	NSString *str = [NBRequestTypes nameOfRequest:[self type]];
	NSString *request_key = [str stringByAppendingString:@"&a=mbta"];
	
	NSMutableString *result = [request_key mutableCopy];
	NSDictionary *params = [self params];
	NSArray *allKeys = [params allKeys];
	for (NSString *key in allKeys) {
		NSString *val = params[key];
		if (val.length)
			[result appendFormat:@"&%@=%@", key, val];
		else
			[result appendFormat:@"&%@", key];
	}
	return result;
}

- (double)staleAge {
//	NSAssert(false, @"Abstract class 'NBRequest' should never be instantiated.");
	// default is to never use cache
	return 0.0;
}

@end

// ----------------------------------------------------------------------
