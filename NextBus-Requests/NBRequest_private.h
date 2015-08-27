//
//	NBRequest_private.h
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "NBRequest.h"
#import "NBRequestTypes.h"

// ----------------------------------------------------------------------

@interface NBRequest ()

@property (strong, nonatomic) id data;

+ (id)cachedObjectForKey:(NSString *)key staleAge:(double)staleAge;

+ (double)staleAgeForType:(NBRequestType)type;

- (NBRequestType)type;
- (NSString *)key;
- (double)staleAge;

- (NSDictionary *)params;

@end

// ----------------------------------------------------------------------
