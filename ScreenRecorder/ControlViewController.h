//
//  ControlViewController.h
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ControlViewControllerDelegate <NSObject>

- (void)didClickRecordButton;

- (void)didClickSnapImageButton;

- (void)didChangeAreaWindowRect:(CGRect) areaWindowRect;
@end

@interface ControlViewController : NSViewController

- (void)setCurrentAreaRect:(CGRect) areaRect;

@property (weak, nonatomic, nullable) id<ControlViewControllerDelegate>  controlViewDelegate;

@end

NS_ASSUME_NONNULL_END
