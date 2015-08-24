//
//	NBRequest_private.h
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
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
