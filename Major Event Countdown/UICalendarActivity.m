//
//  UICalendarActivity.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 30/09/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "UICalendarActivity.h"

@implementation UICalendarActivity

@synthesize theEvent = _theEvent;

- (UICalendarActivity *) initWithMajorEvent:(MajorEvent *)event
{
    _theEvent = event;
    
    return self;
}

- (NSString *) activityType
{
    return @"UI_ACTIVITY_CALENDAR";
}

- (NSString *) activityTitle
{
    return @"Add to Calendar";
}

- (UIImage *) activityImage
{
    return [UIImage imageNamed:@"Calendar@2x.png"];
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
    [self activityDidFinish:YES];
}


@end
