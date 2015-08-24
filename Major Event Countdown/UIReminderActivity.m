//
//  UIReminderActivity.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 30/09/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "UIReminderActivity.h"

@implementation UIReminderActivity

@synthesize theEvent = _theEvent;

- (UIReminderActivity *) initWithMajorEvent:(MajorEvent *)event
{
    _theEvent = event;
    
    return self;
}

- (NSString *) activityType
{
    return @"UI_ACTIVITY_REMINDER";
}

- (NSString *) activityTitle
{
    return @"Set Reminder";
}

- (UIImage *) activityImage
{
    return [UIImage imageNamed:@"Alarm@2x.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __FUNCTION__);
    
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    NSLog(@"%s",__FUNCTION__);
    
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity
    
    NSLog(@"Hello");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate* eventDate = [dateFormatter dateFromString:[_theEvent eventDate]];
    
    NSLog(@"%@", [_theEvent eventDate]);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: eventDate];
    [components setMinute: [components minute] - 5];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    
    NSLog(@"%@", newDate);
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate = newDate;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.alertBody = [NSString stringWithFormat:@"It's time for %@", [_theEvent eventName]];;
    notif.alertAction = @"view";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    
    NSArray* majorEventDetails = [[NSArray alloc] initWithObjects:[[NSNumber numberWithLong:[_theEvent eventId]] stringValue], [_theEvent eventName], [_theEvent eventDescription], [_theEvent eventDate], nil];
    
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
    
    [self activityDidFinish:YES];
    
    /*EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    [event setTitle:[_theEvent eventName]];
    [event setNotes:[_theEvent eventDescription]];
    [event setStartDate:[_theEvent convertStringToDate]];
    [event setEndDate:[_theEvent convertStringToDate]];
    
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
    
    [self activityDidFinish:YES];*/
}

@end
