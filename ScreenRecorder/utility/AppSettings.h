//
//  AppSettings.h
//  ScreenRecorder
//
//  Created by tbago on 2020/5/8.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppSettings : NSObject

+ (instancetype)sharedInstance;

- (void)storeAreaWindowRect:(CGRect) rect;

- (CGRect)getStoreAreaWindowRect;

- (void)setAutomicOpenVideoInQuickTime:(BOOL) automicOpenVideoInQuickTime;

- (BOOL)automicOpenVideoInQuickTime;

- (void)setHideControlsWhenRecording:(BOOL) hideControlsWhenRecording;

- (BOOL)hideControlsWhenRecording;

- (void)setCaptureMouse:(BOOL) captureMouse;

- (BOOL)captureMouse;

- (void)setHighlightMouseClick:(BOOL) highlightMouseClick;

- (BOOL)highlightMouseClick;

- (void)setRecordVideoFrameRate:(float) recordVideoFrameRate;

- (float)recordVideoFrameRate;

- (void)setEnableMicrophone:(BOOL) enableMicrophone;

- (BOOL)enableMicrophone;

@end

NS_ASSUME_NONNULL_END
