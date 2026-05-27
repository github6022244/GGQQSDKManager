//
//  GGQQSDKManager.h
//  GGQQSDKManager
//
//  Created by GG on 2024/01/01.
//  Copyright © 2024 GG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/SDKDef.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 分享类型枚举
 */
typedef NS_ENUM(NSUInteger, GGQQShareType) {
    GGQQShareTypeQQ,      ///< 分享到QQ好友/群
    GGQQShareTypeQZone,   ///< 分享到QQ空间
};

/**
 * 分享目标应用类型
 */
typedef NS_ENUM(NSUInteger, GGQQShareDestType) {
    GGQQShareDestTypeQQ,  ///< 分享到QQ
    GGQQShareDestTypeTIM, ///< 分享到TIM
};

/**
 * 授权状态枚举
 */
typedef NS_ENUM(NSUInteger, GGQQAuthState) {
    GGQQAuthStateUnauthorized,  ///< 未授权状态
    GGQQAuthStateAuthorizing,   ///< 授权中
    GGQQAuthStateAuthorized,    ///< 已授权
};

/**
 * 小程序类型枚举
 */
typedef NS_ENUM(NSUInteger, GGQQMiniProgramType) {
    GGQQMiniProgramTypeDevelop = 0,    ///< 开发版
    GGQQMiniProgramTypeTest    = 1,    ///< 测试版
    GGQQMiniProgramTypeOnline  = 3,    ///< 正式版(默认)
    GGQQMiniProgramTypePreview = 4,    ///< 预览版
};

/**
 * 用户信息模型
 * 包含从QQ获取的用户基本信息
 */
@interface GGQQUserInfo : NSObject

@property (nonatomic, copy, nullable) NSString *openId;       ///< 用户的OpenID
@property (nonatomic, copy, nullable) NSString *unionId;      ///< 用户的UnionID（需要配置UnionID机制）
@property (nonatomic, copy, nullable) NSString *nickName;     ///< 用户昵称
@property (nonatomic, assign) NSInteger sex;                  ///< 用户性别（1-男，2-女，0-未知）
@property (nonatomic, copy, nullable) NSString *province;     ///< 用户所在省份
@property (nonatomic, copy, nullable) NSString *city;         ///< 用户所在城市
@property (nonatomic, copy, nullable) NSString *headImgURL;   ///< 用户头像URL(30x30)
@property (nonatomic, copy, nullable) NSString *figureURL;    ///< 用户大图头像URL(100x100)
@property (nonatomic, strong, nullable) NSDictionary *originInfo; ///< 原始返回信息

@end

/**
 * 错误信息模型
 * 用于封装SDK操作过程中的错误信息
 */
@interface GGQQError : NSObject

@property (nonatomic, assign) NSInteger code;             ///< 错误码
@property (nonatomic, copy, nullable) NSString *message;  ///< 错误描述

/**
 * 创建错误对象
 * @param code 错误码
 * @param message 错误描述
 * @return GGQQError实例
 */
+ (instancetype)errorWithCode:(NSInteger)code message:(nullable NSString *)message;

@end

/**
 * 授权回调Block
 * @param success 是否成功
 * @param userInfo 用户信息（成功时返回）
 * @param error 错误信息（失败时返回）
 */
typedef void(^GGQQAuthCompletionBlock)(BOOL success, GGQQUserInfo *_Nullable userInfo, GGQQError *_Nullable error);

/**
 * 分享回调Block
 * @param success 是否成功
 * @param error 错误信息（失败时返回）
 */
typedef void(^GGQQShareCompletionBlock)(BOOL success, GGQQError *_Nullable error);

/**
 * QQ SDK 管理类
 * 封装了QQ授权、分享、小程序等所有功能
 * 采用单例模式，全局唯一实例
 */
@interface GGQQSDKManager : NSObject

/**
 * @name 属性
 */

@property (nonatomic, strong, readonly, nullable) TencentOAuth *oauth;           ///< 腾讯OAuth实例
@property (nonatomic, copy, readonly) NSString *appID;                           ///< 应用ID
@property (nonatomic, copy, readonly, nullable) NSString *universalLink;         ///< Universal Link
@property (nonatomic, assign, readonly) GGQQAuthState authState;                  ///< 当前授权状态
@property (nonatomic, strong, readonly, nullable) GGQQUserInfo *currentUserInfo;  ///< 当前用户信息

/**
 * @name 初始化与配置
 */

/**
 * 获取单例实例
 * @return GGQQSDKManager单例对象
 */
+ (instancetype)sharedManager;

/**
 * 初始化SDK配置
 * 在使用SDK功能前必须调用此方法进行初始化
 * @param appID 应用ID（从腾讯开放平台获取）
 * @param universalLink Universal Link（如需使用Universal Link方式）
 * @param enableUniversalLink 是否启用Universal Link
 */
- (void)setupWithAppID:(NSString *)appID 
        universalLink:(nullable NSString *)universalLink
   enableUniversalLink:(BOOL)enableUniversalLink;

/**
 * 设置用户是否同意授权
 * 在iOS 10+系统中，需要用户同意后才能使用某些功能
 * @param agreed 用户是否同意
 */
+ (void)setUserAgreedAuthorization:(BOOL)agreed;

/**
 * @name URL处理
 */

/**
 * 处理URL Scheme回调
 * 在AppDelegate的application:openURL:options:中调用
 * @param url 回调URL
 * @return 是否成功处理
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 * 处理Universal Link回调
 * 在AppDelegate的continueUserActivity:restorationHandler:中调用
 * @param url Universal Link URL
 * @return 是否成功处理
 */
- (BOOL)handleUniversalLink:(NSURL *)url;

/**
 * 判断是否能处理指定URL
 * @param url 需要判断的URL
 * @return 是否能处理
 */
+ (BOOL)canHandleURL:(NSURL *)url;

/**
 * 判断是否能处理指定Universal Link
 * @param url 需要判断的Universal Link
 * @return 是否能处理
 */
+ (BOOL)canHandleUniversalLink:(NSURL *)url;

/**
 * @name 授权相关
 */

/**
 * 执行授权登录（带权限列表）
 * @param permissions 需要请求的权限列表，如@[@"get_user_info"]
 * @param completion 授权完成回调
 */
- (void)authWithPermissions:(nullable NSArray<NSString *> *)permissions 
                 completion:(GGQQAuthCompletionBlock)completion;

/**
 * 执行授权登录（默认权限）
 * 默认请求get_user_info权限
 * @param completion 授权完成回调
 */
- (void)authWithCompletion:(GGQQAuthCompletionBlock)completion;

/**
 * 检查当前会话是否有效
 * @return 是否有效
 */
- (BOOL)isSessionValid;

/**
 * 获取用户信息
 * 需要先完成授权
 * @param completion 获取完成回调
 */
- (void)getUserInfoWithCompletion:(GGQQAuthCompletionBlock)completion;

/**
 * 退出登录
 * 清除本地Token并标记未授权状态
 */
- (void)logout;

/**
 * 清除缓存的Token
 * 仅清除本地缓存，不会触发退出登录流程
 */
- (void)clearCachedToken;

/**
 * @name 分享功能
 */

/**
 * 分享文本
 * @param text 要分享的文本内容
 * @param shareType 分享类型（QQ好友/QQ空间）
 * @param destType 分享目标（QQ/TIM）
 * @param completion 分享完成回调
 */
- (void)shareText:(NSString *)text 
        shareType:(GGQQShareType)shareType 
        destType:(GGQQShareDestType)destType 
       completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 分享单张图片
 * @param imageData 图片数据
 * @param title 图片标题（可选）
 * @param shareType 分享类型（QQ好友/QQ空间）
 * @param destType 分享目标（QQ/TIM）
 * @param completion 分享完成回调
 */
- (void)shareImage:(NSData *)imageData 
             title:(nullable NSString *)title 
         shareType:(GGQQShareType)shareType 
         destType:(GGQQShareDestType)destType 
        completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 分享多张图片到QQ空间
 * @param imageDataArray 图片数据数组
 * @param title 标题（可选）
 * @param completion 分享完成回调
 */
- (void)shareImages:(NSArray<NSData *> *)imageDataArray 
              title:(nullable NSString *)title 
         completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 分享网页（使用图片数据作为预览图）
 * @param url 网页链接
 * @param title 标题
 * @param description 描述（可选）
 * @param previewImageData 预览图数据（可选）
 * @param shareType 分享类型（QQ好友/QQ空间）
 * @param destType 分享目标（QQ/TIM）
 * @param completion 分享完成回调
 */
- (void)shareWebPage:(NSString *)url 
               title:(NSString *)title 
         description:(nullable NSString *)description 
    previewImageData:(nullable NSData *)previewImageData 
           shareType:(GGQQShareType)shareType 
           destType:(GGQQShareDestType)destType 
          completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 分享网页（使用图片URL作为预览图）
 * @param url 网页链接
 * @param title 标题
 * @param description 描述（可选）
 * @param previewImageURL 预览图URL（可选）
 * @param shareType 分享类型（QQ好友/QQ空间）
 * @param destType 分享目标（QQ/TIM）
 * @param completion 分享完成回调
 */
- (void)shareWebPage:(NSString *)url 
               title:(NSString *)title 
         description:(nullable NSString *)description 
     previewImageURL:(nullable NSString *)previewImageURL 
           shareType:(GGQQShareType)shareType 
           destType:(GGQQShareDestType)destType 
          completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 分享音频
 * @param url 音频链接
 * @param title 标题
 * @param description 描述（可选）
 * @param previewImageData 预览图数据（可选）
 * @param destType 分享目标（QQ/TIM）
 * @param completion 分享完成回调
 */
- (void)shareAudio:(NSString *)url 
             title:(NSString *)title 
       description:(nullable NSString *)description 
  previewImageData:(nullable NSData *)previewImageData 
          destType:(GGQQShareDestType)destType 
         completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 分享视频
 * @param url 视频链接
 * @param title 标题
 * @param description 描述（可选）
 * @param previewImageData 预览图数据（可选）
 * @param destType 分享目标（QQ/TIM）
 * @param completion 分享完成回调
 */
- (void)shareVideo:(NSString *)url 
             title:(NSString *)title 
       description:(nullable NSString *)description 
  previewImageData:(nullable NSData *)previewImageData 
          destType:(GGQQShareDestType)destType 
         completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 分享小程序
 * @param miniAppID 小程序AppID（必填）
 * @param miniPath 小程序路径（可选）
 * @param webpageUrl 兼容低版本的网页链接（必填）
 * @param title 标题
 * @param description 描述（可选）
 * @param previewImageData 预览图数据（可选）
 * @param miniProgramType 小程序类型（开发版/测试版/正式版/预览版）
 * @param destType 分享目标（QQ/TIM）
 * @param completion 分享完成回调
 */
- (void)shareMiniProgram:(NSString *)miniAppID 
                miniPath:(nullable NSString *)miniPath 
             webpageUrl:(NSString *)webpageUrl 
                  title:(NSString *)title 
            description:(nullable NSString *)description 
       previewImageData:(nullable NSData *)previewImageData 
         miniProgramType:(GGQQMiniProgramType)miniProgramType 
                destType:(GGQQShareDestType)destType 
               completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 唤起小程序
 * @param miniAppID 小程序AppID（必填）
 * @param miniPath 小程序路径（可选）
 * @param miniProgramType 小程序类型（开发版/测试版/正式版/预览版）
 * @param completion 操作完成回调
 */
- (void)launchMiniProgram:(NSString *)miniAppID 
                 miniPath:(nullable NSString *)miniPath 
           miniProgramType:(GGQQMiniProgramType)miniProgramType 
              completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * 设置QQ头像
 * 需要先完成授权
 * @param imageData 头像图片数据
 * @param completion 设置完成回调
 */
- (void)setQQAvatarWithImageData:(NSData *)imageData completion:(nullable GGQQShareCompletionBlock)completion;

/**
 * @name 工具方法
 */

/**
 * 检查QQ是否已安装
 * @return 是否已安装
 */
+ (BOOL)isQQInstalled;

/**
 * 检查TIM是否已安装
 * @return 是否已安装
 */
+ (BOOL)isTIMInstalled;

/**
 * 检查是否支持分享功能
 * @return 是否支持
 */
+ (BOOL)isSupportShare;

/**
 * 获取QQ下载链接
 * @return 下载URL字符串
 */
+ (NSString *)qqDownloadURL;

/**
 * 获取SDK版本号
 * @return 版本号字符串
 */
+ (NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END
