//
//  AppDelegate.h
//  Major Event Countdown
//
//  Created by Muhammed Nurkerim on 08/06/2013.
//  Copyright (c) 2013 Muhammed Nurkerim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView* notifView;
@property BOOL isFirstLaunch;

//Sounds
@property AVAudioPlayer* audioPlayer;
@property SystemSoundID soundID;

@property (strong, nonatomic) NSString *token;

@end
