//
//  EnumWindows.h
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnumWindows : NSObject

///更新窗口列表
- (void)updateWindowsList;

/*!
 * @brief 判断ptMouse所在的窗口，并返回窗口的位置和大小
 * @param mousePosition 需要判断的坐标
 * @param windowPosition [out] 窗口的区域
 * @return BOOL YES    ptMouse所在位置存在窗口，rcWindow包含窗口数据
                 NO   ptMouse所在位置无窗口，rcWindow参数为空
*/
- (BOOL)getCurWindow:(NSPoint)mousePosition windowPos:(NSRect *) windowPosition;

@end

NS_ASSUME_NONNULL_END
