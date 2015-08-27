//
//  NSDate+NextBus.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Foundation/Foundation.h>

@interface NSDate (NextBus)

- (NSString *)epochString;

- (NSString *)predictionString_short;

- (NSString *)predictionString_long;

@end
