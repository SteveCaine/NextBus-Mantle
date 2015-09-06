//
//  NBPredictions.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

// ----------------------------------------------------------------------

@interface NBPrediction : MTLModel <MTLXMLSerializing>
// attributes
@property (strong, nonatomic, readonly) NSDate		*epochTime;
@property (assign, nonatomic, readonly) NSInteger	seconds;
@property (assign, nonatomic, readonly) NSInteger	minutes;
@property (  copy, nonatomic, readonly) NSString	*dirTag;
@property (  copy, nonatomic, readonly) NSString	*vehicle;
// (ignore 'block')
// (ignore 'tripTag')
// NOTE: for 32-bit compatibility, BOOL properties must be implemented as NSNumber internally
//@property (assign, nonatomic, readonly) BOOL isDeparture;
//@property (assign, nonatomic, readonly) BOOL affectedByLayover;
@end

// ----------------------------------------------------------------------

@interface NBPredictionsDirection : MTLModel <MTLXMLSerializing>
// attributes
@property (  copy, nonatomic, readonly) NSString *title;
// children
@property (strong, nonatomic, readonly) NSArray	 *predictions;
@end

// ----------------------------------------------------------------------

@interface NBPredictions : MTLModel <MTLXMLSerializing>
// attributes
// (ignore 'agencyTitle')
@property (  copy, nonatomic, readonly) NSString *routeTag;
@property (  copy, nonatomic, readonly) NSString *routeTitle;
@property (  copy, nonatomic, readonly) NSString *stopTag;
@property (  copy, nonatomic, readonly) NSString *stopTitle;
// children
@property (strong, nonatomic, readonly) NSArray  *directions;
@end

// ----------------------------------------------------------------------

@interface NBPredictionsResponse : MTLModel <MTLXMLSerializing>
// children
@property (strong, nonatomic, readonly) NSArray *predictions;
// when object was created
@property (strong, nonatomic, readonly)	NSDate  *timestamp;

- (void)finish;

- (NSString *)stopTitle;

- (NBPredictions *)predictionsForRoute:(NSString *)routeTag;
@end

// ----------------------------------------------------------------------
