//
//  NSValue+MapKit.m
//  Marinalife-oceanalert
//
//  Created by Steve Caine on 05/13/15.
//  Copyright (c) 2015 EarthNC, Inc. All rights reserved.
//

#import "NSValue+MapKit.h"

@implementation NSValue (MapKit)

// if MapKit is not @import'ed
#if 1
// NSValue <=> CLLocationCoordinate2D
+ (NSValue *)valueWithMKCoordinate:(CLLocationCoordinate2D)coordinate {
	return [NSValue value:&coordinate withObjCType:@encode(CLLocationCoordinate2D)];
}
- (CLLocationCoordinate2D) MKCoordinateValue {
	CLLocationCoordinate2D result = {0,0};
	
	if (strcmp([self objCType], @encode(CLLocationCoordinate2D)) == 0) {
		[self getValue:&result];
	}
	return result;
}

// NSValue <=> MKCoordinateSpan
+ (NSValue *)valueWithMKCoordinateSpan:(MKCoordinateSpan)span {
	return [NSValue value:&span withObjCType:@encode(MKCoordinateSpan)];
	return nil;
}
- (MKCoordinateSpan) MKCoordinateSpanValue {
	MKCoordinateSpan result = {0,0};
	
	if (strcmp([self objCType], @encode(MKCoordinateSpan)) == 0) {
		[self getValue:&result];
	}
	return result;
}
#endif

// NSValue => MKCoordinateRegion (mine)
- (MKCoordinateRegion) MKCoordinateRegionValue {
	MKCoordinateRegion region = {0,0,0,0};
	if (strcmp([self objCType], @encode(MKCoordinateRegion)) == 0)
		[self getValue:&region];
	return region;
}

// NSValue <= MKCoordinateRegion (mine)
+ (NSValue *)valueWithMKCoordinateRegion:(MKCoordinateRegion)region {
	return [NSValue value:&region withObjCType:@encode(MKCoordinateRegion)];
}

@end
