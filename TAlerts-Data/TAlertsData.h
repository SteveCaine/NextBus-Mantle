//
//  TAlertsData.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

@interface TAlertsData : NSObject

+ (id)alertsForXML:(NSData *)xml error:(NSError **)error;

+ (id)alertsForFile:(NSString *)path error:(NSError **)error;

@end

// ----------------------------------------------------------------------
