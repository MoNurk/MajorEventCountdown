//
//  ViewController.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 08/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "MajorEventsViewController.h"
#import "ConnectionToServer.h"
#import "MajorEventsDetailViewController.h"
#import "MajorEventCell.h"
#import "AppDelegate.h"
#import "Category.h"
#import "AddMajorEventViewController.h"
#import "SWRevealViewController.h"

@interface MajorEventsViewController ()

@end

@implementation MajorEventsViewController

@synthesize category = _category;
@synthesize revealButtonItem = _revealButtonItem;
@synthesize tableView = _tableView;
@synthesize majorEvents = _majorEvents;
@synthesize json = _json;
@synthesize sections = _sections, listOfItems = _listOfItems;
@synthesize searchController = _searchController;
@synthesize filteredEventsArray = _filteredEventsArray;
@synthesize evnetsSearchBar= _evnetsSearchBar;
@synthesize selectedMajorEvent = _selectedMajorEvent;
@synthesize adView = _adView;
@synthesize initialTableHeight = _initialTableHeight;
@synthesize isFiltered = _isFiltered;
@synthesize personalEvents = _personalEvents;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    _adView.hidden = YES;
    self.tableView.contentOffset = CGPointMake(0, 44);
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self performSelector:@selector(populateTableIfFreshLaunch) withObject:nil afterDelay:1.0];
    
    _personalEvents = [[NSMutableArray alloc] initWithContentsOfFile:[self saveFilePath]];
}

- (void) dealloc
{
    self.searchDisplayController.delegate = nil;
    self.searchDisplayController.searchResultsDelegate = nil;
    self.searchDisplayController.searchResultsDataSource = nil;
}

- (NSString *) saveFilePath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"personalEvents.plist"];
}

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setEventCategory:(NSString *)category withFilteredEvents:(BOOL)isFiltered
{
    _category = category;
    _isFiltered = isFiltered;
    [self populateCategoriesForEvents];
}

- (void) populateTableIfFreshLaunch
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([appDelegate isFirstLaunch] == YES) {
        [self populateCategoriesForEvents];
        appDelegate.isFirstLaunch = NO;
    }
}

- (void) populateCategoriesForEvents
{
    _personalEvents = [[NSMutableArray alloc] initWithContentsOfFile:[self saveFilePath]];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_isFiltered) {
            _sections = [[NSMutableArray alloc] init];
            Category * category = [[Category alloc] initWithCategoryName:_category];
            [_sections addObject:category];
        }
        else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            _sections = [[NSMutableArray alloc] init];
            
            NSMutableArray* _jsonCat = [ConnectionToServer makeGETRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@majoreventcountdown/events/categories", IP_ADDRESS_AMAZON_AWS]]];
            
            for (NSDictionary* item in _jsonCat) {
                NSString* categoryName = (NSString *)[[item objectForKey:@"category"] objectForKey:@"name"];
                
                Category * category = [[Category alloc] initWithCategoryName:categoryName];
                [_sections addObject:category];
            }
        }
        dispatch_async( dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if ([_personalEvents count] > 0) {
                Category* cat = [[Category alloc] initWithCategoryName:@"Personal"];
                [_sections addObject:cat];
            }
            [self getEventsFromServer];
        });
    });
}

- (void) getEventsFromServer
{
    _personalEvents = [[NSMutableArray alloc] initWithContentsOfFile:[self saveFilePath]];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        _majorEvents = [[NSMutableArray alloc] init];
        
        if (_isFiltered) {
            _json = [ConnectionToServer makeGETRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@majoreventcountdown/events/%@", IP_ADDRESS_AMAZON_AWS, _category]]];
        }
        else {
            _json = [ConnectionToServer makeGETRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@majoreventcountdown/events/current", IP_ADDRESS_AMAZON_AWS]]];
        }
        
        for (NSDictionary* item in _json) {
            long eventId = [[[item objectForKey:@"event"] objectForKey:@"eventId"] longValue];
            NSString* eventName = (NSString *)[[item objectForKey:@"event"] objectForKey:@"eventName"];
            NSString* eventDescription = (NSString *)[[item objectForKey:@"event"] objectForKey:@"eventDescription"];
            NSString* eventDate = (NSString *)[[item objectForKey:@"event"] objectForKey:@"eventDate"];
            NSString* category = (NSString *)[[item objectForKey:@"event"] objectForKey:@"category"];
            NSString* notes = (NSString *)[[item objectForKey:@"event"] objectForKey:@"notes"];
            
            MajorEvent * majorEvent = [[MajorEvent alloc] initWithEventId:eventId eventName:eventName eventDescription:eventDescription eventCategory:category eventUTCDate:eventDate eventNotes:notes];
            [_majorEvents addObject:majorEvent];
        }
        dispatch_async( dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            _listOfItems = [[NSMutableArray alloc] init];
            for (Category* category in _sections) {
                NSMutableArray* items = [[NSMutableArray alloc] init];
                for (int i = 0; i < [_majorEvents count]; i++) {
                    MajorEvent* event = [_majorEvents objectAtIndex:i];
                    
                    if ([[event category] isEqualToString:[category name]]) {
                        [items addObject:event];
                    }
                }
                if (items.count > 0) {
                    [_listOfItems addObject:items];
                }
            }
            
            if ([_personalEvents count] > 0) {
                NSMutableArray* personalItems = [[NSMutableArray alloc] init];
                for (NSArray* values in _personalEvents) {
                    MajorEvent* majorEvent = [[MajorEvent alloc] initWithEventId:0 eventName:[self checkIfNull:[values objectAtIndex:0]] eventDescription:[self checkIfNull:[values objectAtIndex:1]] eventCategory:[self checkIfNull:[values objectAtIndex:4]] eventLocalDate:[self checkIfNull:[values objectAtIndex:3]] eventNotes:[self checkIfNull:[values objectAtIndex:2]]];
                    
                    [personalItems addObject:majorEvent];
                }
                [_listOfItems addObject:personalItems];
            }
            _filteredEventsArray = [NSMutableArray arrayWithCapacity:[_majorEvents count]];
            [_tableView reloadData];
        });
    });
}

- (NSString*)checkIfNull:(NSString*) value
{
    if (value == Nil || value == nil || value == NULL) {
        value = @"";
        
        return value;
    }
    else {
        return value;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [_listOfItems count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredEventsArray count];
    } else {
        NSMutableArray* array = [_listOfItems objectAtIndex:section];
        return [array count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"Search Results";
    } else {
        Category* cat = [_sections objectAtIndex:section];
        return [cat name];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MajorEventCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    MajorEvent* me;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        me = [_filteredEventsArray objectAtIndex:indexPath.row];
    } else {
        NSArray *itemsInSection = [_listOfItems objectAtIndex:indexPath.section];
        me = [itemsInSection objectAtIndex:indexPath.row];
    }
    
    cell.eventName.text = [me eventName];
    cell.eventDescription.text = [me eventDescription];
    cell.eventDate.text = [me eventDate];
    
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_3475.JPG"]];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    
    //[cell setBackgroundView:backgroundView];
    //cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fiesta_st.jpg"]];
    
    NSDate* today = [[NSDate alloc] init];
    
    if (([[me convertStringToDate] compare:today] == NSOrderedAscending)) {
        [[cell eventName] setTextColor:[UIColor redColor]];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selectedMajorEvent = [_filteredEventsArray objectAtIndex:indexPath.row];
    } else {
        NSArray *itemsInSection = [_listOfItems objectAtIndex:indexPath.section];
        MajorEvent *theMajorEvent = [itemsInSection objectAtIndex:indexPath.row];
        
        _selectedMajorEvent = theMajorEvent;
    }

    /*MajorEventsDetailViewController *medvc = [[MajorEventsDetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    [medvc setMajorEvent:_selectedMajorEvent];
    
    [self.navigationController pushViewController:medvc animated:YES];*/
    
    [self performSegueWithIdentifier:@"detailView" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [_filteredEventsArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.eventName contains[c] %@ OR SELF.eventDescription contains[c] %@", searchText, searchText];
    _filteredEventsArray = [NSMutableArray arrayWithArray:[_majorEvents filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailView"]) {
        MajorEventsDetailViewController* detailView = [segue destinationViewController];
        [detailView setMajorEvent:_selectedMajorEvent];
    }
    else if ([[segue identifier] isEqualToString:@"addOwnEvent"]) {
        AddMajorEventViewController* addEvent = [segue destinationViewController];
        addEvent.delegate = self;
    }
}

- (void) myModalViewControllerDidFinishAddingEvent:(AddMajorEventViewController *)controller
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self setEventCategory:@"Show All" withFilteredEvents:NO];
}

- (void) myModalViewControllerDidCancel:(AddMajorEventViewController *)controller
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)presentAddMajorEventView:(id)sender
{
    [self performSegueWithIdentifier:@"addOwnEvent" sender:self];
}

#pragma mark - Ad Banner Delegate Methods

- (void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    _adView.hidden = NO;
    NSLog(@"showing");
}
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _adView.hidden = YES;
    NSLog(@"hidden");
}

@end
