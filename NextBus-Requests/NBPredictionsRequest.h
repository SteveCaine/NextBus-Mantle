//
//  NBPredictionsRequest.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRequest.h"

// ----------------------------------------------------------------------

@interface NBPredictionsRequest : NBRequest

- (instancetype)initWithStopID:(NSString *)stopID;

- (instancetype)initWithStopID:(NSString *)stopID routeTag:(NSString *)routeTag;

- (instancetype)initWithStopTag:(NSString *)stopTag routeTag:(NSString *)routeTag;

@end

// ----------------------------------------------------------------------
