//
//  AppConfig.h
//  video_converter
//
//  Created by tbago on 2020/3/31.
//  Copyright © 2020 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppConfig : NSObject

+ (NSString *)getBundleIdentifier;

+ (NSString *)getProductName;

+ (NSString *)getProductVersion;

+ (NSString *)getBuildVersion;

+ (NSString *)getCopyrightInfo;

+ (NSString *)getLogoIconName;

+ (NSString *)getSupportEmail;

+ (NSString *)getSupportWebsite;

@end

NS_ASSUME_NONNULL_END
