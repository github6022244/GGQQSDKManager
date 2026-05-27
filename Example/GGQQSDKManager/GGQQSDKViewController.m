//
//  GGQQSDKViewController.m
//  GGQQSDKManager
//
//  Created by github6022244 on 05/27/2026.
//  Copyright (c) 2026 github6022244. All rights reserved.
//

#import "GGQQSDKViewController.h"
#import "GGQQSDKTestDetailViewController.h"

typedef NS_ENUM(NSInteger, TestType) {
    TestTypeAuth,
    TestTypeGetUserInfo,
    TestTypeShareText,
    TestTypeShareImage,
    TestTypeShareImages,
    TestTypeShareWebPage,
    TestTypeShareAudio,
    TestTypeShareVideo,
    TestTypeShareMiniProgram,
    TestTypeLaunchMiniProgram,
    TestTypeSetAvatar,
    TestTypeClearToken,
    TestTypeLogout,
    TestTypeCheckInstalled,
};

@interface GGQQSDKViewController ()

@property (nonatomic, strong) NSArray *testItems;

@end

@implementation GGQQSDKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"QQ SDK 测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化 table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self setupTestItems];
}

- (void)setupTestItems {
    self.testItems = @[
        // 授权相关
        @{@"title": @"QQ授权登录", @"type": @(TestTypeAuth)},
        @{@"title": @"获取用户信息", @"type": @(TestTypeGetUserInfo)},
        // 分享相关
        @{@"title": @"分享文本", @"type": @(TestTypeShareText)},
        @{@"title": @"分享单张图片", @"type": @(TestTypeShareImage)},
        @{@"title": @"分享多张图片", @"type": @(TestTypeShareImages)},
        @{@"title": @"分享网页", @"type": @(TestTypeShareWebPage)},
        @{@"title": @"分享音频", @"type": @(TestTypeShareAudio)},
        @{@"title": @"分享视频", @"type": @(TestTypeShareVideo)},
        // 小程序相关
        @{@"title": @"分享小程序", @"type": @(TestTypeShareMiniProgram)},
        @{@"title": @"唤起小程序", @"type": @(TestTypeLaunchMiniProgram)},
        // 其他功能
        @{@"title": @"设置QQ头像", @"type": @(TestTypeSetAvatar)},
        @{@"title": @"清除缓存Token", @"type": @(TestTypeClearToken)},
        @{@"title": @"退出登录", @"type": @(TestTypeLogout)},
        @{@"title": @"检测安装状态", @"type": @(TestTypeCheckInstalled)},
    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *item = self.testItems[indexPath.row];
    cell.textLabel.text = item[@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.testItems[indexPath.row];
    TestType type = [item[@"type"] integerValue];
    
    GGQQSDKTestDetailViewController *detailVC = [[GGQQSDKTestDetailViewController alloc] init];
    detailVC.testType = (GGQQTestType)type;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
