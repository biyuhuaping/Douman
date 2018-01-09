//
//  ShareManager.m
//  ARTProject
//
//  Created by 黄保贤 on 15/3/12.
//  Copyright (c) 2015年 黄保贤. All rights reserved.
//

#import "ShareManager.h"
#import "UMSocialData.h"
#import "UMSocial.h"

#import "UMSocialWechatHandler.h"

#import "UMSocialQQHandler.h"



static ShareManager *_sharedManager=nil;
@interface ShareManager()
@property(nonatomic,strong)UIViewController *superController;
@property(nonatomic,copy)NSString *sharedText;
@property(nonatomic,strong)UIImage *sharedImage;
@property (nonatomic, copy) NSString *shareContent;

@end

@implementation ShareManager
+(ShareManager *)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ShareManager alloc] init];
    });
    return _sharedManager;
}


-(instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}


+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
    });
    return _sharedManager;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _sharedManager;
}
-(void)sharedFrindWithType:(sharedType)type  andController:(UIViewController *)controller andText:(NSString *)text andImage:(UIImage *)image Content:(NSString *)content Url:(NSString *)url{
    self.sharedText=text;
    self.sharedImage=image;
    self.sharedUrl= url;
    self.shareContent = content;
    
    /**
     *  使用之前请设置URL
     */
    
    
    self.superController=controller;
    switch (type) {
        case sharedTypeWeChat:
            [self sharedToWeChat];
            break;
        case sharedTypeFriendQurn:
            [self sharedToFriendQurn];
            break;
        case sharedTypeTengXunQorn:
            [self sharedToQQQurn];
            break;
        case sharedTypeTengXunQQ:
            [self sharedQQ];
            break;
        case sharedTypeDuanXin:
            [self sharedWoMessage];
            break;
        case sharedTypeXinLang:
            [self sharedToNewLang];
            break;
        case sharedTypeARTFriendCircle:
            [self sharedToARTCirlcleFriend];
            break;
        default:
            break;
    }
}

#pragma 美术圈
-(void)sharedToARTCirlcleFriend{
    
}
#pragma mark - 微信
-(void)sharedToWeChat{
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeNone;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _sharedUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = _sharedText ;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent  image:self.sharedImage location:nil urlResource:nil presentedController:self.superController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
        }
    }];
}

#pragma mark - 朋友圈
-(void)sharedToFriendQurn{
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _sharedUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title =  self.shareTitle;
    UMSocialUrlResource *resu=[[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_sharedUrl];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.sharedText image:self.sharedImage location:nil urlResource:resu presentedController:self.superController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            ShowMessage(@"分享成功");
        }
    }];

}

#pragma mark -qq空间
-(void)sharedToQQQurn{
//    [UMSocialData defaultData].extConfig.qzoneData.qqMessageType = UMSocialQQMessageTypeDefault;   
    [UMSocialData defaultData].extConfig.qzoneData.url = _sharedUrl;
    [UMSocialData defaultData].extConfig.qzoneData.title =  self.sharedText;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.shareTitle image:self.sharedImage location:nil urlResource:nil presentedController:self.superController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
           //  KMBShowSuccessMessage(@"分享成功");
        }
    }];
}
#pragma mark -qq
-(void)sharedQQ{
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.url = _sharedUrl;
    [UMSocialData defaultData].extConfig.qqData.title =  self.sharedText;

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareTitle image:self.sharedImage location:nil urlResource:nil presentedController:self.superController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
        }
    }];

}

#pragma mark 新浪
-(void)sharedToNewLang{    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:self.shareTitle image:self.sharedImage location:nil urlResource:nil presentedController:self.superController completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
    
}

#pragma mark -短信
-(void)sharedWoMessage{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content: self.sharedText  image:nil location:nil urlResource:nil presentedController:self.superController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
             //KMBShowSuccessMessage(@"分享成功");
        }
    }];

}


@end
