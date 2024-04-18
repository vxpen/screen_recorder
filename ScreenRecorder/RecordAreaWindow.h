//
//  RecordAreaWindow.h
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class RecordAreaWindow;

@protocol RecordAreaWindowDelegate <NSObject>

- (void)recordAreaWindow:(RecordAreaWindow *) recordAreaWindow didChangeRect:(CGRect) rect;

- (void)didEnterDragMode:(RecordAreaWindow *) recordAreaWindow;

- (void)didExitDragMode:(RecordAreaWindow *) recordAreaWindow;

@end

@interface RecordAreaWindow : NSWindow

- (NSRect)getValidRect;

- (void)setValidRect:(NSRect) inputRect;

///< when recording video not allow drag and move
@property (assign, nonatomic) BOOL                  disableMoveAndDrag;

@property (weak, nonatomic, nullable) id<RecordAreaWindowDelegate>  windowDelegate;

@end

NS_ASSUME_NONNULL_END
