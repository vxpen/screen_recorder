//
//  utility.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/29.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "utility.h"

BOOL createDirectoryIfNotExists(NSString *directoryPath, NSError **error) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {
        if (isDirectory) {
            return YES;     ///< directory is alreay exits
        }
    }

    BOOL result = [fileManager createDirectoryAtPath:directoryPath
                         withIntermediateDirectories:NO
                                          attributes:nil
                                               error:error];
    return result;
}

NSString* convertNSDateToFormatNSString(NSDate *date, NSString *format) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];

    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
