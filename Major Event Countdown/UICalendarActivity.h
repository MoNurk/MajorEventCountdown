//
//  UICalendarActivity.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 30/09/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MajorEvent.h"

@interface UICalendarActivity : UIActivity

@property (nonatomic, retain) MajorEvent * theEvent;

- (UICalendarActivity *) initWithMajorEvent:(MajorEvent *) event;

@end
