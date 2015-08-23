//
//  NSDate+NextBus.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "NSDate+NextBus.h"

typedef enum {
	PredictionString_long,
	PredictionString_short
} PredictionStringStyle;

// ----------------------------------------------------------------------

@implementation NSDate (NextBus)

- (NSString *)epochString {
	return nil;
}

// ----------------------------------------------------------------------

- (NSString *)predictionString_short {
	return [self predictionString:PredictionString_short];
}

- (NSString *)predictionString_long {
	return [self predictionString:PredictionString_long];
}

// write NextBus epochTime in semi-user-friendly format:
// "3:23:45 pm EST 22 June 2015"

// ----------------------------------------------------------------------

- (NSString *)predictionString:(PredictionStringStyle)style {
	static NSDateFormatter *_formatter_short;
	static NSDateFormatter *_formatter_long;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_formatter_short = [[NSDateFormatter alloc] init];
		[_formatter_short setDateFormat:@"h:mm a, MMMM d"];

		_formatter_long = [[NSDateFormatter alloc] init];
		[_formatter_long setDateFormat:@"h:mm:ss a zzz d MMMM yyyy"];
	});
	NSDateFormatter *formatter = (style == PredictionString_long ? _formatter_long : _formatter_short);
	
	NSString *result = [formatter stringFromDate:self];
	return result;
}

@end

// ----------------------------------------------------------------------
