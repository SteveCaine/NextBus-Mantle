//
//  NBRouteConfigRequest.h
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
