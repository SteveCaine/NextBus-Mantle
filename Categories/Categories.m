//
//  Categories.m
//  NextBus-Mantle-Requests
//
//  Created by Steve Caine on 08/20/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "Categories.h"

// ----------------------------------------------------------------------
// thanks to Pyry Jahkola's for his GitHub Gist
// "Safe" casting in Objective-C using `instancetype`
// https://gist.github.com/pyrtsa/5151517

@implementation NSObject (Cast)

+ (instancetype)cast:(id)object {
	return [object isKindOfClass:self] ? object : nil;
}

@end

// ----------------------------------------------------------------------
