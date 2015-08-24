//
//  FilteredMajorEventsViewController.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 10/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MajorEvent.h"

@interface FilteredMajorEventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
 
    NSString* navTitle;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@property (nonatomic, retain) NSMutableArray* majorEvents;
@property (nonatomic, retain) NSMutableArray* json;

@property (strong, atomic) NSString* category;
@property (retain, nonatomic) NSString* navTitle;
@property (readonly) IBOutlet UIBarButtonItem* revealButtonItem;

@property (nonatomic, retain) MajorEvent* selectedMajorEvent;

- (void) setEventCategory:(NSString *)category;

@end
