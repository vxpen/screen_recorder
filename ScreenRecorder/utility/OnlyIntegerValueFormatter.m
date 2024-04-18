//
//  OnlyIntegerValueFormatter.m
//  ScreenRecorder
//
//  Created by tbago on 2020/5/8.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "OnlyIntegerValueFormatter.h"

@implementation OnlyIntegerValueFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString
            newEditingString:(NSString**)newString
            errorDescription:(NSString**)error
{
    if([partialString length] == 0) {
        return YES;
    }

    NSScanner* scanner = [NSScanner scannerWithString:partialString];

    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        return NO;
    }

    return YES;
}

@end
