//
//  ControlWindowController.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/29.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "ControlWindowController.h"
#import "AppConfig.h"
#import "AppSettings.h"
#import "utility.h"
#import "RecordAreaWindow.h"
#import "ControlViewController.h"
#import "RecordAreaViewController.h"

#import "RecorderScreen.h"

@interface ControlWindowController ()<RecordAreaWindowDelegate, ControlViewControllerDelegate>

@property (strong, nonatomic) NSString                  *imageOutputPath;
@property (strong, nonatomic) NSString                  *videoOutputPath;
@property (weak, nonatomic) RecordAreaWindow            *areaWindow;
@property (weak, nonatomic) RecordAreaViewController    *areaViewController;
@property (weak, nonatomic) ControlViewController       *controlViewController;
@property (strong, nonatomic) RecorderScreen            *recorderScreen;
@property (assign, nonatomic) BOOL                      isRecording;
@end

@implementation ControlWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.level = NSPopUpMenuWindowLevel;

    self.imageOutputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"];
    self.imageOutputPath = [self.imageOutputPath stringByAppendingPathComponent:[AppConfig getBundleIdentifier]];
    NSError *error = nil;
    if (!createDirectoryIfNotExists(self.imageOutputPath, &error)) {
        NSLog(@"cannot create image output directory");
        self.imageOutputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"];
    }

    self.videoOutputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Movies"];
    self.videoOutputPath = [self.videoOutputPath stringByAppendingPathComponent:[AppConfig getBundleIdentifier]];
    if (!createDirectoryIfNotExists(self.videoOutputPath, &error)) {
        NSLog(@"cannot create video output directory");
        self.videoOutputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Movies"];
    }

    self.controlViewController = (ControlViewController *)self.window.contentViewController;
    self.controlViewController.controlViewDelegate = self;
}

#pragma mark - public method

- (void)appendRecordAreaWindow:(NSWindow *) areaWindow
            areaViewController:(NSViewController *) areaViewController
{
    self.areaWindow = (RecordAreaWindow *)areaWindow;
    self.areaWindow.windowDelegate = self;
    self.areaViewController = (RecordAreaViewController *)areaViewController;

    [self.controlViewController setCurrentAreaRect:[self.areaWindow getValidRect]];
}

- (void)startRecordingVideo {
    NSString *outputFileName = [[NSDate date] description];
    outputFileName = [outputFileName stringByAppendingPathExtension:@"mov"];
    NSString *outMoviePath = [self.videoOutputPath stringByAppendingPathComponent:outputFileName];
    CGRect rcArea = [self.areaWindow getValidRect];
    self.areaWindow.disableMoveAndDrag = YES;

    if ([[AppSettings sharedInstance] hideControlsWhenRecording]) {
        [self hideControlWindow:YES];
        [self hideRecordAreaWindow:YES];
        if (self.controllerDelegate != nil) {
            [self.controllerDelegate hideControls:YES];
        }
    }

    self.areaViewController.viewState = RecordAreaViewStateRecord;
    self.isRecording =  [self.recorderScreen startRecordScreen:[NSURL fileURLWithPath:outMoviePath]
                                                      framerate:[[AppSettings sharedInstance] recordVideoFrameRate]
                                                       cropRect:rcArea
                                                    captureMouse:[[AppSettings sharedInstance] captureMouse]
                                             highlighMouseClick:[[AppSettings sharedInstance] highlightMouseClick]
                                              enableMicrophone:[[AppSettings sharedInstance] enableMicrophone]];

    if (self.controllerDelegate != nil) {
        [self.controllerDelegate changeRecodingState:YES];
    }
}

- (void)stopRecordingVideo {
    if (self.isRecording) {
        self.areaWindow.disableMoveAndDrag = NO;
        [self.recorderScreen stopRecordScreen:[[AppSettings sharedInstance]  automicOpenVideoInQuickTime]];
        self.areaViewController.viewState = RecordAreaViewStateNormal;

        self.isRecording = NO;
        
        if (self.controllerDelegate != nil) {
            [self.controllerDelegate changeRecodingState:NO];
        }
    }
}

- (void)snapImage {
    NSSound *systemSound = [NSSound soundNamed:@"Glass"];
    [systemSound play];

    NSString *outputFileName = [[NSDate date] description];
    outputFileName = [outputFileName stringByAppendingPathExtension:@"png"];
    NSString *outputPath = [self.imageOutputPath stringByAppendingPathComponent:outputFileName];

    CGRect rcArea = [self.areaWindow getValidRect];
    rcArea.origin.y = [[NSScreen mainScreen] frame].size.height - rcArea.size.height - rcArea.origin.y;

    BOOL showAreaWindow = self.areaWindow.visible;
    BOOL showControlWindow = self.window.visible;
    if (showAreaWindow) {
        [self hideRecordAreaWindow:YES];
    }
    if (showControlWindow) {
        [self hideControlWindow:YES];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveScreenToImage:outputPath rcPos:rcArea];
        if (showAreaWindow) {
            [self hideRecordAreaWindow:NO];
        }
        if (showControlWindow) {
            [self hideControlWindow:NO];
        }
    });
}

- (void)showPreference {
    NSWindowController *preferenceWindowController = [self.storyboard instantiateControllerWithIdentifier:@"PreferencesWindowController"];
    preferenceWindowController.window.level = NSPopUpMenuWindowLevel;
    [preferenceWindowController.window makeKeyAndOrderFront:self.window];
}

- (void)openRecordFolder {
    NSURL *folderUrl = [NSURL fileURLWithPath:self.videoOutputPath];
    [[NSWorkspace sharedWorkspace] openURL: folderUrl];
}

- (void)openImageFolder {
    NSURL *folderUrl = [NSURL fileURLWithPath:self.imageOutputPath];
    [[NSWorkspace sharedWorkspace] openURL: folderUrl];
}

- (void)showAbout {
    NSWindowController *aboutWindowController = [self.storyboard instantiateControllerWithIdentifier:@"AboutWindowController"];
    aboutWindowController.window.level = NSPopUpMenuWindowLevel;
    [aboutWindowController.window makeKeyAndOrderFront:nil];
}

#pragma mark - RecordAreaWindowDelegate

- (void)recordAreaWindow:(RecordAreaWindow *) recordAreaWindow didChangeRect:(CGRect) rect {
    NSLog(@"area x:%f, y:%f, width:%f, height:%f", rect.origin.x,
          rect.origin.y, rect.size.width, rect.size.height);

    [self.controlViewController setCurrentAreaRect:rect];
}

- (void)didEnterDragMode:(RecordAreaWindow *) recordAreaWindow {
    self.areaViewController.viewState = RecordAreaViewStateSelect;
}

- (void)didExitDragMode:(RecordAreaWindow *) recordAreaWindow {
    if (self.areaViewController.viewState != RecordAreaViewStateRecord) {
        self.areaViewController.viewState = RecordAreaViewStateNormal;
    }
}

#pragma mark - ControlViewControllerDelegate

- (void)didClickRecordButton {
    if (self.isRecording) {
        [self stopRecordingVideo];
    }
    else {
        [self startRecordingVideo];
    }
}

- (void)didClickSnapImageButton {
    [self snapImage];
}

- (void)didChangeAreaWindowRect:(CGRect) areaWindowRect {
    [self.areaWindow setValidRect:NSRectFromCGRect(areaWindowRect)];
}

#pragma mark - private method

- (void)saveScreenToImage:(NSString *) destPath
                    rcPos:(CGRect)  rcRect
{
    CGImageRef screenShot = CGWindowListCreateImage(rcRect, kCGWindowListOptionAll, kCGNullWindowID, kCGWindowImageDefault);
    NSImage *image = [[NSImage alloc] initWithCGImage:screenShot size:NSZeroSize];

    // Cache the reduced image
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    [imageData writeToFile:destPath atomically:NO];

    CFRelease(screenShot);
}

///< 隐藏或显示控制窗体
- (void)hideControlWindow:(BOOL) hide {
    if(hide) {
        if (self.window.isVisible) {
            [self.window orderOut:self];
        }
    }
    else {
        if (!self.window.isVisible) {
            [self.window makeKeyAndOrderFront:nil];
            [NSApp activateIgnoringOtherApps:YES];
        }
    }
}

///< 隐藏或显示区域窗体
- (void)hideRecordAreaWindow:(BOOL) hide {
    if(hide) {
        if (self.areaWindow.isVisible) {
            [self.areaWindow orderOut:self];
        }
    }
    else {
        if (!self.areaWindow.isVisible) {
            [self.areaWindow makeKeyAndOrderFront:nil];
            [NSApp activateIgnoringOtherApps:YES];
        }
    }
}

#pragma mark - get & set

- (RecorderScreen *)recorderScreen {
    if (_recorderScreen == nil) {
        _recorderScreen = [[RecorderScreen alloc] init];
    }
    return _recorderScreen;
}
@end
