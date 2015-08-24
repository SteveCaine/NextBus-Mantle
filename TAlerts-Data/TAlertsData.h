//
//  TAlertsData.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

@interface TAlertsData : NSObject

+ (id)alertsForXML:(NSData *)xml error:(NSError **)error;

+ (id)alertsForFile:(NSString *)path error:(NSError **)error;

@end

// ----------------------------------------------------------------------
