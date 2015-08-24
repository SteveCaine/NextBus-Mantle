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

#import "NBRoutesRequest.h"
#import "NBRouteConfigRequest.h"
#import "NBPredictionsRequest.h"
#import "NBVehiclesRequest.h"

#import "TAlerts.h"

//#import "NextBusUtil.h"
#import "NBRequestTypes.h"

#import "EXTScope.h"

#import "Debug_iOS.h"
#import "Debug_KissXML.h"

// ----------------------------------------------------------------------

static NSString * const SequeID_DetailViewController = @"showDetail";

static NSString * const str_type_xml = @"xml";

// ----------------------------------------------------------------------

@interface MasterViewController ()
//@property (strong, nonatomic) NSArray		*strs;
@property (strong, nonatomic) NSArray		*xmlNames;
@property (strong, nonatomic) NSArray		*requestNames;

@property (strong, nonatomic) NBRoutesRequest		*routesRequest;
@property (strong, nonatomic) NBRouteConfigRequest	*routeConfigRequest;
@property (strong, nonatomic) NBPredictionsRequest	*predictionsRequest;
@property (strong, nonatomic) NBVehiclesRequest		*vehiclesRequest;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation MasterViewController

// ----------------------------------------------------------------------

- (void)request_routes {
	if (self.routesRequest == nil)
		self.routesRequest = [[NBRoutesRequest alloc] init];
//	@weakify(self)
	[self.routesRequest refresh_success:^(NBRequest *request) {
		NBRouteList *routeList = (NBRouteList *)[request response];
//		@strongify(self)
		MyLog(@" => routeList = %@", routeList);
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}];
}

// ----------------------------------------------------------------------

- (void)request_routeConfig {
	if (self.routeConfigRequest == nil)
		self.routeConfigRequest = [[NBRouteConfigRequest alloc] initWithRoute:@"71" option:NBRouteConfigOption_Verbose];
//	@weakify(self)
	[self.routeConfigRequest refresh_success:^(NBRequest *request) {
		NBRouteConfig *routeConfig = (NBRouteConfig *)[request response];
//		@strongify(self)
		MyLog(@" => routeList = %@", routeConfig);
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}];
}

// ----------------------------------------------------------------------

- (void)request_predictions {
	if (self.predictionsRequest == nil)
		self.predictionsRequest = [[NBPredictionsRequest alloc] initWithStopID:@"02021"];
//		self.predictionsRequest = [[NBPredictionsRequest alloc] initWithStopID:@"02021" routeTag:@"71"];
//		self.predictionsRequest = [[NBPredictionsRequest alloc] initWithStopTag:@"2021" routeTag:@"71"];
	
//	@weakify(self)
	[self.predictionsRequest refresh_success:^(NBRequest *request) {
		NBPredictions *predictions = (NBPredictions *)[request response];
//		@strongify(self)
		MyLog(@" => routeList = %@", predictions);
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}];
}

// ----------------------------------------------------------------------

- (void)request_vehicleLocations {
	if (self.vehiclesRequest == nil)
		self.vehiclesRequest = [[NBVehiclesRequest alloc] initWithRoute:@"71"];
	//	@weakify(self)
	[self.vehiclesRequest refresh_success:^(NBRequest *request) {
		NBVehicleLocations *vehicles = (NBVehicleLocations *)[request response];
//		@strongify(self)
		MyLog(@" => vehicleLocations = %@", vehicles);
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}];
}

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
			NBRequestType requestType = [NBRequestTypes findRequestTypeInName:name];
			
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
//	self.strs = @[ @"one", @"two", @"three" ];
	
	NSArray *xmlPaths = [FilesUtil pathsForBundleFilesType:str_type_xml sortedBy:SortFiles_alphabeticalAscending];
	self.xmlNames = [FilesUtil namesFromPaths:xmlPaths stripExtensions:YES];
	
	self.requestNames = @[ @"routeList", @"routeConfig", @"predictions", @"vehicleLocations" ];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDataSource
// ----------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 0 ? @"Requests" : @"Files");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return [self.strs count];
	return (section == 0 ? self.requestNames.count : self.xmlNames.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
//	if (indexPath.row < [self.strs count])
//		cell.textLabel.text = self.strs[indexPath.row];

	switch (indexPath.section) {
		case 0:
			if (indexPath.row < self.requestNames.count)
				cell.textLabel.text = self.requestNames[indexPath.row];
			break;
		case 1:
			if (indexPath.row < self.xmlNames.count)
				cell.textLabel.text = self.xmlNames[indexPath.row];
			break;
		default:
			break;
	}
	
	cell.detailTextLabel.text = nil;
	
	return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];

	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					[self request_routes];
					break;
				case 1:
					[self request_routeConfig];
					break;
				case 2:
					[self request_predictions];
					break;
				case 3:
					[self request_vehicleLocations];
					break;
				default:
					break;
			}
			break;
		case 1:
			if (indexPath.row < [self.xmlNames count]) {
				NSString *xmlName = self.xmlNames[indexPath.row];
				NSString *xmlPath = [[NSBundle mainBundle] pathForResource:xmlName ofType:str_type_xml];
				if ([xmlPath length]) {
					BOOL success = [self parseXML:xmlPath];
					cell.detailTextLabel.text = (success ? @"Success!" : @"Failed!");
				}
			}
			break;
		default:
			break;
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
