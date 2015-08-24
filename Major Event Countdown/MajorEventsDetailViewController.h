//
//  MajorEventsDetailViewController.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 14/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "MajorEvent.h"

@interface MajorEventsDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, EKEventEditViewDelegate>

@property (retain, nonatomic) MajorEvent* majorEvent;
@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem * actionButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem * reminderButton;
@property (retain, nonatomic) IBOutlet UIScrollView* scrollView;

@property (nonatomic, retain) NSMutableArray* titlesAndText;

@property (nonatomic, retain) NSMutableArray *images;

- (void)setLocalNotification;

@end
