//
//  Categories.m
//	NextBus-Mantle
//
//  Created by Steve Caine on 08/20/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
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
