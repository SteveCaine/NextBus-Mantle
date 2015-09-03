//
//	MasterViewController.m
//	NextBus-Mantle
//
//	Created by Steve Caine on 06/23/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
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
#import "TAlertsRequest.h"

//#import "NextBusUtil.h"
#import "NBRequestTypes.h"

#import "Categories.h"
#import "EXTScope.h"

#import "Debug_iOS.h"
#import "Debug_KissXML.h"

// ----------------------------------------------------------------------

enum {
	Section_Request,
	Section_Parse,
};

static NSString * const CellID						 = @"Cell";
static NSString * const SequeID_DetailViewController = @"showDetail";

static NSString * const str_type_xml = @"xml";

static const NSTimeInterval resetDelay = 1.5;

// ----------------------------------------------------------------------

@interface MasterViewController ()
// files in app bundle
@property (strong, nonatomic) NSArray				*xmlNames;

// static table contents (defined in -awakeFromNib)
@property (strong, nonatomic) NSArray				*requestNames;
@property (strong, nonatomic) NSArray				*requestMethods;
@property (strong, nonatomic) NSArray				*sectionTitles;
@property (strong, nonatomic) NSArray				*sectionCellSubtitles;

// MBTA T-Alerts request
@property (strong, nonatomic) TAlertsRequest		*alertsRequest;

// NextBus, Inc. requests
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

- (void)request_alerts {
	if (self.alertsRequest == nil)
		self.alertsRequest = [[TAlertsRequest alloc] init];
	@weakify(self)
	
	[self.alertsRequest refresh_success:^(TAlertsRequest *request) {
		TAlertsList *alertsList = [TAlertsList cast:[request response]];
		MyLog(@" => alertsList = %@", alertsList);
		@strongify(self)
		[self reportSuccess:YES forRequest:__FUNCTION__];
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
		@strongify(self)
		[self reportSuccess:NO forRequest:__FUNCTION__];
	}];
}

// ----------------------------------------------------------------------

- (void)request_routes {
	if (self.routesRequest == nil)
		self.routesRequest = [[NBRoutesRequest alloc] init];
	@weakify(self)
	
	[self.routesRequest refresh_success:^(NBRequest *request) {
		NSAssert(request == self.routesRequest, @"request returns itself"); // just double-check
//		NBRouteList *routeList = [NBRouteList cast:[request response]];
		MyLog(@" => routeList = %@", [self.routesRequest routeList]);
		@strongify(self)
		[self reportSuccess:YES forRequest:__FUNCTION__];
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
		@strongify(self)
		[self reportSuccess:NO forRequest:__FUNCTION__];
	}];
}

// ----------------------------------------------------------------------

- (void)request_routeConfig {
	if (self.routeConfigRequest == nil)
		self.routeConfigRequest = [[NBRouteConfigRequest alloc] initWithRoute:@"71" option:NBRouteConfigOption_Verbose];
	@weakify(self)
	
	[self.routeConfigRequest refresh_success:^(NBRequest *request) {
		NSAssert(request == self.routeConfigRequest, @"request returns itself"); // just double-check
//		NBRouteConfig *routeConfig = [NBRouteConfig cast:[request response]];
		MyLog(@" => routeConfig = %@", [self.routeConfigRequest routeConfig]);
		@strongify(self)
		[self reportSuccess:YES forRequest:__FUNCTION__];
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
		@strongify(self)
		[self reportSuccess:NO forRequest:__FUNCTION__];
	}];
}

// ----------------------------------------------------------------------

- (void)request_predictions {
	// choose any of these three alternatives
	if (self.predictionsRequest == nil)
		self.predictionsRequest = [[NBPredictionsRequest alloc] initWithStopID:@"02021"];
//		self.predictionsRequest = [[NBPredictionsRequest alloc] initWithStopID:@"02021" routeTag:@"71"];
//		self.predictionsRequest = [[NBPredictionsRequest alloc] initWithStopTag:@"2021" routeTag:@"71"];
	@weakify(self)
	
	[self.predictionsRequest refresh_success:^(NBRequest *request) {
		NSAssert(request == self.routesRequest, @"request returns itself"); // just double-check
//		NBPredictions *predictions = [NBPredictions cast:[request response]];
		MyLog(@" => predictions = %@", [self.predictionsRequest predictionsResponse]);
		@strongify(self)
		[self reportSuccess:YES forRequest:__FUNCTION__];
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
		@strongify(self)
		[self reportSuccess:NO forRequest:__FUNCTION__];
	}];
}

// ----------------------------------------------------------------------

- (void)request_vehicleLocations {
	if (self.vehiclesRequest == nil)
		self.vehiclesRequest = [[NBVehiclesRequest alloc] initWithRoute:@"71"];
	@weakify(self)
	
	[self.vehiclesRequest refresh_success:^(NBRequest *request) {
		NSAssert(request == self.routesRequest, @"request returns itself"); // just double-check
//		NBVehicleLocations *vehicles = [NBVehicleLocations cast:[request response]];
		MyLog(@" => vehicleLocations = %@", [self.vehiclesRequest vehicles]);
		@strongify(self)
		[self reportSuccess:YES forRequest:__FUNCTION__];
	} failure:^(NSError *error) {
		NSLog(@"Error: %@", [error localizedDescription]);
		@strongify(self)
		[self reportSuccess:NO forRequest:__FUNCTION__];
	}];
}

// ----------------------------------------------------------------------
#pragma mark -
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
			NSString *name = [[FilesUtil namesFromPaths:@[xmlPath] stripExtensions:YES] firstObject];
			NBRequestType requestType = [NBRequestTypes findRequestTypeInName:name];
			
			id obj = nil;
			
			if ([name rangeOfString:@"talerts"].location != NSNotFound) {
				obj = [MTLXMLAdapter modelOfClass:[TAlertsList class] fromXMLNode:doc error:&error];
				MyLog(@"\n obj = %@\n", obj);
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
		}
	}
	return result;
}

// ----------------------------------------------------------------------

- (void)reportSuccess:(BOOL)success forRequest:(const char *)function {
//	MyLog(@"success? %s for method %s", (success ? "YES" : "NO"), function);
	
	// find table cell for request
	NSIndexPath *indexPath = nil;
	
	// parse method name from function signature
	// ex., "__38-[MasterViewController request_routes]_block_invoke" => "request_routes"
	NSString *name = [NSString stringWithCString:function encoding:NSUTF8StringEncoding];
	NSRange r1 = [name rangeOfString:@"]"];
	NSRange r2 = [name rangeOfString:@" " options:NSBackwardsSearch];
	
	if (r1.location != NSNotFound && r2.location != NSNotFound) {
		NSUInteger i2 = r2.location + r2.length;
		NSRange r3 = NSMakeRange(i2, r1.location - i2);
		NSString *methodName = [name substringWithRange:r3];
//		MyLog(@" methodName = '%@'", methodName);
		
		NSUInteger row = [self.requestMethods indexOfObject:methodName];
///		MyLog(@" row = %i", row);
		if (row != NSNotFound)
			indexPath = [NSIndexPath indexPathForRow:row inSection:Section_Request];
	}
	if (indexPath) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		// flash cell briefly to indicate response has arrived
		[cell setSelected:YES animated:YES];
		[cell setSelected: NO animated:YES];
		// stop spinner
		UIView *accessoryView = cell.accessoryView;
		if ([accessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
			UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)accessoryView;
			[spinner stopAnimating];
		}
		cell.detailTextLabel.text = (success ? @"Success!" : @"Failed!");
		
		// now post new 'reset' for this row: after X seconds, reset to its original state
		[self performSelector:@selector(resetForIndexPath:) withObject:indexPath afterDelay:resetDelay];
	}
}

- (void)resetForIndexPath:(NSIndexPath *)indexPath {
	// ASSUMED: we've already validated indexPath in caller
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = self.sectionCellSubtitles[indexPath.section];
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (void)awakeFromNib {
	[super awakeFromNib];
	
	NSArray *xmlPaths = [FilesUtil pathsForBundleFilesType:str_type_xml sortedBy:SortFiles_alphabeticalAscending];
	
	self.xmlNames = [FilesUtil namesFromPaths:xmlPaths stripExtensions:YES];
	
	self.requestNames = @[@"t-alerts",
						  @"routeList",
						  @"routeConfig",
						  @"predictions",
						  @"vehicleLocations" ];
	
	self.requestMethods = @[NSStringFromSelector(@selector(request_alerts)),
							NSStringFromSelector(@selector(request_routes)),
							NSStringFromSelector(@selector(request_routeConfig)),
							NSStringFromSelector(@selector(request_predictions)),
							NSStringFromSelector(@selector(request_vehicleLocations)),
							];
	
	self.sectionTitles = @[ @"Make Requests", @"Parse Files" ];
	self.sectionCellSubtitles = @[ @"idle", @"ready" ];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)dealloc {
	// in case someday this VC is not the only one in this app
	// cancel any '-performSelector:' calls before we go away
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDataSource
// ----------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section < self.sectionTitles.count)
		return self.sectionTitles[section];
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = 0;
	
	switch (section) {
		case Section_Request:
			result = self.requestNames.count;
			break;
		case Section_Parse:
			result = self.xmlNames.count;
			break;
		default:
			break;
	}
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
	
//	if (indexPath.row < [self.strs count])
//		cell.textLabel.text = self.strs[indexPath.row];

	switch (indexPath.section) {
		case Section_Request: {
			if (indexPath.row < self.requestNames.count)
				cell.textLabel.text = self.requestNames[indexPath.row];
			cell.detailTextLabel.text = self.sectionCellSubtitles[indexPath.section];
			
			UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			spinner.hidesWhenStopped = YES;
			[cell setAccessoryView:spinner];
		}	break;
		
		case Section_Parse:
			if (indexPath.row < self.xmlNames.count) {
				NSString *text = self.xmlNames[indexPath.row];
				NSRange r = [text rangeOfString:@"-"];
				if (r.location == 1)
					text = [text substringFromIndex:r.location + r.length];
				cell.textLabel.text = text;
			}
			cell.detailTextLabel.text = self.sectionCellSubtitles[indexPath.section];
			break;
		default:
			break;
	}
	
	return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];

	switch (indexPath.section) {
		case Section_Request:
			if (indexPath.row < self.requestMethods.count) {
				SEL selector = NSSelectorFromString(self.requestMethods[indexPath.row]);
				if (selector && [self respondsToSelector:selector]) {
					
					// need to start spinning before we call ...
					UIView *accessoryView = cell.accessoryView;
					if ([accessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
						UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)accessoryView;
						[spinner startAnimating];
					}
					cell.detailTextLabel.text = @"requesting ...";
// silence warning: 'may cause leak because selector is unknown'
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
					[self performSelector:selector];
#pragma clang diagnostic pop
				}
			}
			break;
		case Section_Parse:
			if (indexPath.row < [self.xmlNames count]) {
				NSString *xmlName = self.xmlNames[indexPath.row];
				NSString *xmlPath = [[NSBundle mainBundle] pathForResource:xmlName ofType:str_type_xml];
				if ([xmlPath length]) {
					BOOL success = [self parseXML:xmlPath];
					cell.detailTextLabel.text = (success ? @"Success!" : @"Failed!");
					// now post new 'ready' for this row: after X seconds, reset to its original state
					[self performSelector:@selector(resetForIndexPath:) withObject:indexPath afterDelay:resetDelay];
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
