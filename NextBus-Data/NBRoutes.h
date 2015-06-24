//
//  NBRoutes.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/18/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

// ----------------------------------------------------------------------

@interface NBRoute : MTLModel <MTLXMLSerializing>
@property (copy, nonatomic, readonly) NSString *tag;
@property (copy, nonatomic, readonly) NSString *title;
@end

// ----------------------------------------------------------------------

@interface NBRouteList : MTLModel <MTLXMLSerializing>
@property (strong, nonatomic, readonly) NSArray *routes;
@end

// ----------------------------------------------------------------------
