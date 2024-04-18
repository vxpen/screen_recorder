//
//  ControlWindowController.h
//  ScreenRecorder
//
//  Created by tbago on 2020/4/29.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ControlWindowControllerDelegate <NSObject>

- (void)hideControls:(BOOL) hide;

- (void)changeRecodingState:(BOOL) isRecording;

@end

@interface ControlWindowController : NSWindowController

- (void)appendRecordAreaWindow:(NSWindow *) areaWindow
            areaViewController:(NSViewController *) areaViewController;

- (void)startRecordingVideo;

- (void)stopRecordingVideo;

- (void)snapImage;

- (void)openRecordFolder;

- (void)openImageFolder;

- (void)showPreference;

- (void)showAbout;

@property (weak, nonatomic, nullable) id<ControlWindowControllerDelegate>   controllerDelegate;

@end

NS_ASSUME_NONNULL_END
