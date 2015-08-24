//
//  AddMajorEventViewController.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 27/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MajorEvent.h"

@class AddMajorEventViewController;

@protocol AddMajorEventViewControllerDelegate <NSObject>

@optional

- (void)myModalViewControllerDidFinishAddingEvent:(AddMajorEventViewController *)controller;
- (void)myModalViewControllerDidCancel:(AddMajorEventViewController *)controller;

@end

@interface AddMajorEventViewController : UIViewController <UITextFieldDelegate> 

//UI Elements
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) UIDatePicker* datePicker;

//Array(s)
@property (nonatomic, retain) NSMutableArray* placeholderTexts;

//Variables
@property (nonatomic, retain) MajorEvent* majorEvent;
@property (nonatomic, retain) NSString* dateTo;

@property (assign) id <AddMajorEventViewControllerDelegate> delegate;

@property (nonatomic, retain) UINavigationBar * customBar;


- (IBAction)updateEventDetails:(id)sender;

@end
