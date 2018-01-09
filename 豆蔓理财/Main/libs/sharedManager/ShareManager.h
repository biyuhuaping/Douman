//
//  ShareManager.h
//  ARTProject
//
//  Created by 黄保贤 on 15/3/12.
//  Copyright (c) 2015年 黄保贤. All rights reserved.
//

/**
 *  相关设置在  http://dev.umeng.com/social/ios/quick-integration

 * 主要查看其中的友盟 appkey ，微信  qq，新浪 ，appkey设置
 */




/**
 *在 appdelegaet 添加头文件 并且启动
 *
 #import "UMSocial.h"
 #import "UMSocialWechatHandler.h"
 #import "UMSocialQQHandler.h"
 #import "UMSocialSinaHandler.h"
 
 //启动友盟
 [UMSocialData setAppKey:UmengAppkey];
 //是否打印log
 [UMSocialData openLog:YES];
 
 //启动微信微信
 [UMSocialWechatHandler setWXAppId:@"wx144663d4ae48cdcf" appSecret:@"81daa257f2c448725dc737d656aa947d" url:@"http://meishuquan.net"];
 
 //启动qq
 [UMSocialQQHandler setQQWithAppId:@"1104485283" appKey:@"k9f8JhWppP5r1N5t" url:@"http://www.meishuquan.net"];
 
 //启动新浪
 [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
 *
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//#import "ARTCircleSharedParamModel.h"

typedef void(^sharedSuccessBlock)();
typedef void(^sharedFailureBlock)();


typedef NS_ENUM(NSInteger, sharedTypeOriginal) {
    sharedTypeOriginalnews,
    sharedTypeOriginalCircle,
    sharedTypeOriginalInviteCode
};

typedef NS_ENUM(NSInteger, sharedType) {
    sharedTypeWeChat,//微信
    sharedTypeTengXunQQ, //腾讯qq
    sharedTypeTengXunQorn,//腾讯空间
    sharedTypeXinLang,//新浪
    sharedTypeDuanXin,//短信
    sharedTypeFriendQurn,//朋友圈
    sharedTypeARTFriendCircle// available in iOS 3.0//美术圈
};

@interface ShareManager : NSObject

@property(nonatomic,copy)sharedSuccessBlock  successBlock;
@property(nonatomic,copy)sharedFailureBlock  FailureBlock;
@property(nonatomic,copy)NSString *idStr;
@property(nonatomic,assign)sharedTypeOriginal  comeType;
@property(nonatomic,strong)NSString *sharedUrl;

@property (copy, nonatomic) NSString *shareTitle;

+(ShareManager *)sharedManager;


/**
 *  分享参数设置
 *
 *  @param type       类型
 *  @param controller 控制器
 *  @param text       内容
 *  @param image      图片
 *  设置url  self.sharedUrl=@"";
 */
-(void)sharedFrindWithType:(sharedType)type  andController:(UIViewController *)controller andText:(NSString *)text andImage:(UIImage *)image Content:(NSString *)content Url:(NSString *)url;


/**
 *  分享到美术圈
 */
//-(void)sharedFrindWithType:(ARTCircleSharedParamModel *)parm  andController:(UIViewController *)controller;

@end
