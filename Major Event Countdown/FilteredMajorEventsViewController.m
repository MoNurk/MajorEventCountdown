//
//  FilteredMajorEventsViewController.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 10/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "FilteredMajorEventsViewController.h"
#import "MajorEventsDetailViewController.h"
#import "MajorEventCell.h"
#import "ConnectionToServer.h"

@interface FilteredMajorEventsViewController ()

@end

@implementation FilteredMajorEventsViewController

@synthesize revealButtonItem = _revealButtonItem;
@synthesize navTitle;
@synthesize category = _category;

@synthesize majorEvents = _majorEvents;
@synthesize json = _json;
@synthesize tableView = _tableView;

@synthesize selectedMajorEvent = _selectedMajorEvent;

- (void) setEventCategory:(NSString *)category
{
    _category = category;
    [self populateMajorEvents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) populateMajorEvents
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Major Events (%@)", _category]];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        _majorEvents = [[NSMutableArray alloc] init];
        
        _json = [ConnectionToServer makeGETRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@majoreventcountdown/events/%@", IP_ADDRESS_AMAZON_AWS, _category]]];
        
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
            [_tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_majorEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MajorEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    MajorEvent* me = [_majorEvents objectAtIndex:indexPath.row];
    
    cell.eventName.text = [me eventName];
    cell.eventDescription.text = [me eventDescription];
    cell.eventDate.text = [me eventDate];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MajorEvent *theMajorEvent = [_majorEvents objectAtIndex:indexPath.row];
    _selectedMajorEvent = theMajorEvent;

    [self performSegueWithIdentifier:@"MajorEventDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MajorEventDetail"])
    {
        MajorEventsDetailViewController* detailView = [segue destinationViewController];
        [detailView setMajorEvent:_selectedMajorEvent];
    }
}

@end
