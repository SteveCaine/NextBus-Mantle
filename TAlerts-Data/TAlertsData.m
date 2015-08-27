//
//  TAlertsData.m
//  NextBus-Mantle
//
//  Created by Steve Caine on 08/24/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "TAlertsData.h"

#import "DDXML.h"
#import "DDXMLElementAdditions.h"

#import "TAlerts.h"

// ----------------------------------------------------------------------

@implementation TAlertsData

+ (id)alertsForFile:(NSString *)path error:(NSError **)errorP {
	
	if (path.length) {
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			NSData *xml = [NSData dataWithContentsOfFile:path];
			
			if (xml.length)
				return [self alertsForXML:xml error:errorP];
		}
	}
	return nil;
}

// ----------------------------------------------------------------------

+ (id)alertsForXML:(NSData *)xml error:(NSError **)errorP {
	id result = nil;
	
	if (xml.length) {
		NSError *error = nil;
		DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:xml options:0 error:&error];
		if (error) {
			NSLog(@"XML parsing error: %@", [error debugDescription]);
			if (errorP)
				*errorP = error;
		}
		else {
			id obj = nil;
			obj = [MTLXMLAdapter modelOfClass:[TAlertsList class] fromXMLNode:doc error:&error];
			if (error) {
				NSLog(@"Mantle object-creation error : %@", [error debugDescription]);
				if (errorP)
					*errorP = error;
			}
			else
				result = obj;
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
