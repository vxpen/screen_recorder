//
//  RecorderScreen.h
//  ScreenRecorder
//
//  Created by tbago on 2020/5/7.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecorderScreen : NSObject <AVCaptureFileOutputRecordingDelegate>

- (BOOL)startRecordScreen:(NSURL *)destPath
                framerate:(float) framerate
                 cropRect:(CGRect) cropRect
             captureMouse:(BOOL) captureMouse
       highlighMouseClick:(BOOL) highlightMosueClick
         enableMicrophone:(BOOL) enableMicrophone;

- (void)stopRecordScreen:(BOOL) openInQuickTime;
@end

NS_ASSUME_NONNULL_END
