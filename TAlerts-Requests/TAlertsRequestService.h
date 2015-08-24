//
//  TAlertsRequestService.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

@interface TAlertsRequestService : NSObject

+ (void)request_success:(void(^)(id data))success
				failure:(void(^)(NSError *error))failure;

@end

// ----------------------------------------------------------------------
