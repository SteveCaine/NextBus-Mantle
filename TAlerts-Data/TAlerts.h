//
//  TAlert.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/17/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Mantle/Mantle.h>
#import "MTLXMLAdapter.h"

// ----------------------------------------------------------------------
// this will move to a new MBTA class
typedef enum AlertModes {
	AlertMode_other = -1,
	AlertMode_Access,
	AlertMode_Bus,
	AlertMode_Boat,
	AlertMode_Rail,
	AlertMode_Subway,
} AlertMode;

// ----------------------------------------------------------------------

@interface TAlert : MTLModel <MTLXMLSerializing>
@property (assign, nonatomic, readonly) NSNumber	*messageid;
@property (  copy, nonatomic, readonly) NSString	*guid;

@property (  copy, nonatomic, readonly) NSString	*title;
@property (  copy, nonatomic, readonly) NSString	*desc; // <description>
/**/
@property (assign, nonatomic, readonly) AlertMode	alertMode;
@property (  copy, nonatomic, readonly) NSString	*line;
@property (  copy, nonatomic, readonly) NSString	*name;
/**/
@property (  copy, nonatomic, readonly) NSString	*direction;
@property (strong, nonatomic, readonly) NSDate		*pubDate;
// enum: timing, delayTime, delayCategory?
@end

// ----------------------------------------------------------------------

@interface TAlertsList : MTLModel <MTLXMLSerializing>
@property (strong, nonatomic, readonly) NSArray		*alerts;
@property (assign, nonatomic, readonly) NSNumber	*timeToLive; // <ttl>
// language-region?
@property (strong, nonatomic, readonly)	NSDate  *timestamp;

- (void)finish;
@end

// ----------------------------------------------------------------------
