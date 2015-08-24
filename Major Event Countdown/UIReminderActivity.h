//
//  UIReminderActivity.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 30/09/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MajorEvent.h"

@interface UIReminderActivity : UIActivity

@property (nonatomic, retain) MajorEvent * theEvent;

- (UIReminderActivity *) initWithMajorEvent:(MajorEvent *) event;

@end
