//
//  NBRouteConfigRequest.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NBRequest.h"

// ----------------------------------------------------------------------

typedef enum NBRouteConfigOptions {
	NBRouteConfigOption_Default,
	NBRouteConfigOption_Terse,
	NBRouteConfigOption_Verbose
} NBRouteConfigOption;

// ----------------------------------------------------------------------

@interface NBRouteConfigRequest : NBRequest

- (instancetype)initWithRoute:(NSString *)routeTag option:(NBRouteConfigOption)option;

@end

// ----------------------------------------------------------------------
