//
//	NBRoutesRequest.h
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRequest.h"

@class NBRouteList;

@interface NBRoutesRequest : NBRequest

- (NBRouteList *)routeList;

@end
