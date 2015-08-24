//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"
#import "MajorEventsViewController.h"
#import "FilteredMajorEventsViewController.h"
#import "ConnectionToServer.h"
#import "Category.h"

@implementation MenuViewController

@synthesize categories = _categories;
@synthesize json = _json;
@synthesize listOfItems = _listOfItems;
@synthesize filter = _filter;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _listOfItems = [[NSMutableArray alloc] init];
    
    [self loadCategories];
}

- (void) loadCategories
{   
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        _categories = [[NSMutableArray alloc] init];
        
        Category* reminder = [[Category alloc] initWithCategoryName:@"Reminders"];
        NSArray* reminderArray = [[NSArray alloc] initWithObjects:reminder, nil];
        [_listOfItems addObject:reminderArray];
        
        Category* all = [[Category alloc] initWithCategoryName:@"Show All"];
        [_categories addObject:all];
        
        _json = [ConnectionToServer makeGETRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@majoreventcountdown/events/categories", IP_ADDRESS_AMAZON_AWS]]];
        
        for (NSDictionary* item in _json) {
            NSString* categoryName = (NSString *)[[item objectForKey:@"category"] objectForKey:@"name"];
            
            Category * category = [[Category alloc] initWithCategoryName:categoryName];
            [_categories addObject:category];
        }
        [_listOfItems addObject:_categories];
        
        //Personal Events section
        Category* personal = [[Category alloc] initWithCategoryName:@"Manage Personal Events"];
        NSArray* personalArray = [[NSArray alloc] initWithObjects:personal, nil];
        [_listOfItems addObject:personalArray];
        
        //About section
        Category* about = [[Category alloc] initWithCategoryName:@"About"];
        NSArray* aboutArray = [[NSArray alloc] initWithObjects:about, nil];
        [_listOfItems addObject:aboutArray];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    UITableViewCell* c = sender;

    if ([[segue identifier] isEqualToString:@"unfiltered"])
    {
        MajorEventsViewController* meVC = segue.destinationViewController;
        
        [meVC view];
        [meVC setEventCategory:c.textLabel.text withFilteredEvents:_filter];
    }
    else if ([[segue identifier] isEqualToString:@"filtered"])
    {
        FilteredMajorEventsViewController* fVC = segue.destinationViewController;
        
        [fVC view];
        [fVC setEventCategory:c.textLabel.text];
    }
    
    // configure the segue.
    // in this case we dont swap out the front view controller, which is a UINavigationController.
    // but we could..
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );

        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {

            UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
            [nc setViewControllers: @[ dvc ] animated: YES ];
            
            [rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listOfItems count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Reminder";
    }
    else if (section == 1) {
        return @"Categories";
    }
    else if (section == 2) {
        return @"Personal Events";
    }
    else {
        return @"About";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* array = [_listOfItems objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *itemsInSection = [_listOfItems objectAtIndex:indexPath.section];
    Category* category = [itemsInSection objectAtIndex:indexPath.row];

    cell.textLabel.text = [category name];
 
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    //Testing
    
    if ([selectedCell.textLabel.text isEqualToString:@"Show All"]) {
        _filter = NO;
        [self performSegueWithIdentifier:@"unfiltered" sender:selectedCell];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"Reminders"]) {
        [self performSegueWithIdentifier:@"reminder" sender:selectedCell];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"About"]) {
        [self performSegueWithIdentifier:@"about" sender:selectedCell];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"Manage Personal Events"]) {
        [self performSegueWithIdentifier:@"personal" sender:selectedCell];
    }
    else {
        _filter = YES;
        [self performSegueWithIdentifier:@"unfiltered" sender:selectedCell];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
