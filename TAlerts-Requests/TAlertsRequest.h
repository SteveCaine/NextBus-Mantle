//
//  TAlertsRequest.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------
@class TAlertsList;
// ----------------------------------------------------------------------

@interface TAlertsRequest : NSObject

- (void)refresh_success:(void(^)(TAlertsRequest *request))success
				failure:(void(^)(NSError *error))failure;

- (TAlertsList *)alertsList;

- (BOOL)isDataStale; // will calling -refresh_ create new data object?
					 // (for callers that post-process response)

- (BOOL)isCacheStale; // will calling -refresh_ make request to web service?

@end

// ----------------------------------------------------------------------
