//
//  RecordAreaViewController.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "RecordAreaViewController.h"

@interface RecordAreaViewController()

@property (weak) IBOutlet NSView        *recordBorderView;
@property (weak) IBOutlet NSImageView   *topBorderImageView;
@property (weak) IBOutlet NSImageView   *leftBorderImageView;
@property (weak) IBOutlet NSImageView   *rightBorderImageView;
@property (weak) IBOutlet NSImageView   *bottomBorderImageView;
@property (weak) IBOutlet NSImageView   *topLeftImageView;
@property (weak) IBOutlet NSImageView   *topRightImageView;
@property (weak) IBOutlet NSImageView   *bottomLeftImageView;
@property (weak) IBOutlet NSImageView   *bottomRightImageView;
@property (weak) IBOutlet NSTextField   *tipTextField;

@end

@implementation RecordAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.recordBorderView.wantsLayer = YES;
    self.recordBorderView.layer.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.4].CGColor;
}

- (void)viewDidAppear {
}

#pragma mark - get & set

- (void)setViewState:(RecordAreaViewState)viewState {
    if (_viewState != viewState) {
        _viewState = viewState;
        if (_viewState == RecordAreaViewStateNormal) {
            self.topBorderImageView.image = [NSImage imageNamed:@"normal_top_bottom"];
            self.leftBorderImageView.image = [NSImage imageNamed:@"normal_left_right"];
            self.rightBorderImageView.image = [NSImage imageNamed:@"normal_left_right"];
            self.bottomBorderImageView.image = [NSImage imageNamed:@"normal_top_bottom"];
            [self hideCornerImageView:NO];
            self.tipTextField.hidden = NO;
            self.recordBorderView.layer.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.4].CGColor;
        }
        else if (_viewState == RecordAreaViewStateSelect) {
            self.topBorderImageView.image = [NSImage imageNamed:@"select_top_bottom"];
            self.leftBorderImageView.image = [NSImage imageNamed:@"select_left_right"];
            self.rightBorderImageView.image = [NSImage imageNamed:@"select_left_right"];
            self.bottomBorderImageView.image = [NSImage imageNamed:@"select_top_bottom"];
            [self hideCornerImageView:YES];
            self.tipTextField.hidden = NO;
            self.recordBorderView.layer.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        }
        else if (_viewState == RecordAreaViewStateRecord) {
            self.topBorderImageView.image = [NSImage imageNamed:@"recording_top_bottom"];
            self.leftBorderImageView.image = [NSImage imageNamed:@"recording_left_right"];
            self.rightBorderImageView.image = [NSImage imageNamed:@"recording_left_right"];
            self.bottomBorderImageView.image = [NSImage imageNamed:@"recording_top_bottom"];
            self.recordBorderView.layer.backgroundColor = [NSColor clearColor].CGColor;
            [self hideCornerImageView:YES];
            self.tipTextField.hidden = YES;
        }
    }
}

#pragma mark - private method

- (void)hideCornerImageView:(BOOL) hide {
    self.topLeftImageView.hidden = hide;
    self.topRightImageView.hidden = hide;
    self.bottomLeftImageView.hidden = hide;
    self.bottomRightImageView.hidden = hide;
}
@end
