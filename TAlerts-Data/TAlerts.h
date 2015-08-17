//
//  TAlert.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/17/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

// ----------------------------------------------------------------------
// this will move to a new MBTA class
typedef enum ServiceModes {
	ServiceMode_Bus,
	ServiceMode_Subway,
	ServiceMode_Rail,
	ServiceMode_Boat
} ServiceMode;

// ----------------------------------------------------------------------

@interface TAlert : MTLModel <MTLXMLSerializing>
@property (  copy, nonatomic, readonly) NSString	*title;
@property (  copy, nonatomic, readonly) NSString	*desc; // <description>
/** /
@property (assign, nonatomic, readonly) ServiceMode mode;
@property (  copy, nonatomic, readonly) NSString	*line;
@property (  copy, nonatomic, readonly) NSString	*name;
/ **/
@property (  copy, nonatomic, readonly) NSString	*direction;
@property (strong, nonatomic, readonly) NSDate		*pubDate;
// enum: timing, delayTime, delayCategory?
@end

// ----------------------------------------------------------------------

@interface TAlertsList : MTLModel <MTLXMLSerializing>
@property (strong, nonatomic, readonly) NSArray *alerts;
@property (assign, nonatomic, readonly) NSTimeInterval timeToLive; // <ttl>
// language-region?
@end

// ----------------------------------------------------------------------
