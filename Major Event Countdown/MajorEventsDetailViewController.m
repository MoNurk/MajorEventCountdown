//
//  MajorEventsDetailViewController.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 14/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "MajorEventsDetailViewController.h"
#import "ConnectionToServer.h"
#import "TitleDetail.h"
#import "UIReminderActivity.h"
#import "UICalendarActivity.h"

@interface MajorEventsDetailViewController ()

@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;

@end

@implementation MajorEventsDetailViewController

@synthesize tableView = _tableView;
@synthesize majorEvent = _majorEvent;
@synthesize titlesAndText = _titlesAndText;
@synthesize actionButton = _actionButton;
@synthesize reminderButton = _reminderButton;
@synthesize scrollView = _scrollView;
@synthesize images = _images;

- (void) updateTable
{
    _titlesAndText = [[NSMutableArray alloc] init];
    
    NSArray* majorEventArray = [[NSArray alloc] initWithObjects: [_majorEvent eventName], [_majorEvent eventDescription], [_majorEvent category], [_majorEvent notes], [_majorEvent eventDate], nil];
    NSArray* titles = [[NSArray alloc] initWithObjects:@"Name", @"Description", @"Category", @"Notes", @"Date", nil];
    
    for (int i = 0; i < [majorEventArray count]; i++) {
        TitleDetail *td = [[TitleDetail alloc] initWithTitle:[titles objectAtIndex:i] detailText:[majorEventArray objectAtIndex:i]];
        
        [_titlesAndText addObject:td];
    }
    
    self.navigationItem.title = [_majorEvent eventName];
    
    [_tableView reloadData];
}

- (IBAction)showActionSheet:(id)sender
{
    NSMutableArray *activityItems = [[NSMutableArray alloc] initWithObjects:[_majorEvent eventName], nil];
    NSMutableArray *excludedItems = [[NSMutableArray alloc] init];
    
    if ([_images count] > 0)
    {
        int imageIndex = _scrollView.contentOffset.x / _scrollView.frame.size.width;
        NSLog(@"%i", imageIndex);
        
        [activityItems addObject:[_images objectAtIndex:imageIndex]];
        
        [excludedItems addObject:UIActivityTypePrint];
        [excludedItems addObject:UIActivityTypeAssignToContact];
        [excludedItems addObject:UIActivityTypeAddToReadingList];
    } else {
        [excludedItems addObject:UIActivityTypePrint];
        [excludedItems addObject:UIActivityTypeAssignToContact];
        [excludedItems addObject:UIActivityTypeAddToReadingList];
        [excludedItems addObject:UIActivityTypeSaveToCameraRoll];
    }
    
    UIReminderActivity *reminderActivity = [[UIReminderActivity alloc] initWithMajorEvent:_majorEvent];
    UICalendarActivity *calendarActivity = [[UICalendarActivity alloc] initWithMajorEvent:_majorEvent];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:[NSArray arrayWithObjects:reminderActivity, calendarActivity, nil]];
    activityController.excludedActivityTypes = excludedItems;
    [self presentViewController:activityController animated:YES completion:nil];
    
    activityController.completionHandler = ^(NSString *activityType, BOOL completed){
        NSLog(@"%@", activityType);
        
        if ([activityType isEqualToString:@"UI_ACTIVITY_CALENDAR"])
        {
            [self createCalendarEvent];
        }
    };
}

- (IBAction)remindOrCalendar:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"Remind Me", @"Add to Calendar", nil];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        [self setLocalNotification];
    }
    else if (buttonIndex == 1) {
        [self createCalendarEvent];
    }
}

- (void)setLocalNotification
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate* eventDate = [dateFormatter dateFromString:[_majorEvent eventDate]];
    
    NSLog(@"%@", [_majorEvent eventDate]);

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: eventDate];
    [components setMinute: [components minute] - 5];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    
    NSLog(@"%@", newDate);
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate = newDate;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.alertBody = [NSString stringWithFormat:@"It's time for %@", [_majorEvent eventName]];;
    notif.alertAction = @"view";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    
    NSArray* majorEventDetails = [[NSArray alloc] initWithObjects:[[NSNumber numberWithLong:[_majorEvent eventId]] stringValue], [_majorEvent eventName], [_majorEvent eventDescription], [_majorEvent eventDate], nil];
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObject: majorEventDetails
                                                         forKey:@"notificationId"];
    notif.userInfo = userDict;
    
    NSDate *today = [NSDate date];
    if ([eventDate compare:today] == NSOrderedDescending) {
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"Reminder has been scheduled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    else if ([eventDate compare:today] == NSOrderedAscending) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"Event has already passed, reminder cannot be scheduled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void) createCalendarEvent
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    [event setTitle:[_majorEvent eventName]];
    [event setNotes:[_majorEvent eventDescription]];
    [event setStartDate:[_majorEvent convertStringToDate]];
    [event setEndDate:[_majorEvent convertStringToDate]];
    
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
    // set the addController's event store to the current event store.
    [addController setEventStore: eventStore];
    [addController setEvent: event];
    addController.editViewDelegate = self;
    
    [eventStore requestAccessToEntityType:EKCalendarTypeLocal completion:^(BOOL granted, NSError *error) {
        if (granted) {
            // present EventsAddViewController as a modal view controller, on main thread
            [self performSelectorOnMainThread:@selector(presentEKEventEditViewController:) withObject:addController waitUntilDone:NO];
        }
    }];
}

- (void) presentEKEventEditViewController:(EKEventEditViewController*) EKEventVC
{
    [self presentViewController:EKEventVC animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateTable];

    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    
    _actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
    
    NSArray *buttons = @[_actionButton];
    
    [self.navigationItem setRightBarButtonItems:buttons];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    
    [_tableView setTableFooterView:_scrollView];
    
    _images = [[NSMutableArray alloc] init];
    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
            NSMutableArray * _json = [ConnectionToServer makeGETRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@majoreventcountdown/events/images/%ld", IP_ADDRESS_AMAZON_AWS, [_majorEvent eventId]]]];

        
        for (NSDictionary* item in _json) {
            NSString* url = (NSString *)[[item objectForKey:@"image"] objectForKey:@"imagePath"];
            [imageUrls addObject:url];
        }
        
        for (NSString* url in imageUrls) {
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            
            [_images addObject:image];
        }
        dispatch_async( dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [_images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageView setImage:image];
                
                CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
                if (screenRect.size.height == 548)
                {
                    imageView.frame = CGRectMake(idx * CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), 200);
                    [_scrollView addSubview:imageView];
                    
                    _scrollView.contentSize = CGSizeMake([imageUrls count] * CGRectGetWidth(self.view.bounds), _scrollView.frame.size.height);
                }
                else {
                    imageView.frame = CGRectMake(idx * CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), 110);
                    [_scrollView addSubview:imageView];
                    
                    _scrollView.contentSize = CGSizeMake([imageUrls count] * CGRectGetWidth(self.view.bounds), _scrollView.frame.size.height);
                }
            }];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titlesAndText count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    TitleDetail* titleDetail = [_titlesAndText objectAtIndex:indexPath.row];
    
    cell.textLabel.text = titleDetail.title;
    cell.detailTextLabel.text = titleDetail.detailText;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //TitleDetail* td = [_titlesAndText objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleDetail *td = [_titlesAndText objectAtIndex:indexPath.row];
    
    if ([td.detailText length] > 30) {
        NSString* text = [td detailText];
        UIFont* f = [UIFont systemFontOfSize:14];
        CGSize s = [text sizeWithFont: f constrainedToSize:CGSizeMake(280, 640)];
        
        return s.height + 35; //Padding of 35 pixels
    }
    else {
        return 44;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Event Information";
}

- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        TitleDetail* td = [_titlesAndText objectAtIndex:indexPath.row];
        
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:[td detailText]];
    }
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    
    NSError *error = nil;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            // Edit action canceled, do nothing.
            break;
            
        case EKEventEditViewActionSaved:
            //Create event in calendar
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            break;
            
        case EKEventEditViewActionDeleted:
            //Delete the event
            [controller.eventStore removeEvent:controller.event span:EKSpanThisEvent error:&error];
            break;
            
        default:
            break;
    }
    // Dismiss the modal view controller
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
