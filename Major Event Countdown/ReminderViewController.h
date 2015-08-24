//
//  ReminderViewController.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 15/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, retain) NSMutableArray* notifications;
@property (readonly) IBOutlet UIBarButtonItem* revealButtonItem;
@property int selectedRow;

@end
