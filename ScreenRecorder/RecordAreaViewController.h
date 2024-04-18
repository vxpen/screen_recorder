//
//  RecordAreaViewController.h
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RecordAreaViewState)
{
    RecordAreaViewStateNormal,
    RecordAreaViewStateSelect,
    RecordAreaViewStateRecord,
};

@interface RecordAreaViewController : NSViewController

@property (assign, nonatomic) RecordAreaViewState viewState;

@end

NS_ASSUME_NONNULL_END
