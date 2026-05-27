//
//  GGQQSDKManager.m
//  GGQQSDKManager
//
//  Created by GG on 2024/01/01.
//  Copyright © 2024 GG. All rights reserved.
//

#import "GGQQSDKManager.h"

@implementation GGQQUserInfo

@end

@implementation GGQQError

+ (instancetype)errorWithCode:(NSInteger)code message:(nullable NSString *)message {
    GGQQError *error = [[GGQQError alloc] init];
    error.code = code;
    error.message = message;
    return error;
}

@end

@interface GGQQSDKManager () <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy, nullable) NSString *universalLink;
@property (nonatomic, assign) GGQQAuthState authState;
@property (nonatomic, strong) TencentOAuth *oauth;
@property (nonatomic, strong, nullable) GGQQUserInfo *currentUserInfo;
@property (nonatomic, copy, nullable) GGQQAuthCompletionBlock authCompletionBlock;
@property (nonatomic, copy, nullable) GGQQShareCompletionBlock shareCompletionBlock;

// 统一回调方法
- (void)invokeAuthCompletionWithSuccess:(BOOL)success userInfo:(nullable GGQQUserInfo *)userInfo error:(nullable GGQQError *)error;
- (void)invokeShareCompletionWithSuccess:(BOOL)success error:(nullable GGQQError *)error;

@end

@implementation GGQQSDKManager

+ (instancetype)sharedManager {
    static GGQQSDKManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GGQQSDKManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _authState = GGQQAuthStateUnauthorized;
    }
    return self;
}

- (void)setupWithAppID:(NSString *)appID 
        universalLink:(nullable NSString *)universalLink
   enableUniversalLink:(BOOL)enableUniversalLink {
    if (!appID || appID.length == 0) {
        NSLog(@"[GGQQSDKManager] appID cannot be nil or empty");
        return;
    }
    
    self.appID = appID;
    self.universalLink = universalLink;
    
    if (!self.oauth) {
        // 使用单例模式初始化SDK
        self.oauth = [TencentOAuth sharedInstance];
        [self.oauth setupAppId:appID 
            enableUniveralLink:enableUniversalLink 
                 universalLink:universalLink 
                      delegate:self];
    }
}

+ (void)setUserAgreedAuthorization:(BOOL)agreed {
    [TencentOAuth setIsUserAgreedAuthorization:agreed];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (![GGQQSDKManager canHandleURL:url]) {
        return NO;
    }
    
    [QQApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)handleUniversalLink:(NSURL *)url {
    if (![GGQQSDKManager canHandleUniversalLink:url]) {
        return NO;
    }
    
    [QQApiInterface handleOpenUniversallink:url delegate:self];
    return [TencentOAuth HandleUniversalLink:url];
}

+ (BOOL)canHandleUniversalLink:(NSURL *)url {
    return [TencentOAuth CanHandleUniversalLink:url];
}

+ (BOOL)canHandleURL:(NSURL *)url {
    return [TencentOAuth CanHandleOpenURL:url] || [TencentOAuth CanHandleUniversalLink:url];
}

- (void)authWithPermissions:(nullable NSArray<NSString *> *)permissions 
                 completion:(GGQQAuthCompletionBlock)completion {
    if (!self.appID || self.authState == GGQQAuthStateAuthorizing) {
        self.authCompletionBlock = completion;
        [self invokeAuthCompletionWithSuccess:NO userInfo:nil error:[GGQQError errorWithCode:-1 message:@"SDK未初始化或正在授权中"]];
        return;
    }
    
    self.authCompletionBlock = completion;
    self.authState = GGQQAuthStateAuthorizing;
    
    NSArray *defaultPermissions = @[
        kOPEN_PERMISSION_GET_INFO,
        kOPEN_PERMISSION_GET_USER_INFO,
        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO
    ];
    
    NSArray *finalPermissions = permissions ?: defaultPermissions;
    
    [self.oauth authorize:finalPermissions];
}

- (void)authWithCompletion:(GGQQAuthCompletionBlock)completion {
    [self authWithPermissions:nil completion:completion];
}

- (BOOL)isSessionValid {
    return [self.oauth isSessionValid];
}

- (void)getUserInfoWithCompletion:(GGQQAuthCompletionBlock)completion {
    self.authCompletionBlock = completion;
    
    if (![self isSessionValid]) {
        [self invokeAuthCompletionWithSuccess:NO userInfo:nil error:[GGQQError errorWithCode:-2 message:@"未登录或会话已过期"]];
        return;
    }
    BOOL isSuccess = [self.oauth getUserInfo];
    
    if (!isSuccess && completion) {
        [self invokeAuthCompletionWithSuccess:NO userInfo:nil error:[GGQQError errorWithCode:-2 message:@"未登录或会话已过期"]];
    }
}

- (void)logout {
    [self.oauth logout:self];
}

#pragma mark - 统一回调方法

- (void)invokeAuthCompletionWithSuccess:(BOOL)success userInfo:(nullable GGQQUserInfo *)userInfo error:(nullable GGQQError *)error {
    if (self.authCompletionBlock) {
        self.authCompletionBlock(success, userInfo, error);
    }
    self.authCompletionBlock = nil;
}

- (void)invokeShareCompletionWithSuccess:(BOOL)success error:(nullable GGQQError *)error {
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(success, error);
    }
    self.shareCompletionBlock = nil;
}

- (void)clearCachedToken {
    [self.oauth deleteCachedToken];
}

- (void)shareText:(NSString *)text 
        shareType:(GGQQShareType)shareType 
        destType:(GGQQShareDestType)destType 
       completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!text || text.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-3 message:@"文本内容不能为空"]];
        return;
    }
    
    QQApiTextObject *textObj = [[QQApiTextObject alloc] initWithText:text];
    
    // 设置分享目标
    if (destType == GGQQShareDestTypeTIM) {
        textObj.shareDestType = ShareDestTypeTIM;
    } else {
        textObj.shareDestType = ShareDestTypeQQ;
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:textObj];
    
    if (shareType == GGQQShareTypeQZone) {
        // QZone不支持纯文本分享，需要使用写说说方式
        QQApiImageArrayForQZoneObject *qzoneObj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:nil title:text extMap:nil];
        SendMessageToQQReq *qzoneReq = [SendMessageToQQReq reqWithContent:qzoneObj];
        [QQApiInterface SendReqToQZone:qzoneReq];
    } else {
        [QQApiInterface sendReq:req];
    }
}

- (void)shareImage:(NSData *)imageData 
             title:(nullable NSString *)title 
         shareType:(GGQQShareType)shareType 
         destType:(GGQQShareDestType)destType 
        completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!imageData || imageData.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-4 message:@"图片数据不能为空"]];
        return;
    }
    
    if (shareType == GGQQShareTypeQZone) {
        // QZone分享图片使用QQApiImageArrayForQZoneObject
        QQApiImageArrayForQZoneObject *qzoneObj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[imageData] title:title extMap:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:qzoneObj];
        [QQApiInterface SendReqToQZone:req];
    } else {
        QQApiImageObject *imageObj = [[QQApiImageObject alloc] initWithData:imageData previewImageData:imageData title:title description:nil];
        
        if (destType == GGQQShareDestTypeTIM) {
            imageObj.shareDestType = ShareDestTypeTIM;
        } else {
            imageObj.shareDestType = ShareDestTypeQQ;
        }
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObj];
        [QQApiInterface sendReq:req];
    }
}

- (void)shareImages:(NSArray<NSData *> *)imageDataArray 
              title:(nullable NSString *)title 
         completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!imageDataArray || imageDataArray.count == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-4 message:@"图片数据不能为空"]];
        return;
    }
    
    // 分享多张图片到QZone
    QQApiImageArrayForQZoneObject *qzoneObj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:imageDataArray title:title extMap:nil];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:qzoneObj];
    [QQApiInterface SendReqToQZone:req];
}

- (void)shareWebPage:(NSString *)url 
               title:(NSString *)title 
         description:(nullable NSString *)description 
    previewImageData:(nullable NSData *)previewImageData 
           shareType:(GGQQShareType)shareType 
           destType:(GGQQShareDestType)destType 
          completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!url || url.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-5 message:@"链接地址不能为空"]];
        return;
    }
    
    QQApiURLObject *urlObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:url] 
                                                           title:title 
                                                     description:description 
                                                previewImageData:previewImageData 
                                              targetContentType:QQApiURLTargetTypeNews];
    
    if (destType == GGQQShareDestTypeTIM) {
        urlObj.shareDestType = ShareDestTypeTIM;
    } else {
        urlObj.shareDestType = ShareDestTypeQQ;
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObj];
    
    if (shareType == GGQQShareTypeQZone) {
        [QQApiInterface SendReqToQZone:req];
    } else {
        [QQApiInterface sendReq:req];
    }
}

- (void)shareWebPage:(NSString *)url 
               title:(NSString *)title 
         description:(nullable NSString *)description 
     previewImageURL:(nullable NSString *)previewImageURL 
           shareType:(GGQQShareType)shareType 
           destType:(GGQQShareDestType)destType 
          completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!url || url.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-5 message:@"链接地址不能为空"]];
        return;
    }
    
    QQApiURLObject *urlObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:url] 
                                                           title:title 
                                                     description:description 
                                                   previewImageURL:[NSURL URLWithString:previewImageURL] 
                                              targetContentType:QQApiURLTargetTypeNews];
    
    if (destType == GGQQShareDestTypeTIM) {
        urlObj.shareDestType = ShareDestTypeTIM;
    } else {
        urlObj.shareDestType = ShareDestTypeQQ;
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObj];
    
    if (shareType == GGQQShareTypeQZone) {
        [QQApiInterface SendReqToQZone:req];
    } else {
        [QQApiInterface sendReq:req];
    }
}

- (void)shareAudio:(NSString *)url 
             title:(NSString *)title 
       description:(nullable NSString *)description 
  previewImageData:(nullable NSData *)previewImageData 
          destType:(GGQQShareDestType)destType 
         completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!url || url.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-5 message:@"音频链接不能为空"]];
        return;
    }
    
    QQApiAudioObject *audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:url] 
                                                           title:title 
                                                     description:description 
                                                previewImageData:previewImageData];
    
    if (destType == GGQQShareDestTypeTIM) {
        audioObj.shareDestType = ShareDestTypeTIM;
    } else {
        audioObj.shareDestType = ShareDestTypeQQ;
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    [QQApiInterface sendReq:req];
}

- (void)shareVideo:(NSString *)url 
             title:(NSString *)title 
       description:(nullable NSString *)description 
  previewImageData:(nullable NSData *)previewImageData 
          destType:(GGQQShareDestType)destType 
         completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!url || url.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-5 message:@"视频链接不能为空"]];
        return;
    }
    
    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:url] 
                                                           title:title 
                                                     description:description 
                                                previewImageData:previewImageData];
    
    if (destType == GGQQShareDestTypeTIM) {
        videoObj.shareDestType = ShareDestTypeTIM;
    } else {
        videoObj.shareDestType = ShareDestTypeQQ;
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:videoObj];
    [QQApiInterface sendReq:req];
}

/**
 * 分享小程序
 * @param miniAppID 小程序AppID
 * @param miniPath 小程序路径
 * @param webpageUrl 兼容低版本的网页链接
 * @param title 标题
 * @param description 描述
 * @param previewImageData 预览图
 * @param miniProgramType 小程序类型
 * @param destType 分享目标
 * @param completion 回调
 */
- (void)shareMiniProgram:(NSString *)miniAppID 
                miniPath:(nullable NSString *)miniPath 
             webpageUrl:(NSString *)webpageUrl 
                  title:(NSString *)title 
            description:(nullable NSString *)description 
       previewImageData:(nullable NSData *)previewImageData 
         miniProgramType:(GGQQMiniProgramType)miniProgramType 
                destType:(GGQQShareDestType)destType 
               completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!miniAppID || miniAppID.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-9 message:@"小程序AppID不能为空"]];
        return;
    }
    
    if (!webpageUrl || webpageUrl.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-10 message:@"网页链接不能为空"]];
        return;
    }
    
    // 使用QQApiURLObject来设置预览图
    QQApiURLObject *qqApiObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:webpageUrl] 
                                                           title:title 
                                                     description:description 
                                                previewImageData:previewImageData 
                                              targetContentType:QQApiURLTargetTypeNews];
    
    if (destType == GGQQShareDestTypeTIM) {
        qqApiObj.shareDestType = ShareDestTypeTIM;
    } else {
        qqApiObj.shareDestType = ShareDestTypeQQ;
    }
    
    QQApiMiniProgramObject *miniObj = [[QQApiMiniProgramObject alloc] init];
    miniObj.qqApiObject = qqApiObj;
    miniObj.miniAppID = miniAppID;
    miniObj.miniPath = miniPath;
    miniObj.webpageUrl = webpageUrl;
    miniObj.miniprogramType = (MiniProgramType)miniProgramType;
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithMiniContent:miniObj];
    [QQApiInterface sendReq:req];
}

/**
 * 唤起小程序
 * @param miniAppID 小程序AppID
 * @param miniPath 小程序路径
 * @param miniProgramType 小程序类型
 * @param completion 回调
 */
- (void)launchMiniProgram:(NSString *)miniAppID 
                 miniPath:(nullable NSString *)miniPath 
           miniProgramType:(GGQQMiniProgramType)miniProgramType 
              completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!miniAppID || miniAppID.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-9 message:@"小程序AppID不能为空"]];
        return;
    }
    
    QQApiLaunchMiniProgramObject *launchObj = [[QQApiLaunchMiniProgramObject alloc] init];
    launchObj.miniAppID = miniAppID;
    launchObj.miniPath = miniPath;
    launchObj.miniprogramType = (MiniProgramType)miniProgramType;
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:launchObj];
    [QQApiInterface sendReq:req];
}

/**
 * 设置QQ头像
 * @param imageData 头像图片数据
 * @param completion 回调
 */
- (void)setQQAvatarWithImageData:(NSData *)imageData completion:(nullable GGQQShareCompletionBlock)completion {
    self.shareCompletionBlock = completion;
    
    if (!imageData || imageData.length == 0) {
        [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-4 message:@"图片数据不能为空"]];
        return;
    }
    
    QQApiImageForQQAvatarObject *avatarObj = [[QQApiImageForQQAvatarObject alloc] initWithData:imageData previewImageData:imageData title:nil description:nil];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:avatarObj];
    [QQApiInterface sendMessageToQQAvatarWithReq:req];
}

+ (BOOL)isQQInstalled {
    return [QQApiInterface isQQInstalled];
}

+ (BOOL)isTIMInstalled {
    return [QQApiInterface isTIMInstalled];
}

+ (BOOL)isSupportShare {
    return [QQApiInterface isSupportShareToQQ];
}

+ (NSString *)qqDownloadURL {
    return [QQApiInterface getQQInstallUrl];
}

+ (NSString *)sdkVersion {
    return [TencentOAuth sdkVersion];
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin {
    self.authState = GGQQAuthStateAuthorized;
    
    GGQQUserInfo *userInfo = [[GGQQUserInfo alloc] init];
    userInfo.openId = self.oauth.openId;
    userInfo.unionId = self.oauth.unionid;
    self.currentUserInfo = userInfo;
    
    [self.oauth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    self.authState = GGQQAuthStateUnauthorized;
    
    NSString *message = cancelled ? @"用户取消登录" : @"登录失败";
    [self invokeAuthCompletionWithSuccess:NO userInfo:nil error:[GGQQError errorWithCode:-6 message:message]];
}

- (void)tencentDidNotNetWork {
    self.authState = GGQQAuthStateUnauthorized;
    
    [self invokeAuthCompletionWithSuccess:NO userInfo:nil error:[GGQQError errorWithCode:-7 message:@"网络错误"]];
}

- (void)tencentDidLogout {
    self.authState = GGQQAuthStateUnauthorized;
    self.currentUserInfo = nil;
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == URLREQUEST_SUCCEED && response.jsonResponse) {
        NSDictionary *dict = response.jsonResponse;
        
        GGQQUserInfo *userInfo = [[GGQQUserInfo alloc] init];
        userInfo.openId = self.oauth.openId;
        userInfo.unionId = self.oauth.unionid;
        userInfo.nickName = dict[@"nickname"] ?: dict[@"nick"];
        userInfo.sex = [dict[@"gender"] integerValue] ?: [dict[@"sex"] integerValue];
        userInfo.province = dict[@"province"];
        userInfo.city = dict[@"city"];
        userInfo.headImgURL = dict[@"figureurl_qq_1"] ?: dict[@"figureurl"];
        userInfo.figureURL = dict[@"figureurl_qq_2"];
        userInfo.originInfo = dict;
        
        self.currentUserInfo = userInfo;
        
        [self invokeAuthCompletionWithSuccess:YES userInfo:userInfo error:nil];
    } else {
        NSString *errorMsg = response.errorMsg ?: @"获取用户信息失败";
        [self invokeAuthCompletionWithSuccess:NO userInfo:nil error:[GGQQError errorWithCode:response.retCode message:errorMsg]];
    }
}

- (void)didGetUnionID {
    if (self.currentUserInfo) {
        self.currentUserInfo.unionId = self.oauth.unionid;
    }
}

#pragma mark - QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req {
    NSLog(@"[GGQQSDKManager] onReq: %@", req);
}

- (void)onResp:(QQBaseResp *)resp {
    NSLog(@"[GGQQSDKManager] onResp: %@", resp);
    
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *response = (SendMessageToQQResp *)resp;
        BOOL success = [response.result isEqualToString:@"0"];
        
        if (success) {
            [self invokeShareCompletionWithSuccess:YES error:nil];
        } else {
            NSString *errorMsg = response.errorDescription ?: @"分享失败";
            [self invokeShareCompletionWithSuccess:NO error:[GGQQError errorWithCode:-8 message:errorMsg]];
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    NSLog(@"[GGQQSDKManager] isOnlineResponse: %@", response);
}

@end
