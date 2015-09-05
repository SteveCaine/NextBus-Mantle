//
//  NBAgency.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//
//  This code is distributed under the terms of the MIT license.
//
//  Copyright (c) 2015 Steve Caine.
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
@property (strong, nonatomic)			NSDate  *timestamp;
@end

// ----------------------------------------------------------------------
