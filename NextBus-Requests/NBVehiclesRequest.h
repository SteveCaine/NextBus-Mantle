//
//  NBVehiclesRequest.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRequest.h"

@interface NBVehiclesRequest : NBRequest

// we default to epoch=0 - last 15 minutes
- (instancetype)initWithRoute:(NSString *)routeTag /*sinceWhen:(NSDate *)epoch*/;

@end
