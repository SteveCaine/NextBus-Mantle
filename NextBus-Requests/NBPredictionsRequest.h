//
//  NBPredictionsRequest.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRequest.h"

// ----------------------------------------------------------------------

@interface NBPredictionsRequest : NBRequest

- (instancetype)initWithStopID:(NSString *)stopID;

- (instancetype)initWithStopID:(NSString *)stopID routeTag:(NSString *)routeTag;

- (instancetype)initWithStopTag:(NSString *)stopTag routeTag:(NSString *)routeTag;

@end

// ----------------------------------------------------------------------
