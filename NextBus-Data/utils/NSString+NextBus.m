//
//  NSString+NextBus.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NSString+NextBus.h"

@implementation NSString (NextBusInc)

// NextBus's color and oppositeColor values are 6-digit hex numbers
// representing the red,green,blue components of the color
// ex., color="003399" oppositeColor="ffffff"

- (UIColor *)colorValue {
	UIColor *result = nil;
	
	if ([self length] >= 6) {
		float redFloat = 0.0;
		NSString *redString = [self substringWithRange:NSMakeRange(0,2)];
		unsigned redHex = 0;
		if ([[NSScanner scannerWithString:redString] scanHexInt:&redHex]) {
			redFloat = redHex/255.0;
		}
		
		float greenFloat = 0.0;
		NSString *greenString = [self substringWithRange:NSMakeRange(2,2)];
		unsigned greenHex = 0;
		if ([[NSScanner scannerWithString:greenString] scanHexInt:&greenHex]) {
			greenFloat = greenHex/255.0;
		}
		
		float blueFloat = 0.0;
		NSString *blueString = [self substringWithRange:NSMakeRange(4,2)];
		unsigned blueHex = 0;
		if ([[NSScanner scannerWithString:blueString] scanHexInt:&blueHex]) {
			blueFloat = blueHex/255.0;
		}
		result = [UIColor colorWithRed:redFloat green:greenFloat blue:blueFloat alpha:1.0];
	}
	
	return result;
}

- (NSDate *)epochTime {
	NSDate *result = nil;
	// NextBus's epochTime integer is milliseconds since Jan 1 1970
	if ([self length]) {
		NSTimeInterval epoch = [self doubleValue] / 1000.0;
		result = [NSDate dateWithTimeIntervalSince1970:epoch];
	}
	return result;
}

@end
