//
//  PreferenceViewController.m
//  ScreenRecorder
//
//  Created by tbago on 2020/5/8.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "PreferenceViewController.h"
#import "AppSettings.h"
@interface PreferenceViewController ()

@property (weak) IBOutlet NSButton      *automicOpenVideoInQuickTimeButton;
@property (weak) IBOutlet NSButton      *hideControlsWhenRecordingButton;
@property (weak) IBOutlet NSButton      *captureMosueButton;
@property (weak) IBOutlet NSButton      *highlightMouseClickButton;

@property (weak) IBOutlet NSPopUpButton *frameRatePopUpButton;

@end

@implementation PreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.frameRatePopUpButton addItemsWithTitles:@[@"60 FPS",
    @"30 FPS", @"25 FPS", @"20 FPS", @"15 FPS"]];

    self.automicOpenVideoInQuickTimeButton.state = [[AppSettings sharedInstance] automicOpenVideoInQuickTime];
    self.hideControlsWhenRecordingButton.state = [[AppSettings sharedInstance] hideControlsWhenRecording];
    self.captureMosueButton.state = [[AppSettings sharedInstance] captureMouse];
    self.highlightMouseClickButton.state = [[AppSettings sharedInstance] highlightMouseClick];

    NSInteger storeFrameRate = (NSInteger)[[AppSettings sharedInstance] recordVideoFrameRate];
    if (storeFrameRate == 60) {
        [self.frameRatePopUpButton selectItemAtIndex:0];
    }
    else if (storeFrameRate == 30) {
        [self.frameRatePopUpButton selectItemAtIndex:1];
    }
    else if (storeFrameRate == 25) {
        [self.frameRatePopUpButton selectItemAtIndex:2];
    }
    else if (storeFrameRate == 20) {
        [self.frameRatePopUpButton selectItemAtIndex:3];
    }
    else if (storeFrameRate == 15) {
        [self.frameRatePopUpButton selectItemAtIndex:4];
    }
}

#pragma mark - action

- (IBAction)automaticOpenVideoInQuickTimeClick:(NSButton *)sender {
    [[AppSettings sharedInstance] setAutomicOpenVideoInQuickTime:sender.state];
}

- (IBAction)hideControlsWhenRecordingClick:(NSButton *)sender {
    [[AppSettings sharedInstance] setHideControlsWhenRecording:sender.state];
}

- (IBAction)captureMouseClick:(NSButton *)sender {
    [[AppSettings sharedInstance] setCaptureMouse:sender.state];
}

- (IBAction)highlightMouseClick:(NSButton *)sender {
    [[AppSettings sharedInstance] setHighlightMouseClick:sender.state];
}

- (IBAction)videoFrameRateChange:(NSPopUpButton *)sender {
    NSInteger selectIndex = sender.indexOfSelectedItem;
    if (selectIndex == 0) {
        [[AppSettings sharedInstance] setRecordVideoFrameRate:60];
    }
    else if (selectIndex == 1) {
        [[AppSettings sharedInstance] setRecordVideoFrameRate:30];
    }
    else if (selectIndex == 2) {
        [[AppSettings sharedInstance] setRecordVideoFrameRate:25];
    }
    else if (selectIndex == 3) {
        [[AppSettings sharedInstance] setRecordVideoFrameRate:20];
    }
    else if (selectIndex == 4) {
        [[AppSettings sharedInstance] setRecordVideoFrameRate:15];
    }
}

@end
