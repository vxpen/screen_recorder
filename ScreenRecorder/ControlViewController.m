//
//  ControlViewController.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "ControlViewController.h"
#import "ControlWindowController.h"
#import "OnlyIntegerValueFormatter.h"
#import "AppSettings.h"

@interface ControlViewController ()

@property (weak) IBOutlet NSButton      *recordButton;
@property (weak) IBOutlet NSButton      *snapImageButton;
@property (weak) IBOutlet NSTextField   *areaWidthTextField;
@property (weak) IBOutlet NSTextField   *areaHeightTextField;
@property (weak) IBOutlet NSPopUpButton *areaSizePopUpButton;
@property (weak) IBOutlet NSButton      *recordAudioButton;
@property (strong, nonatomic) NSArray   *areaSizeArray;
@property (assign, nonatomic) CGRect    inputAreaRect;
@end

@implementation ControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.recordButton.toolTip = @"Start or Stop recording";
    self.snapImageButton.toolTip = @"Snap an image";

    self.areaSizeArray = @[@"Custom Preset Size", @"Full Screen", @"1920*1080", @"1280*720", @"640*480"];
    [self.areaSizePopUpButton removeAllItems];
    [self.areaSizePopUpButton addItemsWithTitles:self.areaSizeArray];
    [self.areaSizePopUpButton selectItemAtIndex:0];
    NSMenuItem *customMenuItem = [self.areaSizePopUpButton selectedItem];
    NSNumber *alwaysNo = [NSNumber numberWithBool:NO];
    [customMenuItem bind:@"enabled" toObject:alwaysNo withKeyPath:@"boolValue" options:nil];
    customMenuItem.toolTip = @"Use special size";

    self.recordAudioButton.state = [[AppSettings sharedInstance] enableMicrophone];

    self.areaWidthTextField.formatter = [[OnlyIntegerValueFormatter alloc] init];
    self.areaHeightTextField.formatter = [[OnlyIntegerValueFormatter alloc] init];
}

#pragma mark - public method

- (void)setCurrentAreaRect:(CGRect) areaRect {
    self.inputAreaRect = areaRect;
    NSInteger integerWidth = (NSInteger)areaRect.size.width;
    NSInteger integerHeight = (NSInteger)areaRect.size.height;
    self.areaWidthTextField.integerValue = integerWidth;
    self.areaHeightTextField.integerValue = integerHeight;

    CGRect compareRect1080P = CGRectMake(0, [NSScreen mainScreen].frame.size.height - 1080, 1920, 1080);
    CGRect compareRect720P = CGRectMake(0, [NSScreen mainScreen].frame.size.height - 720, 1280, 720);
    CGRect compareRect480P = CGRectMake(0, [NSScreen mainScreen].frame.size.height - 480, 640, 480);

    if (CGRectEqualToRect(areaRect, [NSScreen mainScreen].frame)) {
        [self.areaSizePopUpButton selectItemAtIndex:1];
    }
    else if (CGRectEqualToRect(areaRect, compareRect1080P)) {
        [self.areaSizePopUpButton selectItemAtIndex:2];
    }
    else if (CGRectEqualToRect(areaRect, compareRect720P)) {
        [self.areaSizePopUpButton selectItemAtIndex:3];
    }
    else if (CGRectEqualToRect(areaRect, compareRect480P)) {
        [self.areaSizePopUpButton selectItemAtIndex:4];
    }
}

#pragma mark - action

- (IBAction)recordButtonClick:(NSButton *)sender {
    if (self.controlViewDelegate != nil) {
        [self.controlViewDelegate didClickRecordButton];
    }
}

- (IBAction)snapImageButtonClick:(NSButton *)sender {
    if (self.controlViewDelegate != nil) {
        [self.controlViewDelegate didClickSnapImageButton];
    }
}
- (IBAction)widthTextFiledDidEndEditing:(NSTextField *)sender {
    NSInteger changedWidth = sender.integerValue;
    if (changedWidth > [NSScreen mainScreen].frame.size.width) {
        sender.integerValue = self.inputAreaRect.size.width;
        return;
    }

    self.inputAreaRect = CGRectMake(self.inputAreaRect.origin.x, self.inputAreaRect.origin.y, changedWidth, self.inputAreaRect.size.height);
    if (self.controlViewDelegate != nil) {
        [self.controlViewDelegate didChangeAreaWindowRect:self.inputAreaRect];
    }
}

- (IBAction)heightTextFieldDidEndEditing:(NSTextField *)sender {
    NSInteger changedHeight = sender.integerValue;
    if (changedHeight > [NSScreen mainScreen].frame.size.height) {
        sender.integerValue = self.inputAreaRect.size.height;
        return;
    }

    self.inputAreaRect = CGRectMake(self.inputAreaRect.origin.x, self.inputAreaRect.origin.y, self.inputAreaRect.size.width, changedHeight);
    if (self.controlViewDelegate != nil) {
        [self.controlViewDelegate didChangeAreaWindowRect:self.inputAreaRect];
    }
}

- (IBAction)areaSizePopUpButtonClick:(NSPopUpButton *)sender {
    NSInteger selectIndex  = sender.indexOfSelectedItem;
    switch (selectIndex) {
        case 1:
            self.inputAreaRect = CGRectMake(0, 0, [NSScreen mainScreen].frame.size.width, [NSScreen mainScreen].frame.size.height);
            break;
        case 2:
            self.inputAreaRect = CGRectMake(0, [NSScreen mainScreen].frame.size.height - 1080, 1920, 1080);
            break;
        case 3:
            self.inputAreaRect = CGRectMake(0, [NSScreen mainScreen].frame.size.height - 720, 1280, 720);
            break;
        case 4:
            self.inputAreaRect = CGRectMake(0, [NSScreen mainScreen].frame.size.height - 480, 640, 480);
            break;
        default:
            return;
    }

    if (self.controlViewDelegate != nil) {
        [self.controlViewDelegate didChangeAreaWindowRect:self.inputAreaRect];
    }
}

- (IBAction)recordAudioWithVideoButtonClick:(NSButton *)sender {
    [[AppSettings sharedInstance] setEnableMicrophone:sender.state];
}

@end
