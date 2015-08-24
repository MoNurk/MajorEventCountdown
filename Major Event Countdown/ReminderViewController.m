//
//  ReminderViewController.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 15/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController ()

@end

@implementation ReminderViewController

@synthesize notifications = _notifications;
@synthesize revealButtonItem = _revealButtonItem;
@synthesize selectedRow = _selectedRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    
    [self populateNotifications];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateNotifications
{
    _notifications = [[NSMutableArray alloc] init];
    
    for (UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]){
        [_notifications addObject:aNotif];
    }
    
    [self.tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self cancelReminder];
    }
    else if (buttonIndex == 1) {
        [self cancelAll];
    }
}

- (void)cancelReminder
{
    UILocalNotification *notificationToCancel = nil;
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        UILocalNotification* notificaiton = [_notifications objectAtIndex:_selectedRow];
        
        NSArray* theTableNotificationEvent = [notificaiton.userInfo objectForKey:@"notificationId"];
        NSArray* aNotifEvent = [aNotif.userInfo objectForKey:@"notificationId"];
        
        if([[aNotifEvent objectAtIndex:1] isEqualToString:[theTableNotificationEvent objectAtIndex:1]]) {
            notificationToCancel = aNotif;
            break;
        }
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    
    [self populateNotifications];
}

- (void) cancelAll
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self populateNotifications];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReminderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    NSTimeZone *local = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:local];
    
    UILocalNotification* notif = [_notifications objectAtIndex:indexPath.row];
    NSString *fireDate = [dateFormatter stringFromDate:[notif fireDate]];
    
    NSArray* majorEvent = [notif.userInfo objectForKey:@"notificationId"];
    
    cell.textLabel.text = [majorEvent objectAtIndex:1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Reminder Time: %@", fireDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Reminder" delegate:self cancelButtonTitle:@"Do Nothing" destructiveButtonTitle: nil otherButtonTitles: @"Cancel Reminder", @"Cancel All", nil];
    
    [actionSheet showInView:self.view];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
