//
//  AppDelegate.m
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 08/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize isFirstLaunch = _isFirstLaunch;
@synthesize token = _token;
@synthesize notifView = _notifView;
@synthesize soundID = _soundID;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    _isFirstLaunch = YES;
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [application setApplicationIconBadgeNumber:0];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Local Notification");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    [self.window setWindowLevel:UIWindowLevelStatusBar];
    
    NSString* alertText = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    CGRect frame = CGRectMake(0, -50, 320, 50);
    _notifView = [[UIView alloc] initWithFrame:frame];
    [_notifView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [_notifView setOpaque:NO];
    
    CGRect labelFrame = CGRectMake(10, 8, 300, 40);
    UILabel* notifLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [notifLabel setTextColor:[UIColor whiteColor]];
    [notifLabel setBackgroundColor:[UIColor clearColor]];
    [notifLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [notifLabel setNumberOfLines:2];
    [notifLabel setText:[NSString stringWithFormat:@"%@ Refresh to view.", alertText]];
    
    [_notifView addSubview:notifLabel];
    [self.window addSubview:_notifView];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &_soundID);
    AudioServicesPlaySystemSound (_soundID);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    CGAffineTransform transfrom = CGAffineTransformMakeTranslation(0, 50);
    _notifView.transform = transfrom;
    [UIView commitAnimations];
    
    [self performSelector:@selector(animateOffScreen) withObject:Nil afterDelay:5.0];
}

- (void) animateOffScreen
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    CGAffineTransform transfrom = CGAffineTransformMakeTranslation(0, -50);
    _notifView.transform = transfrom;
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeNotifViewFromWindow) withObject:nil afterDelay:1.5];
    
    [self.window setWindowLevel:UIWindowLevelNormal];
}

- (void) removeNotifViewFromWindow
{
    [_notifView removeFromSuperview];
    AudioServicesDisposeSystemSoundID(_soundID);
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *outer = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        NSString *strWithoutSpaces  = [NSString stringWithFormat:@"%@",deviceToken];
        strWithoutSpaces = [strWithoutSpaces stringByReplacingOccurrencesOfString:@" " withString:@""];
        strWithoutSpaces = [strWithoutSpaces stringByReplacingOccurrencesOfString:@"<" withString:@""];
        NSString *strDeviceToken = [strWithoutSpaces stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        _token = strDeviceToken;
        
        [data setObject:strDeviceToken  forKey:@"deviceToken"];
        [outer setObject:data forKey:@"device"];
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:outer options:NSJSONWritingPrettyPrinted error:&error];
        
        NSHTTPURLResponse* urlResponse = nil;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://23.21.180.33:8080/majoreventcountdown/general/addDevice"]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"POST"];
        [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
        });
    });
    
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
