//
//  GGQQSDKTestDetailViewController.h
//  GGQQSDKManager
//
//  Created by GG on 2026/05/27.
//  Copyright (c) 2026 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GGQQTestType) {
    GGQQTestTypeAuth,
    GGQQTestTypeGetUserInfo,
    GGQQTestTypeShareText,
    GGQQTestTypeShareImage,
    GGQQTestTypeShareImages,
    GGQQTestTypeShareWebPage,
    GGQQTestTypeShareAudio,
    GGQQTestTypeShareVideo,
    GGQQTestTypeShareMiniProgram,
    GGQQTestTypeLaunchMiniProgram,
    GGQQTestTypeSetAvatar,
    GGQQTestTypeClearToken,
    GGQQTestTypeLogout,
    GGQQTestTypeCheckInstalled,
};

@interface GGQQSDKTestDetailViewController : UIViewController

@property (nonatomic, assign) GGQQTestType testType;

@end
