//
//	AppDelegate.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 06/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

#import "AppDelegate.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const type_plist			= @"plist";
static NSString * const plist_appData		= @"appData";
static NSString * const xml_file_extension	= @"xml";
static NSString * const xml_dir_name		= @"XMLs";

// ----------------------------------------------------------------------

@interface AppDelegate ()
+ (NSString *)xmlsDirectory;
@end

// ----------------------------------------------------------------------

@implementation AppDelegate

+ (NSDictionary *)appData {
	static NSDictionary *result;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *path = [[NSBundle mainBundle] pathForResource:plist_appData ofType:type_plist];
		if (path.length)
			result = [[NSDictionary alloc] initWithContentsOfFile:path];
	});
	
	return result;
}

// ----------------------------------------------------------------------
// will replace existing files

+ (BOOL)cacheResponse:(NSData *)data asFile:(NSString *)name {
	BOOL result = NO;
	
	if (name.length) {
		NSString *path = [[self xmlsDirectory] stringByAppendingPathComponent:name];
		BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
		NSError *error = nil;
		if (exists) {
			BOOL cleared = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
			if (!cleared)
				NSLog(@" error clearing older response file '%@' - %@", name, [error localizedDescription]);
		}
		if (error == nil) {
			result = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
			if (!result)
				NSLog(@" error saving response as file '%@'", name);
		}
	}
	return result;
}

// ----------------------------------------------------------------------

+ (NSString *)responseFileForKey:(NSString *)key {
	NSString *result = nil;
	if (key.length) {
		NSString *name = [key stringByAppendingPathExtension:xml_file_extension];
		NSString *path = [[self xmlsDirectory] stringByAppendingPathComponent:name];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path])
			result = path;
	}
	return result;
}

// ----------------------------------------------------------------------

+ (double)ageOfFile:(NSString *)path error:(NSError **)errorP {
	double result = 0.0;
	
	NSError *error = nil;
	NSDictionary *attribs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
	if (error) {
		if (errorP)
			*errorP = error;
	}
	else if (attribs == nil) {
		// TODO: custom app error here
		if (errorP)
			;
	}
	else {
		NSDate *date = [attribs objectForKey:NSFileModificationDate];
		result = -[date timeIntervalSinceNow];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (NSString *)xmlsDirectory {
	NSString *result = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    result = [[paths firstObject] stringByAppendingPathComponent:xml_dir_name];
	return result;
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
//	MyLog(@" docs dir = '%@'", str_DocumentsPath());
//	MyLog(@" xmls dir = '%@'", [self.class xmlsDirectory]);
	
	// if XMLs folder doesn't already exist, create it
	NSString *xmlsDir = [AppDelegate xmlsDirectory];
	if ([xmlsDir length]) {
		if (![[NSFileManager defaultManager] fileExistsAtPath:xmlsDir]) {
			NSError *error = nil;
			if ([[NSFileManager defaultManager] createDirectoryAtPath:xmlsDir
										  withIntermediateDirectories:NO
														   attributes:nil
																error:&error]) {
			}
			else {
				NSLog(@"Error creating XMLs directory: %@", [error localizedDescription]);
			}
		}
	}
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

// ----------------------------------------------------------------------
