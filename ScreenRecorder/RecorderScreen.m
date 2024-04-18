//
//  RecorderScreen.m
//  ScreenRecorder
//
//  Created by tbago on 2020/5/7.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "RecorderScreen.h"
#import <AppKit/AppKit.h>

@interface RecorderScreen()

@property (strong, nonatomic) AVCaptureSession              *captureSession;
@property (strong, nonatomic) AVCaptureMovieFileOutput      *movieFileOutput;
@property (assign, nonatomic) BOOL                          openInQuickTime;
@end

@implementation RecorderScreen

- (BOOL)startRecordScreen:(NSURL *)destPath
                framerate:(float) framerate
                 cropRect:(CGRect) cropRect
             captureMouse:(BOOL) captureMouse
       highlighMouseClick:(BOOL) highlightMosueClick
         enableMicrophone:(BOOL) enableMicrophone
{
    // Create a capture session
    self.captureSession = [[AVCaptureSession alloc] init];

    // Set the session preset as you wish
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;

    // If you're on a multi-display system and you want to capture a secondary display,
    // you can call CGGetActiveDisplayList() to get the list of all active displays.
    // For this example, we just specify the main display.
    // To capture both a main and secondary display at the same time, use two active
    // capture sessions, one for each display. On Mac OS X, AVCaptureMovieFileOutput
    // only supports writing to a single video track.
    CGDirectDisplayID displayId = kCGDirectMainDisplay;

    // Create a ScreenInput with the display and add it to the session
    AVCaptureScreenInput *screenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:displayId];
    if (screenInput == nil) {
        self.captureSession = nil;
        return NO;
    }
    
    screenInput.minFrameDuration = CMTimeMake(1, framerate);
    screenInput.cropRect = cropRect;
    screenInput.capturesCursor = captureMouse;
    screenInput.capturesMouseClicks = highlightMosueClick;
    if ([self.captureSession canAddInput:screenInput]) {
        [self.captureSession addInput:screenInput];
    }

//    NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devices];
    if (enableMicrophone) {
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error = nil;
        AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice
                                                                                  error:&error];
        if ([self.captureSession canAddInput:audioInput]) {
            [self.captureSession addInput:audioInput];
        }
    }

    // Create a MovieFileOutput and add it to the session
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.captureSession canAddOutput:self.movieFileOutput]) {
        [self.captureSession addOutput:self.movieFileOutput];
    }

    // Start running the session
    [self.captureSession startRunning];

    // Delete any existing movie file first
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destPath path]]) {
        NSError *err = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:[destPath path] error:&err]) {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }

    // Start recording to the destination movie file
    // The destination path is assumed to end with ".mov", for example, @"/users/master/desktop/capture.mov"
    // Set the recording delegate to self
    [self.movieFileOutput startRecordingToOutputFileURL:destPath recordingDelegate:self];
    return YES;
}

- (void)stopRecordScreen:(BOOL) openInQuickTime
{
    // Stop recording to the destination movie file
    [self.movieFileOutput stopRecording];

    self.openInQuickTime = openInQuickTime;
}

// AVCaptureFileOutputRecordingDelegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
//    NSLog(@"Did finish recording to %@ due to error %@", [outputFileURL description], [error description]);

    // Stop running the session
    [self.captureSession stopRunning];

    // Release the session
    self.captureSession = nil;

    if (error == nil && self.openInQuickTime) {
        [[NSWorkspace sharedWorkspace] openURL:outputFileURL];
//        [[NSWorkspace sharedWorkspace] openFile:[NSString stringWithUTF8String:mStrDestPath.c_str()]
//         withApplication:@"QuickTime Player"];
    }
}


@end
