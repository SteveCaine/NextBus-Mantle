//
//	MasterViewController.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 06/23/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "FilesUtil.h"

#import "DDXML.h"
#import "DDXMLElementAdditions.h"

#import "NBError.h"
#import "NBAgencies.h"
#import "NBRoutes.h"
#import "NBRouteConfig.h"
#import "NBPredictions.h"
#import "NBVehicleLocations.h"

#import "TAlerts.h"

#import "NextBusUtil.h"

#import "Debug_iOS.h"
#import "Debug_KissXML.h"

// ----------------------------------------------------------------------

static NSString * const SequeID_DetailViewController = @"showDetail";

static NSString * const str_type_xml = @"xml";

// ----------------------------------------------------------------------

@interface MasterViewController ()
//@property (strong, nonatomic) NSArray		*strs;
@property (strong, nonatomic) NSArray		*xmlNames;

@property (strong, nonatomic) NBRouteList	*routes;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation MasterViewController

// ----------------------------------------------------------------------
- (void)get_routes {
	
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

- (BOOL)write_plist:(id)obj name:(NSString *)name {
	BOOL result = NO;
	
	if ([obj respondsToSelector:@selector(plist)] && name.length) {
		id plist_obj = [obj plist];
		
		if ([plist_obj isKindOfClass:NSDictionary.class] || [plist_obj isKindOfClass:NSArray.class]) {
			NSError *error = nil;
			NSData *plist_xml = [NSPropertyListSerialization dataWithPropertyList:plist_obj format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
			
			if (plist_xml.length) {
				NSString *plist_str = [[NSString alloc] initWithData:plist_xml encoding:NSUTF8StringEncoding];
				
				NSString *str_plist = @"plist";
				name = [name stringByDeletingPathExtension];
				name = [name stringByAppendingPathExtension:str_plist];
				
				NSString *path = [FilesUtil writeString:plist_str toDocFile:name];
				result = (path.length > 0);
			}
		}
	}
	
	return result;
}

// ----------------------------------------------------------------------

- (BOOL)parseXML:(NSString *)xmlPath {
	BOOL result = NO;
	
	NSData *data = [NSData dataWithContentsOfFile:xmlPath];
	if ([data length]) {
		NSError *error = nil;
		DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
		if (error)
			NSLog(@"Error (1): %@", [error debugDescription]);
		else {
#if 0
			d_DDXMLNode(doc);
#else
			NSString *name = [[FilesUtil namesFromPaths:@[xmlPath] stripExtensions:YES] firstObject];
			NBRequestType requestType = [NextBusUtil findRequestTypeInName:name];
			
			id obj = nil;
			
			if ([name rangeOfString:@"talerts"].location != NSNotFound) {
				obj = [MTLXMLAdapter modelOfClass:[TAlertsList class] fromXMLNode:doc error:&error];
//				MyLog(@"\n obj = %@\n", obj);
				result = (obj != nil);
			}
			else
			// our test "error.xml" file?
			if ([name rangeOfString:@"error"].location != NSNotFound) {
				obj = [MTLXMLAdapter modelOfClass:[NBError class] fromXMLNode:doc error:&error];
				MyLog(@"\n obj = %@\n", obj);
				result = (obj != nil);
			}
			else {
				// standard practice: check every NextBus response for an error;
				// if none found, move on to process response
				obj = [MTLXMLAdapter modelOfClass:[NBError class] fromXMLNode:doc error:&error];
				if (obj) {
					NBError *error = (NBError *)obj;
					NSLog(@"Error (2) - NextBus error in response: %@", error.message);
				}
				else {
					switch (requestType) {
						case NBRequest_agencyList:
							obj = [MTLXMLAdapter modelOfClass:[NBAgencyList class] fromXMLNode:doc error:&error];
							break;
						case NBRequest_routeList:
							obj = [MTLXMLAdapter modelOfClass:[NBRouteList class] fromXMLNode:doc error:&error];
							break;
						case NBRequest_routeConfig:
							obj = [MTLXMLAdapter modelOfClass:[NBRouteConfig class] fromXMLNode:doc error:&error];
							break;
						case NBRequest_predictions:
							obj = [MTLXMLAdapter modelOfClass:[NBPredictionsResponse class] fromXMLNode:doc error:&error];
							[self write_plist:obj name:@"predictions"];
							break;
						case NBRequest_vehicleLocations:
							obj = [MTLXMLAdapter modelOfClass:[NBVehicleLocations class] fromXMLNode:doc error:&error];
							break;
						default:
							break;
					}
					if (error)
						NSLog(@"Error (3): %@", [error debugDescription]);
					else {
						MyLog(@"\n obj = %@\n", obj);
						result = (obj != nil);
					}
				}
			}
#endif
		}
	}
	return result;
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//	self.strs = @[ @"one", @"two", @"three" ];
	NSArray *xmlPaths = [FilesUtil pathsForBundleFilesType:str_type_xml sortedBy:SortFiles_alphabeticalAscending];
	self.xmlNames = [FilesUtil namesFromPaths:xmlPaths stripExtensions:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDataSource
// ----------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return [self.strs count];
	return [self.xmlNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

//	if (indexPath.row < [self.strs count])
//		cell.textLabel.text = self.strs[indexPath.row];
	if (indexPath.row < [self.xmlNames count])
		cell.textLabel.text = self.xmlNames[indexPath.row];
	
	cell.detailTextLabel.text = nil;
	
	return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];

	if (indexPath.row < [self.xmlNames count]) {
		NSString *xmlName = self.xmlNames[indexPath.row];
		NSString *xmlPath = [[NSBundle mainBundle] pathForResource:xmlName ofType:str_type_xml];
		if ([xmlPath length]) {
			BOOL success = [self parseXML:xmlPath];
			cell.detailTextLabel.text = (success ? @"Success!" : @"Failed!");
		}
	}
}

// ----------------------------------------------------------------------
#pragma mark - Segues
// ----------------------------------------------------------------------

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:SequeID_DetailViewController]) {
//		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDate *object = [NSDate date];
		[[segue destinationViewController] setDetailItem:object];
	}
}

@end

// ----------------------------------------------------------------------
