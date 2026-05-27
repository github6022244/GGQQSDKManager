//
//  GGQQSDKTestDetailViewController.m
//  GGQQSDKManager
//
//  Created by GG on 2026/05/27.
//  Copyright (c) 2026 GG. All rights reserved.
//

#import "GGQQSDKTestDetailViewController.h"
#import "GGQQSDKManager.h"

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@interface GGQQSDKTestDetailViewController ()

@property (nonatomic, strong) UITextView *resultTextView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GGQQSDKTestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];
    
    CGFloat yOffset = 20;
    CGFloat margin = 20;
    CGFloat buttonWidth = self.view.frame.size.width - margin * 2;
    CGFloat buttonHeight = 50;
    
    switch (self.testType) {
        case GGQQTestTypeAuth:
            [self setupAuthTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeGetUserInfo:
            [self setupGetUserInfoTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeShareText:
            [self setupShareTextTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeShareImage:
            [self setupShareImageTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeShareImages:
            [self setupShareImagesTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeShareWebPage:
            [self setupShareWebPageTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeShareAudio:
            [self setupShareAudioTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeShareVideo:
            [self setupShareVideoTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeShareMiniProgram:
            [self setupShareMiniProgramTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeLaunchMiniProgram:
            [self setupLaunchMiniProgramTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeSetAvatar:
            [self setupSetAvatarTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeClearToken:
            [self setupClearTokenTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeLogout:
            [self setupLogoutTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
        case GGQQTestTypeCheckInstalled:
            [self setupCheckInstalledTestWithYOffset:&yOffset margin:margin buttonWidth:buttonWidth buttonHeight:buttonHeight];
            break;
    }
    
    // 添加结果显示区域
    yOffset += 20;
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, yOffset, buttonWidth, 30)];
    resultLabel.text = @"测试结果:";
    resultLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.scrollView addSubview:resultLabel];
    yOffset += 40;
    
    self.resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(margin, yOffset, buttonWidth, 200)];
    self.resultTextView.editable = NO;
    self.resultTextView.font = [UIFont systemFontOfSize:14];
    self.resultTextView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.resultTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.resultTextView.layer.borderWidth = 1.0;
    self.resultTextView.layer.cornerRadius = 5.0;
    [self.scrollView addSubview:self.resultTextView];
    
    yOffset += 220;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yOffset);
}

#pragma mark - Setup Methods

- (void)setupAuthTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"QQ授权登录";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 60)];
    descLabel.numberOfLines = 0;
    descLabel.text = @"点击按钮开始QQ授权登录测试\n需要在项目中配置AppID和UniversalLink";
    descLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:descLabel];
    *yOffset += 80;
    
    UIButton *btn = [self createButtonWithTitle:@"开始授权" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor blueColor] action:@selector(handleAuth)];
    [btn setEnabled:[GGQQSDKManager isQQInstalled] || [GGQQSDKManager isTIMInstalled]];
    [self.scrollView addSubview:btn];
    *yOffset += buttonHeight + 20;
}

- (void)setupGetUserInfoTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"获取用户信息";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 60)];
    descLabel.numberOfLines = 0;
    descLabel.text = @"点击按钮获取用户信息\n需要先完成QQ授权";
    descLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:descLabel];
    *yOffset += 80;
    
    UIButton *btn = [self createButtonWithTitle:@"获取用户信息" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor greenColor] action:@selector(handleGetUserInfo)];
//    btn.enabled = [[GGQQSDKManager sharedManager] isSessionValid];
    [self.scrollView addSubview:btn];
    *yOffset += buttonHeight + 20;
}

- (void)setupShareTextTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"分享文本";
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"输入要分享的文本";
    textField.text = @"这是测试分享的文本内容";
    textField.tag = 100;
    [self.scrollView addSubview:textField];
    *yOffset += 60;
    
    UIButton *btnQQ = [self createButtonWithTitle:@"分享到QQ" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor blueColor] action:@selector(handleShareTextToQQ)];
//    btnQQ.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQQ];
    *yOffset += buttonHeight + 20;
}

- (void)setupShareImageTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"分享单张图片";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
    descLabel.numberOfLines = 0;
    descLabel.text = @"点击按钮分享图片到QQ";
    descLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:descLabel];
    *yOffset += 60;
    
    UIButton *btnQQ = [self createButtonWithTitle:@"分享图片到QQ" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor blueColor] action:@selector(handleShareImageToQQ)];
//    btnQQ.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQQ];
    *yOffset += buttonHeight + 20;
    
    UIButton *btnQZone = [self createButtonWithTitle:@"分享图片到QQ空间" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor orangeColor] action:@selector(handleShareImageToQZone)];
//    btnQZone.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQZone];
    *yOffset += buttonHeight + 20;
}

- (void)setupShareImagesTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"分享多张图片";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 60)];
    descLabel.numberOfLines = 0;
    descLabel.text = @"点击按钮分享多张图片到QQ空间\n（QQ空间专属接口）";
    descLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:descLabel];
    *yOffset += 80;
    
    UIButton *btnQZone = [self createButtonWithTitle:@"分享多张图片到QQ空间" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor orangeColor] action:@selector(handleShareImagesToQZone)];
//    btnQZone.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQZone];
    *yOffset += buttonHeight + 20;
}

- (void)setupShareWebPageTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"分享网页";
    
    NSArray *placeholders = @[@"输入网页链接", @"输入标题", @"输入描述"];
    NSArray *defaultValues = @[@"https://www.qq.com", @"QQ官网", @"腾讯QQ官方网站"];
    NSArray *tags = @[@200, @201, @202];
    
    for (NSInteger i = 0; i < placeholders.count; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = placeholders[i];
        textField.text = defaultValues[i];
        textField.tag = [tags[i] integerValue];
        [self.scrollView addSubview:textField];
        *yOffset += 50;
    }
    
    UIButton *btnQQ = [self createButtonWithTitle:@"分享网页到QQ" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor blueColor] action:@selector(handleShareWebPageToQQ)];
//    btnQQ.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQQ];
    *yOffset += buttonHeight + 20;
    
    UIButton *btnQZone = [self createButtonWithTitle:@"分享网页到QQ空间" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor orangeColor] action:@selector(handleShareWebPageToQZone)];
//    btnQZone.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQZone];
    *yOffset += buttonHeight + 20;
}

- (void)setupShareAudioTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"分享音频";
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"输入音频链接";
    textField.text = @"https://www.example.com/audio.mp3";
    textField.tag = 300;
    [self.scrollView addSubview:textField];
    *yOffset += 60;
    
    UIButton *btnQQ = [self createButtonWithTitle:@"分享音频到QQ" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor purpleColor] action:@selector(handleShareAudioToQQ)];
//    btnQQ.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQQ];
    *yOffset += buttonHeight + 20;
}

- (void)setupShareVideoTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"分享视频";
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"输入视频链接";
    textField.text = @"https://www.example.com/video.mp4";
    textField.tag = 400;
    [self.scrollView addSubview:textField];
    *yOffset += 60;
    
    UIButton *btnQQ = [self createButtonWithTitle:@"分享视频到QQ" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor redColor] action:@selector(handleShareVideoToQQ)];
//    btnQQ.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQQ];
    *yOffset += buttonHeight + 20;
}

- (void)setupShareMiniProgramTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"分享小程序";
    
    NSArray *placeholders = @[@"小程序AppID", @"小程序路径(可选)", @"网页链接(必填)", @"标题", @"描述"];
    NSArray *defaultValues = @[@"wx1234567890123456", @"pages/index/index", @"https://www.qq.com", @"测试小程序", @"这是一个测试小程序"];
    NSArray *tags = @[@500, @501, @502, @503, @504];
    
    for (NSInteger i = 0; i < placeholders.count; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = placeholders[i];
        textField.text = defaultValues[i];
        textField.tag = [tags[i] integerValue];
        [self.scrollView addSubview:textField];
        *yOffset += 50;
    }
    
    UIButton *btnQQ = [self createButtonWithTitle:@"分享小程序到QQ" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor blueColor] action:@selector(handleShareMiniProgramToQQ)];
//    btnQQ.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btnQQ];
    *yOffset += buttonHeight + 20;
    
    UIButton *btnTIM = [self createButtonWithTitle:@"分享小程序到TIM" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor cyanColor] action:@selector(handleShareMiniProgramToTIM)];
//    btnTIM.enabled = [GGQQSDKManager isTIMInstalled];
    [self.scrollView addSubview:btnTIM];
    *yOffset += buttonHeight + 20;
}

- (void)setupLaunchMiniProgramTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"唤起小程序";
    
    UITextField *appIDField = [[UITextField alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
    appIDField.borderStyle = UITextBorderStyleRoundedRect;
    appIDField.placeholder = @"小程序AppID";
    appIDField.text = @"wx1234567890123456";
    appIDField.tag = 600;
    [self.scrollView addSubview:appIDField];
    *yOffset += 50;
    
    UITextField *pathField = [[UITextField alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
    pathField.borderStyle = UITextBorderStyleRoundedRect;
    pathField.placeholder = @"小程序路径(可选)";
    pathField.text = @"pages/index/index";
    pathField.tag = 601;
    [self.scrollView addSubview:pathField];
    *yOffset += 60;
    
    UIButton *btn = [self createButtonWithTitle:@"唤起小程序" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor greenColor] action:@selector(handleLaunchMiniProgram)];
//    btn.enabled = [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btn];
    *yOffset += buttonHeight + 20;
}

- (void)setupSetAvatarTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"设置QQ头像";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 60)];
    descLabel.numberOfLines = 0;
    descLabel.text = @"点击按钮设置QQ头像\n需要先完成QQ授权";
    descLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:descLabel];
    *yOffset += 80;
    
    UIButton *btn = [self createButtonWithTitle:@"设置头像" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor orangeColor] action:@selector(handleSetAvatar)];
//    btn.enabled = [[GGQQSDKManager sharedManager] isSessionValid] && [GGQQSDKManager isQQInstalled];
    [self.scrollView addSubview:btn];
    *yOffset += buttonHeight + 20;
}

- (void)setupClearTokenTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"清除缓存Token";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 60)];
    descLabel.numberOfLines = 0;
    descLabel.text = @"点击按钮清除本地缓存的Token\n不会触发退出登录";
    descLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:descLabel];
    *yOffset += 80;
    
    UIButton *btn = [self createButtonWithTitle:@"清除Token" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor grayColor] action:@selector(handleClearToken)];
    [self.scrollView addSubview:btn];
    *yOffset += buttonHeight + 20;
}

- (void)setupLogoutTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"退出登录";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, *yOffset, buttonWidth, 40)];
    descLabel.numberOfLines = 0;
    descLabel.text = @"点击按钮退出QQ登录";
    descLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:descLabel];
    *yOffset += 60;
    
    UIButton *btn = [self createButtonWithTitle:@"退出登录" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor redColor] action:@selector(handleLogout)];
//    btn.enabled = [[GGQQSDKManager sharedManager] isSessionValid];
    [self.scrollView addSubview:btn];
    *yOffset += buttonHeight + 20;
}

- (void)setupCheckInstalledTestWithYOffset:(CGFloat *)yOffset margin:(CGFloat)margin buttonWidth:(CGFloat)buttonWidth buttonHeight:(CGFloat)buttonHeight {
    self.title = @"检测安装状态";
    
    UIButton *btnQQ = [self createButtonWithTitle:@"检测QQ是否安装" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor blueColor] action:@selector(handleCheckQQInstalled)];
    [self.scrollView addSubview:btnQQ];
    *yOffset += buttonHeight + 20;
    
    UIButton *btnTIM = [self createButtonWithTitle:@"检测TIM是否安装" frame:CGRectMake(margin, *yOffset, buttonWidth, buttonHeight) backgroundColor:[UIColor cyanColor] action:@selector(handleCheckTIMInstalled)];
    [self.scrollView addSubview:btnTIM];
    *yOffset += buttonHeight + 20;
}

#pragma mark - Helper Methods

- (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = color;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    btn.layer.cornerRadius = 5.0;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)showResult:(NSString *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultTextView.text = result;
    });
}

- (NSString *)getTextFromTag:(NSInteger)tag defaultValue:(NSString *)defaultValue {
    UITextField *textField = (UITextField *)[self.scrollView viewWithTag:tag];
    return textField.text.length > 0 ? textField.text : defaultValue;
}

#pragma mark - Test Actions

- (void)handleAuth {
    NSLog(@"开始QQ授权测试");
    [self showResult:@"正在进行QQ授权登录..."];
    
    [[GGQQSDKManager sharedManager] authWithCompletion:^(BOOL success, GGQQUserInfo *userInfo, GGQQError *error) {
        if (success && userInfo) {
            [self showResult:[NSString stringWithFormat:@"授权成功！\n\n用户信息:\nOpenID: %@\n昵称: %@\n性别: %ld\n省份: %@\n城市: %@", 
                              userInfo.openId, userInfo.nickName, (long)userInfo.sex, userInfo.province, userInfo.city]];
        } else {
            [self showResult:[NSString stringWithFormat:@"授权失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleGetUserInfo {
    NSLog(@"获取用户信息测试");
    [self showResult:@"正在获取用户信息..."];
    
    [[GGQQSDKManager sharedManager] getUserInfoWithCompletion:^(BOOL success, GGQQUserInfo *userInfo, GGQQError *error) {
        if (success && userInfo) {
            [self showResult:[NSString stringWithFormat:@"获取成功！\n\n用户信息:\nOpenID: %@\nUnionID: %@\n昵称: %@\n性别: %ld\n省份: %@\n城市: %@\n头像: %@", 
                              userInfo.openId, userInfo.unionId, userInfo.nickName, (long)userInfo.sex, 
                              userInfo.province, userInfo.city, userInfo.figureURL]];
        } else {
            [self showResult:[NSString stringWithFormat:@"获取失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareTextToQQ {
    NSString *text = [self getTextFromTag:100 defaultValue:@"测试分享文本"];
    NSLog(@"分享文本到QQ: %@", text);
    [self showResult:@"正在分享文本..."];
    
    [[GGQQSDKManager sharedManager] shareText:text shareType:GGQQShareTypeQQ destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareImageToQQ {
    NSLog(@"分享图片到QQ");
    [self showResult:@"正在分享图片..."];
    
    UIImage *image = [UIImage imageNamed:@"test_image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        // 使用默认图片
        imageData = UIImagePNGRepresentation([UIImage imageWithColor:[UIColor blueColor] size:CGSizeMake(100, 100)]);
    }
    
    [[GGQQSDKManager sharedManager] shareImage:imageData title:@"测试图片" shareType:GGQQShareTypeQQ destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareImageToQZone {
    NSLog(@"分享图片到QQ空间");
    [self showResult:@"正在分享图片到QQ空间..."];
    
    UIImage *image = [UIImage imageNamed:@"test_image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        imageData = UIImagePNGRepresentation([UIImage imageWithColor:[UIColor blueColor] size:CGSizeMake(100, 100)]);
    }
    
    [[GGQQSDKManager sharedManager] shareImage:imageData title:@"测试图片" shareType:GGQQShareTypeQZone destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareImagesToQZone {
    NSLog(@"分享多张图片到QQ空间");
    [self showResult:@"正在分享多张图片到QQ空间..."];
    
    NSMutableArray *imageDataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithHue:i/3.0 saturation:0.8 brightness:0.8 alpha:1.0] size:CGSizeMake(100, 100)];
        NSData *imageData = UIImagePNGRepresentation(image);
        if (imageData) {
            [imageDataArray addObject:imageData];
        }
    }
    
    [[GGQQSDKManager sharedManager] shareImages:imageDataArray title:@"测试多张图片" completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareWebPageToQQ {
    NSString *url = [self getTextFromTag:200 defaultValue:@"https://www.qq.com"];
    NSString *title = [self getTextFromTag:201 defaultValue:@"QQ官网"];
    NSString *desc = [self getTextFromTag:202 defaultValue:@"腾讯QQ官方网站"];
    
    NSLog(@"分享网页到QQ: %@", url);
    [self showResult:@"正在分享网页..."];
    
    [[GGQQSDKManager sharedManager] shareWebPage:url title:title description:desc previewImageURL:nil shareType:GGQQShareTypeQQ destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareWebPageToQZone {
    NSString *url = [self getTextFromTag:200 defaultValue:@"https://www.qq.com"];
    NSString *title = [self getTextFromTag:201 defaultValue:@"QQ官网"];
    NSString *desc = [self getTextFromTag:202 defaultValue:@"腾讯QQ官方网站"];
    
    NSLog(@"分享网页到QQ空间: %@", url);
    [self showResult:@"正在分享网页到QQ空间..."];
    
    [[GGQQSDKManager sharedManager] shareWebPage:url title:title description:desc previewImageURL:nil shareType:GGQQShareTypeQZone destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareAudioToQQ {
    NSString *url = [self getTextFromTag:300 defaultValue:@"https://www.example.com/audio.mp3"];
    NSLog(@"分享音频到QQ: %@", url);
    [self showResult:@"正在分享音频..."];
    
    [[GGQQSDKManager sharedManager] shareAudio:url title:@"测试音频" description:@"这是一个测试音频" previewImageData:nil destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareVideoToQQ {
    NSString *url = [self getTextFromTag:400 defaultValue:@"https://www.example.com/video.mp4"];
    NSLog(@"分享视频到QQ: %@", url);
    [self showResult:@"正在分享视频..."];
    
    [[GGQQSDKManager sharedManager] shareVideo:url title:@"测试视频" description:@"这是一个测试视频" previewImageData:nil destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareMiniProgramToQQ {
    NSString *appID = [self getTextFromTag:500 defaultValue:@""];
    NSString *path = [self getTextFromTag:501 defaultValue:@""];
    NSString *webpageUrl = [self getTextFromTag:502 defaultValue:@""];
    NSString *title = [self getTextFromTag:503 defaultValue:@""];
    NSString *desc = [self getTextFromTag:504 defaultValue:@""];
    
    if (!appID.length) {
        [self showResult:@"错误：小程序AppID不能为空"];
        return;
    }
    if (!webpageUrl.length) {
        [self showResult:@"错误：网页链接不能为空"];
        return;
    }
    
    NSLog(@"分享小程序到QQ: %@", appID);
    [self showResult:@"正在分享小程序..."];
    
    [[GGQQSDKManager sharedManager] shareMiniProgram:appID miniPath:path webpageUrl:webpageUrl title:title description:desc previewImageData:nil miniProgramType:GGQQMiniProgramTypeOnline destType:GGQQShareDestTypeQQ completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleShareMiniProgramToTIM {
    NSString *appID = [self getTextFromTag:500 defaultValue:@""];
    NSString *path = [self getTextFromTag:501 defaultValue:@""];
    NSString *webpageUrl = [self getTextFromTag:502 defaultValue:@""];
    NSString *title = [self getTextFromTag:503 defaultValue:@""];
    NSString *desc = [self getTextFromTag:504 defaultValue:@""];
    
    if (!appID.length) {
        [self showResult:@"错误：小程序AppID不能为空"];
        return;
    }
    
    NSLog(@"分享小程序到TIM: %@", appID);
    [self showResult:@"正在分享小程序到TIM..."];
    
    [[GGQQSDKManager sharedManager] shareMiniProgram:appID miniPath:path webpageUrl:webpageUrl title:title description:desc previewImageData:nil miniProgramType:GGQQMiniProgramTypeOnline destType:GGQQShareDestTypeTIM completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"分享成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"分享失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleLaunchMiniProgram {
    NSString *appID = [self getTextFromTag:600 defaultValue:@""];
    NSString *path = [self getTextFromTag:601 defaultValue:@""];
    
    if (!appID.length) {
        [self showResult:@"错误：小程序AppID不能为空"];
        return;
    }
    
    NSLog(@"唤起小程序: %@", appID);
    [self showResult:@"正在唤起小程序..."];
    
    [[GGQQSDKManager sharedManager] launchMiniProgram:appID miniPath:path miniProgramType:GGQQMiniProgramTypeOnline completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"唤起成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"唤起失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleSetAvatar {
    NSLog(@"设置QQ头像");
    [self showResult:@"正在设置QQ头像..."];
    
    UIImage *avatarImage = [UIImage imageWithColor:[UIColor blueColor] size:CGSizeMake(100, 100)];
    NSData *imageData = UIImagePNGRepresentation(avatarImage);
    
    [[GGQQSDKManager sharedManager] setQQAvatarWithImageData:imageData completion:^(BOOL success, GGQQError *error) {
        if (success) {
            [self showResult:@"设置成功！"];
        } else {
            [self showResult:[NSString stringWithFormat:@"设置失败: %@", error ? error.message : @"未知错误"]];
        }
    }];
}

- (void)handleClearToken {
    NSLog(@"清除缓存Token");
    [self showResult:@"正在清除缓存Token..."];
    
    [[GGQQSDKManager sharedManager] clearCachedToken];
    [self showResult:@"清除成功！"];
}

- (void)handleLogout {
    NSLog(@"退出登录");
    [self showResult:@"正在退出登录..."];
    
    [[GGQQSDKManager sharedManager] logout];
    [self showResult:@"退出成功！"];
}

- (void)handleCheckQQInstalled {
    BOOL installed = [GGQQSDKManager isQQInstalled];
    NSLog(@"检测QQ安装状态: %@", installed ? @"已安装" : @"未安装");
    [self showResult:[NSString stringWithFormat:@"QQ安装状态: %@", installed ? @"已安装" : @"未安装"]];
}

- (void)handleCheckTIMInstalled {
    BOOL installed = [GGQQSDKManager isTIMInstalled];
    NSLog(@"检测TIM安装状态: %@", installed ? @"已安装" : @"未安装");
    [self showResult:[NSString stringWithFormat:@"TIM安装状态: %@", installed ? @"已安装" : @"未安装"]];
}

@end

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
