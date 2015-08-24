//
//  NBRouteConfigRequest.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRequest.h"

// ----------------------------------------------------------------------

typedef enum RouteConfigRequestOptions {
	RouteConfigRequestOption_Default,
	RouteConfigRequestOption_Terse,
	RouteConfigRequestOption_Verbose
} RouteConfigRequestOption;

// ----------------------------------------------------------------------

@interface NBRouteConfigRequest : NBRequest

- (instancetype)initForRoute:(NSString *)routeTag option:(RouteConfigRequestOption)option;

@end

// ----------------------------------------------------------------------
