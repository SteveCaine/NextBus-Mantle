//
//  NBRoutes.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/18/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
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
@property (strong, nonatomic, readonly)	NSDate  *timestamp;
- (void)finish;
@end

// ----------------------------------------------------------------------
