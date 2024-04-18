//
//  utility.h
//  ScreenRecorder
//
//  Created by tbago on 2020/4/29.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

BOOL createDirectoryIfNotExists(NSString *directoryPath, NSError **error);

/**
*  Convert NSDate to special format NSString
*
*  @param date   input NSDate value
*  @param format NSString date format. ext:yyyy-MM-dd HH:mm:ss
*
*  @return NSString formate date value
*/
NSString* convertNSDateToFormatNSString(NSDate *date, NSString *format);

NS_ASSUME_NONNULL_END
