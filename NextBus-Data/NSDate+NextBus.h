//
//  NSDate+NextBus.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/22/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NextBus)

- (NSString *)epochString;

- (NSString *)predictionString_short;

- (NSString *)predictionString_long;

@end
