//
//  RecordAreaWindow.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//  1、图片只能缩放到图片当前最小长度（autosize问题，所以先暂定最小为400*400）
//

#import "RecordAreaWindow.h"
#import "EnumWindows.h"
#import "AppSettings.h"

static const NSInteger kCornerMinSize = 20;
static const NSInteger kMinimizeRecordSize = 400;
static const NSInteger kValidOffset = 12;

typedef NS_ENUM(NSInteger, MousePositon) {
    MousePositionNone,
    MousePositionLeft,
    MousePositionRight,
    MousePositionTop,
    MousePositionBottom,
    MousePositionLeftTop,
    MousePositionLeftBottom,
    MousePositionRightTop,
    MousePositionRightBottom,
    MousePositionCenter,
};

@interface RecordAreaWindow()

@property (assign, nonatomic) MousePositon  mousePosition;
@property (assign, nonatomic) CGRect        mouseDownWindowFrame;
@property (assign, nonatomic) CGPoint       mouseDownGlobalPosition;
@property (strong, nonatomic) EnumWindows   *enumWindows;
@end

@implementation RecordAreaWindow

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setLevel:NSStatusWindowLevel];

    CGRect storeRect = [[AppSettings sharedInstance] getStoreAreaWindowRect];
    [self setValidRect:storeRect];
}

- (void)mouseDragged:(NSEvent *) event {
    if (self.disableMoveAndDrag) {
        return;
    }

    //当前鼠标移动的point
    NSPoint globalLocation = [NSEvent mouseLocation];
    if (self.mousePosition == MousePositionNone) {
        return;
    }
    if (self.mousePosition == MousePositionLeft) {          //left
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x + (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.origin.y,
                                    self.mouseDownWindowFrame.size.width - (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.size.height);
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionRight) {    //right
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x,
                                    self.mouseDownWindowFrame.origin.y,
                                    self.mouseDownWindowFrame.size.width + (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.size.height);
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionTop) {      //top
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x,
                                    self.mouseDownWindowFrame.origin.y,
                                    self.mouseDownWindowFrame.size.width,
                                    self.mouseDownWindowFrame.size.height + (globalLocation.y - self.mouseDownGlobalPosition.y));
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionBottom) {   //bottom
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x,
                                    self.mouseDownWindowFrame.origin.y + (globalLocation.y - self.mouseDownGlobalPosition.y),
                                    self.mouseDownWindowFrame.size.width,
                                    self.mouseDownWindowFrame.size.height - (globalLocation.y - self.mouseDownGlobalPosition.y));
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionLeftTop) {   // left-top
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x + (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.origin.y,
                                    self.mouseDownWindowFrame.size.width - (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.size.height + (globalLocation.y - self.mouseDownGlobalPosition.y));
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionLeftBottom) {   // left-bottom
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x + (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.origin.y + (globalLocation.y - self.mouseDownGlobalPosition.y),
                                    self.mouseDownWindowFrame.size.width - (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.size.height - (globalLocation.y - self.mouseDownGlobalPosition.y));
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionRightTop) {     //right-top
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x,
                                    self.mouseDownWindowFrame.origin.y,
                                    self.mouseDownWindowFrame.size.width + (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.size.height + (globalLocation.y - self.mouseDownGlobalPosition.y));
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionRightBottom) {   //right-bottom
        CGRect newRect = NSMakeRect(self.mouseDownWindowFrame.origin.x,
                                    self.mouseDownWindowFrame.origin.y + (globalLocation.y - self.mouseDownGlobalPosition.y),
                                    self.mouseDownWindowFrame.size.width + (globalLocation.x - self.mouseDownGlobalPosition.x),
                                    self.mouseDownWindowFrame.size.height - (globalLocation.y - self.mouseDownGlobalPosition.y));
        [self setFrame:newRect display:YES animate:NO];
    }
    else if (self.mousePosition == MousePositionCenter) {
        if (NSCommandKeyMask & [NSEvent modifierFlags]) {
            if (self.windowDelegate != nil) {
                [self.windowDelegate didEnterDragMode:self];
            }
            NSRect  windowRect;
            BOOL findWindow = [self.enumWindows getCurWindow:globalLocation windowPos:&windowRect];
            if (findWindow) {
                [self setValidRect:windowRect];
            }
        }
        else {
            CGPoint locationPoint = CGPointMake(self.mouseDownWindowFrame.origin.x + globalLocation.x - self.mouseDownGlobalPosition.x,
                                                self.mouseDownWindowFrame.origin.y + globalLocation.y - self.mouseDownGlobalPosition.y);

            [self setFrameOrigin:locationPoint];
        }
    }
}

- (void)mouseDown:(NSEvent *)event {
    [self becomeMainWindow];

    if (self.disableMoveAndDrag) {
        return;
    }

    self.mouseDownGlobalPosition = [NSEvent mouseLocation];
    self.mouseDownWindowFrame = self.frame;

    NSRect windowFrame = self.frame;
    NSPoint mosueLocation = event.locationInWindow;
//    NSLog(@"mouse location:%f, %f", mosueLocation.x, mosueLocation.y);

    //判断鼠标点击区域
    if (mosueLocation.x < kCornerMinSize
        && mosueLocation.y > kCornerMinSize
        && windowFrame.size.height -mosueLocation.y > kCornerMinSize) {
        self.mousePosition = MousePositionLeft;
//        NSLog(@"left position");
    }
    else if (mosueLocation.x <= kCornerMinSize
             && windowFrame.size.height - mosueLocation.y < kCornerMinSize) {
        self.mousePosition = MousePositionLeftTop;
//        NSLog(@"left top position");
    }
    else if (mosueLocation.x <= kCornerMinSize
             && mosueLocation.y <= kCornerMinSize) {
        self.mousePosition = MousePositionLeftBottom;
//        NSLog(@"left bottom position");
    }
    else if (windowFrame.size.width - mosueLocation.x < kCornerMinSize
             && mosueLocation.y > kCornerMinSize
             && windowFrame.size.height - mosueLocation.y > kCornerMinSize) {
        self.mousePosition = MousePositionRight;
//        NSLog(@"right position");
    }
    else if (windowFrame.size.width - mosueLocation.x <= kCornerMinSize
             && windowFrame.size.height - mosueLocation.y <= kCornerMinSize) {
        self.mousePosition = MousePositionRightTop;
//        NSLog(@"right top position");
    }
    else if (mosueLocation.y - windowFrame.origin.y <= kCornerMinSize
             && windowFrame.size.width - mosueLocation.x <= kCornerMinSize) {
        self.mousePosition = MousePositionRightBottom;
//        NSLog(@"right bottom position");
    }
    else if (windowFrame.size.height - mosueLocation.y < kCornerMinSize
             && mosueLocation.x > kCornerMinSize
             && windowFrame.size.width - mosueLocation.x > kCornerMinSize) {
        self.mousePosition = MousePositionTop;
//        NSLog(@"top position");
    }
    else if (mosueLocation.y < kCornerMinSize
             && mosueLocation.x > kCornerMinSize
             && windowFrame.size.width - mosueLocation.x > kCornerMinSize) {
        self.mousePosition = MousePositionBottom;
//        NSLog(@"bottom position");
    }
    else {
        self.mousePosition = MousePositionCenter;
        [self.enumWindows updateWindowsList];
//        NSLog(@"center position");
    }
}

- (void)mouseUp:(NSEvent *)event
{
    if (self.windowDelegate != nil) {
        [self.windowDelegate didExitDragMode:self];
    }
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animateFlag
{
    if (frameRect.size.width < kMinimizeRecordSize || frameRect.size.height < kMinimizeRecordSize) {
        return;
    }
    [super setFrame:frameRect display:displayFlag animate:animateFlag];
    CGRect validRect = [self getValidRect];
    if (self.windowDelegate != nil) {
        [self.windowDelegate recordAreaWindow:self didChangeRect:validRect];
    }

    [[AppSettings sharedInstance] storeAreaWindowRect:validRect];
}

///< 得到当前去除边框的有效区域
- (NSRect)getValidRect
{
    NSRect resultRect = [self frame];
    //debug_print("validrect:%f,%f,%f,%f",rcTmp.origin.x,rcTmp.origin.y,rcTmp.size.width,rcTmp.size.height);
    resultRect.origin.x = resultRect.origin.x + kValidOffset;
    resultRect.origin.y = resultRect.origin.y + kValidOffset;
    resultRect.size.width = resultRect.size.width - kValidOffset*2;
    resultRect.size.height = resultRect.size.height - kValidOffset*2;
    return resultRect;
}

///< 设置有效区域
- (void)setValidRect:(NSRect) inputRect
{
    NSRect resultRect;
    resultRect.origin.x = inputRect.origin.x - kValidOffset;
    resultRect.origin.y = inputRect.origin.y - kValidOffset;
    resultRect.size.width = inputRect.size.width + kValidOffset*2;
    resultRect.size.height = inputRect.size.height + kValidOffset*2;
    [self setFrame:resultRect display:YES animate:NO];
}

#pragma mark - get & set

- (EnumWindows *)enumWindows {
    if (_enumWindows == nil) {
        _enumWindows = [[EnumWindows alloc] init];
    }
    return _enumWindows;
}

@end
