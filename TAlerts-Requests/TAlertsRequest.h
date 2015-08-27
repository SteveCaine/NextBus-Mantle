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

@interface TAlertsRequest : NSObject

- (void)refresh_success:(void(^)(TAlertsRequest *request))success
				failure:(void(^)(NSError *error))failure;

- (id)response;

@end

// ----------------------------------------------------------------------
