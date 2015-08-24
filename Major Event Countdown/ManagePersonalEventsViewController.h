//
//  ManagePersonalEventsViewController.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 28/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagePersonalEventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (readonly) IBOutlet UIBarButtonItem* revealButtonItem;

@property (nonatomic, retain) NSMutableArray* personalEvents;
@property (nonatomic, retain) NSMutableArray* personalItems;

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@property int selectedRow;

@end
