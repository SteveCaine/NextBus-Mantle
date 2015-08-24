//
//	AppDelegate.h
//	NextBus-Mantle
//
//	Created by Steve Caine on 06/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSDictionary *)appData;

+ (BOOL)cacheResponse:(NSData *)data asFile:(NSString *)name;

+ (NSString *)responseFileForKey:(NSString *)key;

+ (double)ageOfFile:(NSString *)path error:(NSError **)error;

@end
