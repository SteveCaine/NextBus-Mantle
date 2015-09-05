//
//  NBError.h
//  NextBus-Mantle
//
//	any NextBus response may report an error,
//	caller should test by trying to create an error object from the response
//	and then proceed with processing if that error object is -nil-
//
//  Created by Steve Caine on 06/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

// ----------------------------------------------------------------------

@interface NBError : MTLModel <MTLXMLSerializing>
@property (  copy, nonatomic, readonly) NSString *message;
// NOTE: for 32-bit compatibility, BOOL properties must be implemented as NSNumber internally
@property (assign, nonatomic, readonly) BOOL shouldRetry;
@property (strong, nonatomic)			NSDate  *timestamp;
@end

// ----------------------------------------------------------------------
