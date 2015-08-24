//
//	NBRequest.h
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

@interface NBRequest : NSObject

- (void)refresh_success:(void(^)(NBRequest *request))success
				failure:(void(^)(NSError *error))failure;

- (id)response;

@end

// ----------------------------------------------------------------------
