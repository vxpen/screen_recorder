//
//  EnumWindows.m
//  ScreenRecorder
//
//  Created by tbago on 2020/4/28.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "EnumWindows.h"
#import <AppKit/AppKit.h>

@interface EnumWindows()
{
    CGWindowListOption    windowListOptions;
}
@property (strong, nonatomic) NSArray           *filerWindowArray;
@property (strong, nonatomic) NSMutableArray    *validWindowArray;  ///< 有效的窗口列表

@end

typedef struct
{
    // Where to add window information

    NSMutableArray * outputArray;
    // Tracks the index of the window when first inserted
    // so that we can always request that the windows be drawn in order.
    int order;
} WindowListApplierData;

NSString *kAppNameKey           = @"applicationName";    // Application Name
NSString *kWindowOriginXKey     = @"windowOriginX";      // Window Origin X as a string
NSString *kWindowOriginYKey     = @"windowOriginY";      // Window Origin Y as a string
NSString *kWindowSizeWKey       = @"windowSizeW";        // Window Size width as a string
NSString *kWindowSizeHKey       = @"windowSizeH";        // Window Size height as a string
NSString *kWindowOrderKey       = @"windowOrder";        // The overall front-to-back ordering of the windows as returned by the window server

NS_INLINE uint32_t changeBits(uint32_t currentBits, uint32_t flagsToChange, BOOL setFlags)
{
    if(setFlags) {    // Set Bits
        return currentBits | flagsToChange;
    }
    else {    // Clear Bits
        return currentBits & ~flagsToChange;
    }
}

void windowListApplierFunction(const void *inputDictionary, void *context)
{
    NSDictionary *entry = (__bridge NSDictionary *)inputDictionary;
    WindowListApplierData *data = (WindowListApplierData*)context;

    // The flags that we pass to CGWindowListCopyWindowInfo will automatically filter out most undesirable windows.
    // However, it is possible that we will get back a window that we cannot read from, so we'll filter those out manually.
    int sharingState = [[entry objectForKey:(id)kCGWindowSharingState] intValue];
    if(sharingState != kCGWindowSharingNone) {
        NSMutableDictionary *outputEntry = [NSMutableDictionary dictionary];

        // Grab the application name, but since it's optional we need to check before we can use it.
        NSString *applicationName = [entry objectForKey:(id)kCGWindowOwnerName];
        if(applicationName != nil) {
            // PID is required so we assume it's present.
            NSString *nameAndPID = [NSString stringWithFormat:@"%@", applicationName];
            [outputEntry setObject:nameAndPID forKey:kAppNameKey];
        }
        else {
            // The application name was not provided, so we use a fake application name to designate this.
            NSString *nameAndPID = [NSString stringWithFormat:@"((unknown))"];
            [outputEntry setObject:nameAndPID forKey:kAppNameKey];
        }

        // Grab the Window Bounds, it's a dictionary in the array, but we want to display it as a string
        CGRect bounds;
        CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)[entry objectForKey:(id)kCGWindowBounds], &bounds);

        bounds.origin.y = NSScreen.mainScreen.frame.size.height - bounds.origin.y - bounds.size.height;
        NSString *originXString = [NSString stringWithFormat:@"%.0f", bounds.origin.x];
        [outputEntry setObject:originXString forKey:kWindowOriginXKey];
        NSString *originYString = [NSString stringWithFormat:@"%.0f", bounds.origin.y];
        [outputEntry setObject:originYString forKey:kWindowOriginYKey];

        NSString *sizeWString = [NSString stringWithFormat:@"%.0f", bounds.size.width];
        [outputEntry setObject:sizeWString forKey:kWindowSizeWKey];
        NSString *sizeHString = [NSString stringWithFormat:@"%.0f", bounds.size.height];
        [outputEntry setObject:sizeHString forKey:kWindowSizeHKey];

        // Finally, we are passed the windows in order from front to back by the window server
        // Should the user sort the window list we want to retain that order so that screen shots
        // look correct no matter what selection they make, or what order the items are in. We do this
        // by maintaining a window order key that we'll apply later.
        [outputEntry setObject:[NSNumber numberWithInt:data->order] forKey:kWindowOrderKey];

        data->order++;
        [data->outputArray addObject:outputEntry];
    }
}

@implementation EnumWindows

#pragma mark - init method

- (instancetype)init {
    self = [super init];
    if (self) {
        windowListOptions = kCGWindowListOptionAll;
        windowListOptions = changeBits(windowListOptions, kCGWindowListOptionOnScreenOnly, true);
        windowListOptions = changeBits(windowListOptions, kCGWindowListExcludeDesktopElements, true);

        _filerWindowArray = @[@"SystemUIServer", @"Dock", @"Window Server", @"ScreenRecorder"];
    }
    return self;
}
#pragma mark - public method

- (void)updateWindowsList {
    [self.validWindowArray removeAllObjects];
    // Ask the window server for the list of windows.
    CFArrayRef windowArray = CGWindowListCopyWindowInfo(windowListOptions, kCGNullWindowID);

    // Copy the returned list, further pruned, to another list. This also adds some bookkeeping
    // information to the list as well as
    WindowListApplierData data = {_validWindowArray, 0};
    CFArrayApplyFunction(windowArray, CFRangeMake(0, CFArrayGetCount(windowArray)), &windowListApplierFunction, &data);

    CFRelease(windowArray);
}

- (BOOL)getCurWindow:(NSPoint)mousePosition windowPos:(NSRect *) windowPosition {
    if(windowPosition == NULL) {
        return NO;
    }
    memset(windowPosition, 0, sizeof(NSRect));
    if (self.validWindowArray.count == 0) {
        [self updateWindowsList];
    }

    NSAssert(self.validWindowArray.count > 0, @"No window found");
    NSInteger count = self.validWindowArray.count ;
    if(count == 0) {
        [self updateWindowsList];
    }
    for (NSInteger i = 0; i < self.validWindowArray.count; i++)
    {
        NSMutableDictionary *windowInfo;
        windowInfo = [self.validWindowArray objectAtIndex:i];

        NSString *applicationName = [windowInfo objectForKey:kAppNameKey];
//        NSLog(@"app name:%@", applicationName);
        BOOL inFilterArray = NO;
        for(NSString *filterWindowName in self.filerWindowArray)
        {
            if ([filterWindowName isEqualToString:applicationName]) {
                inFilterArray = YES;
                break;
            }
        }
        if (inFilterArray) {
            continue;
        }

        NSRect windowRect = NSMakeRect([[windowInfo objectForKey:kWindowOriginXKey] floatValue],
                                       [[windowInfo objectForKey:kWindowOriginYKey] floatValue],
                                       [[windowInfo objectForKey:kWindowSizeWKey] floatValue],
                                       [[windowInfo objectForKey:kWindowSizeHKey] floatValue]);
        if (NSEqualRects(NSScreen.mainScreen.frame, windowRect)) { ///< 过滤全屏，Dock现在有其他语言了，不好过滤
            continue;
        }
        BOOL inRect = NSPointInRect(mousePosition, windowRect);
        if (inRect){
            windowPosition->origin.x    = windowRect.origin.x;
            windowPosition->origin.y    = windowRect.origin.y;
            windowPosition->size.width  = windowRect.size.width;
            windowPosition->size.height = windowRect.size.height;
            return YES;
        }
    }
    return NO;
}

#pragma mark - get & set

- (NSMutableArray *)validWindowArray {
    if (_validWindowArray == nil) {
        _validWindowArray = [[NSMutableArray alloc] init];
    }
    return _validWindowArray;
}

@end
