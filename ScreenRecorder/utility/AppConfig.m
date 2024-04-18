//
//  AppConfig.m
//  video_converter
//
//  Created by tbago on 2020/3/31.
//  Copyright © 2020 tbago. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

+ (NSString *)getBundleIdentifier {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [infoDict objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}

+ (NSString *)getProductName {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* productName = [infoDict objectForKey:@"CFBundleName"];
    return productName;
}

+ (NSString *)getProductVersion {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* bundleVersion = infoDict[@"CFBundleShortVersionString"];
    return bundleVersion;
}

+ (NSString *)getBuildVersion {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
     NSString* buildVersion = infoDict[@"CFBundleVersion"];
     return buildVersion;
}

+ (NSString *)getCopyrightInfo {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* copyright = [infoDict objectForKey:@"NSHumanReadableCopyright"];
    return copyright;
}

+ (NSString *)getLogoIconName {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* iconFile = [infoDict objectForKey:@"CFBundleIconFile"];
    return iconFile;
}

+ (NSString *)getSupportEmail {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* supportEmail = [infoDict objectForKey:@"SupportEmail"];
    return supportEmail;
}

+ (NSString *)getSupportWebsite {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* supportWebsite = [infoDict objectForKey:@"SupportWebsite"];
    return supportWebsite;
}
@end
