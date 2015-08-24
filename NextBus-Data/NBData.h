//
//	NBData.h
//	NextBus-Mantle
//
//	Created by Steve Caine on 08/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NBRequestTypes.h"

@interface NBData : NSObject

+ (id)dataForXML:(NSData *)xml type:(NBRequestType)type error:(NSError **)error;

+ (id)dataForFile:(NSString *)path type:(NBRequestType)type error:(NSError **)error;

@end
