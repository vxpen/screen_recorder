//
//  AboutViewController.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/29.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "AboutViewController.h"

#import "AppConfig.h"

@interface AboutViewController ()

@property (weak) IBOutlet NSImageView   *logoImageView;
@property (weak) IBOutlet NSTextField   *productNameTextField;
@property (weak) IBOutlet NSTextField   *versionTextField;
@property (weak) IBOutlet NSButton      *supportEmailButton;
@property (weak) IBOutlet NSTextField   *copyrightTextField;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logoImageView.image = [NSImage imageNamed:[AppConfig getLogoIconName]];
    self.productNameTextField.stringValue = [AppConfig getProductName];
    self.versionTextField.stringValue = [NSString stringWithFormat:@"%@ : %@.%@",
                                         @"Version", [AppConfig getProductVersion], [AppConfig getBuildVersion]];
    self.copyrightTextField.stringValue = [AppConfig getCopyrightInfo];

    NSAttributedString *supportEmailString = [[NSAttributedString alloc] initWithString:[AppConfig getSupportEmail]
                                                                             attributes:@{NSUnderlineColorAttributeName : [NSColor blueColor],
                                                                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                                                                                         NSForegroundColorAttributeName :[NSColor blackColor],
                                                                             }];

    self.supportEmailButton.attributedTitle = supportEmailString;
}

#pragma mark - action

- (IBAction)supportEmailButtonClick:(NSButton *)sender {
    NSString *emailString = [NSString stringWithFormat:@"mailto:%@", [AppConfig getSupportEmail]];
    NSURL *emailUrl = [NSURL URLWithString:emailString];
    [[NSWorkspace sharedWorkspace] openURL:emailUrl];
}

@end
