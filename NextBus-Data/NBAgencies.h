//
//  NBAgency.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

// ----------------------------------------------------------------------

@interface NBAgency : MTLModel <MTLXMLSerializing>
@property (copy, nonatomic, readonly) NSString *tag;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *shortTitle;
@property (copy, nonatomic, readonly) NSString *regionTitle;
@end

// ----------------------------------------------------------------------

@interface NBAgencyList : MTLModel <MTLXMLSerializing>
@property (strong, nonatomic, readonly) NSArray *agencies;
@end

// ----------------------------------------------------------------------
