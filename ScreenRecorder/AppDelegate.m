//
//  AppDelegate.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/26.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "ControlWindowController.h"

@interface AppDelegate ()<ControlWindowControllerDelegate>

@property (weak) IBOutlet NSMenu                    *mainMenu;
@property (weak) IBOutlet NSMenuItem                *startStopMenuItem;
@property (weak) IBOutlet NSMenuItem                *snapImageMenuItem;
@property (weak) IBOutlet NSMenuItem                *showHideControlsMenuItem;

@property (strong, nonatomic) ControlWindowController   *controlWindowController;
@property (strong, nonatomic) NSWindowController        *recordAreaWindowController;

@property (strong, nonatomic) NSStatusItem              *statusMenuBar;
@property (assign, nonatomic) BOOL                      isRecording;
@property (assign, nonatomic) BOOL                      showControls;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

//    [self requestCameraAuthorization:^(BOOL authorized) {
        [self requestMicrophoneAuthorization:^(BOOL authorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self displayMainUI];
            });
        }];
//    }];

    _showControls = YES;
    _isRecording = NO;
}

- (void)displayMainUI {
    self.statusMenuBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusMenuBar.image = [NSImage imageNamed:@"status_bar_default_normal"];
    self.statusMenuBar.alternateImage = [NSImage imageNamed:@"status_bar_default_hover"];
    self.statusMenuBar.menu = self.mainMenu;

    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.controlWindowController = [storyboard instantiateControllerWithIdentifier:@"ControlWindowController"];
    [self.controlWindowController showWindow:nil];
    [self.controlWindowController.window makeKeyAndOrderFront:nil];
    self.controlWindowController.controllerDelegate = self;

    self.recordAreaWindowController = [storyboard instantiateControllerWithIdentifier:@"RecordAreaWindowController"];
    [self.recordAreaWindowController showWindow:nil];
    [self.recordAreaWindowController.window makeKeyAndOrderFront:nil];

    [self.controlWindowController appendRecordAreaWindow:self.recordAreaWindowController.window
                                      areaViewController:self.recordAreaWindowController.contentViewController];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - menu action

- (IBAction)startStopRecordingMenuClick:(NSMenuItem *)sender {
    self.isRecording = !self.isRecording;
    if (self.isRecording) {
        [self.controlWindowController startRecordingVideo];
    }
    else {
        [self.controlWindowController stopRecordingVideo];
    }
}

- (IBAction)snapImageMenuClick:(NSMenuItem *)sender {
    [self.controlWindowController snapImage];
}

- (IBAction)showHideControlMenuClick:(NSMenuItem *)sender {
    self.showControls = !self.showControls;
    if (!self.showControls) {
        if (self.controlWindowController.window.isVisible) {
            [self.controlWindowController.window orderOut:nil];
        }
        if (self.recordAreaWindowController.window.isVisible) {
            [self.recordAreaWindowController.window orderOut:nil];
        }
    }
    else {
        if (!self.controlWindowController.window.isVisible) {
            [self.controlWindowController.window makeKeyAndOrderFront:nil];
        }
        if (!self.recordAreaWindowController.window.isVisible) {
            [self.recordAreaWindowController.window makeKeyAndOrderFront:nil];
        }
        [NSApp activateIgnoringOtherApps:YES];
    }
}

- (IBAction)openRecordFolderMenuClick:(NSMenuItem *)sender {
    [self.controlWindowController openRecordFolder];
}

- (IBAction)openImageFolderMenuClick:(NSMenuItem *)sender {
    [self.controlWindowController openImageFolder];
}

- (IBAction)preferenceMenuClick:(NSMenuItem *)sender {
    [self.controlWindowController showPreference];
}

- (IBAction)abortMenuClick:(NSMenuItem *)sender {
    [self.controlWindowController showAbout];
}

#pragma mark - ControlWindowControllerDelegate

- (void)hideControls:(BOOL) hide {
    self.showControls = !hide;
}

- (void)changeRecodingState:(BOOL) isRecording {
    self.isRecording = isRecording;
}

#pragma mark - get & set

- (void)setIsRecording:(BOOL)isRecording {
    _isRecording = isRecording;
    if (_isRecording) {
        self.startStopMenuItem.title = @"Stop Recording";
        self.statusMenuBar.image = [NSImage imageNamed:@"status_bar_record_normal"];
        self.statusMenuBar.alternateImage = [NSImage imageNamed:@"status_bar_record_hover"];
    }
    else {
        self.startStopMenuItem.title = @"Start Recording";
        self.statusMenuBar.image = [NSImage imageNamed:@"status_bar_default_normal"];
        self.statusMenuBar.alternateImage = [NSImage imageNamed:@"status_bar_default_hover"];
    }
}

- (void)setShowControls:(BOOL)showControls {
    _showControls = showControls;
    if (_showControls) {
        self.showHideControlsMenuItem.title = @"Hide Controls";
    }
    else {
        self.showHideControlsMenuItem.title = @"Show Controls";
    }
}


#pragma mark - authorization

- (void)requestCameraAuthorization:(void(^)(BOOL authorized)) block {
    if (@available(macOS 10.14, *)) {
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
        {
            case AVAuthorizationStatusAuthorized: {
                block(YES);
                break;
            }
            case AVAuthorizationStatusNotDetermined: {
                // The app hasn't yet asked the user for camera access.
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        block(YES);
                    }
                    else {
                        block(NO);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusDenied: {
                // The user has previously denied access.
                block(NO);
            }
            case AVAuthorizationStatusRestricted: {
                // The user can't grant access due to restrictions.
                block(NO);
            }
        }
    }
    else {      ///< do nothing
        block(YES);
    }
}

- (void)requestMicrophoneAuthorization:(void(^)(BOOL authorized)) block {
    if (@available(macOS 10.14, *)) {
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio])
        {
            case AVAuthorizationStatusAuthorized: {
                block(YES);
                break;
            }
            case AVAuthorizationStatusNotDetermined: {
                // The app hasn't yet asked the user for camera access.
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        block(YES);
                    }
                    else {
                        block(NO);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusDenied: {
                // The user has previously denied access.
                block(NO);
            }
            case AVAuthorizationStatusRestricted: {
                // The user can't grant access due to restrictions.
                block(NO);
            }
        }
    }
    else {      ///< do nothing
        block(YES);
    }
}
@end
