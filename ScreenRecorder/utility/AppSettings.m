//
//  AppSettings.m
//  ScreenRecorder
//
//  Created by tbago on 2020/5/8.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "AppSettings.h"
#import <AppKit/AppKit.h>

static NSString * const kStoreAreaWindowRectKey = @"StoreAreaWindowRect";
static NSString * const kAutomicOpenVideoInQuickTimeKey = @"AutomicOpenVideoInQuickTime";
static NSString * const kHideControlsWhenRecordingKey = @"HideControlsWhenRecording";
static NSString * const kCaptureMouseKey = @"CaptureMouse";
static NSString * const kHighlightMouseClickKey = @"HighlightMouseClick";
static NSString * const kRecordVideoFrameRateKey = @"RecordVideoFrameRate";
static NSString * const kEnableMicrophoneKey = @"EanbleMicrophone";

@implementation AppSettings

+ (instancetype)sharedInstance {
    static AppSettings *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[AppSettings alloc] init];
    });
    return sInstance;
}

#pragma mark - public method

- (void)storeAreaWindowRect:(CGRect) rect {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *formatString = [NSString stringWithFormat:@"%f,%f,%f,%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
    [defaults setObject:formatString forKey:kStoreAreaWindowRectKey];
    [defaults synchronize];
}

- (CGRect)getStoreAreaWindowRect {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kStoreAreaWindowRectKey] != nil) {
        NSString *areaWindowRectString = [defaults objectForKey:kStoreAreaWindowRectKey];
        float x, y, width, height;
        sscanf(areaWindowRectString.UTF8String, "%f,%f,%f,%f", &x, &y, &width, &height);
        CGRect storeRect = CGRectMake(x, y, width, height);
        return storeRect;
    }
    else {
        return CGRectMake(0, [NSScreen mainScreen].frame.size.height-480, 640, 480);
    }
}

- (void)setAutomicOpenVideoInQuickTime:(BOOL) automicOpenVideoInQuickTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(automicOpenVideoInQuickTime) forKey:kAutomicOpenVideoInQuickTimeKey];
    [defaults synchronize];
}

- (BOOL)automicOpenVideoInQuickTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kAutomicOpenVideoInQuickTimeKey] != nil) {
        return [[defaults objectForKey:kAutomicOpenVideoInQuickTimeKey] boolValue];
    }
    else {
        return YES;
    }
}

- (void)setHideControlsWhenRecording:(BOOL) hideControlsWhenRecording {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(hideControlsWhenRecording) forKey:kHideControlsWhenRecordingKey];
    [defaults synchronize];
}

- (BOOL)hideControlsWhenRecording {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kHideControlsWhenRecordingKey] != nil) {
        return [[defaults objectForKey:kHideControlsWhenRecordingKey] boolValue];
    }
    else {
        return YES;
    }
}

- (void)setCaptureMouse:(BOOL) captureMouse {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(captureMouse) forKey:kCaptureMouseKey];
    [defaults synchronize];
}

- (BOOL)captureMouse {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kCaptureMouseKey] != nil) {
        return [[defaults objectForKey:kCaptureMouseKey] boolValue];
    }
    else {
        return YES;
    }
}

- (void)setHighlightMouseClick:(BOOL) highlightMouseClick {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(highlightMouseClick) forKey:kHighlightMouseClickKey];
    [defaults synchronize];
}

- (BOOL)highlightMouseClick {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kHighlightMouseClickKey] != nil) {
        return [[defaults objectForKey:kHighlightMouseClickKey] boolValue];
    }
    else {
        return YES;
    }
}

- (void)setRecordVideoFrameRate:(float) recordVideoFrameRate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(recordVideoFrameRate) forKey:kRecordVideoFrameRateKey];
    [defaults synchronize];
}

- (float)recordVideoFrameRate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kRecordVideoFrameRateKey] != nil) {
        return [[defaults objectForKey:kRecordVideoFrameRateKey] floatValue];
    }
    else {
        return 60;
    }
}

- (void)setEnableMicrophone:(BOOL) enableMicrophone {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(enableMicrophone) forKey:kEnableMicrophoneKey];
    [defaults synchronize];
}

- (BOOL)enableMicrophone {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kEnableMicrophoneKey] != nil) {
        return [[defaults objectForKey:kEnableMicrophoneKey] boolValue];
    }
    else {
        return YES;
    }
}
@end
