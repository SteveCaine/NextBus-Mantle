//
//	NBRequest.h
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

@interface NBRequest : NSObject

@property (strong, nonatomic) NSDate *timestamp;

- (void)refresh_success:(void(^)(NBRequest *request))success
				failure:(void(^)(NSError *error))failure;

- (BOOL)isDataStale; // will calling -refresh_ create new data object?
					 // (for callers that post-process response)

@end

// ----------------------------------------------------------------------
