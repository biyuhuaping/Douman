//
//  DMWebUrlManager.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/1/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMWebUrlManager.h"


@implementation DMWebUrlManager

+ (instancetype)manager{
    static DMWebUrlManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMWebUrlManager alloc] init];
    });
    return manager;
}

// 充值
- (NSString *)getChargeUrl{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000000;
    NSString *time = [@(interval) stringValue];
    return [NSString stringWithFormat:@"%@mzc/newAccount/recharge/%@?token=%@&fromapp=1",weburl,time,AccessToken];
}

// 关于我们

- (NSString *)getAboutUs{
    return [NSString stringWithFormat:@"%@mzc/help/aboutUs?fromapp=1",weburl];
    
}

// 帮助中心
- (NSString *)getHelpCenter{
    return [NSString stringWithFormat:@"%@mzc/help/helpCenter?fromapp=1",weburl];
}

// 债权模式

- (NSString *)creditModel{
    return [NSString stringWithFormat:@"%@mzc/help/creditor?fromapp=1",weburl];
}

//新手专享

- (NSString *)newHang{
    NSString *url;
    if (AccessToken) {
        url = [NSString stringWithFormat:@"%@mzc/help/newHang-lp?fromapp=1&token=%@",weburl,AccessToken];
    }else{
        url = [NSString stringWithFormat:@"%@mzc/help/newHang-lp?fromapp=1",weburl];
    }
    return url;
}

//安全保障
- (NSString *)safeguard{
    return [NSString stringWithFormat:@"%@mzc/pingtai/insuranceLevel3?fromapp=1",weburl];
}

// 公告内容
- (NSString *)platformDetail{
    return [NSString stringWithFormat:@"%@mzc/noticeDetail?fromapp=1",weburl];
}

// 相关协议及风险提示

//- (NSString *)productProtocol{
//    return [NSString stringWithFormat:@"%@mzc/newAccount/productProtocol?fromapp=1&token=%@",weburl,AccessToken];
//}

// 注册协议
- (NSString *)registerProtocol{
    return [NSString stringWithFormat:@"%@mzc/help/protocol?fromapp=1",weburl];
}

//机器人协议
- (NSString *)getRobotProtocolUrl{
    return [NSString stringWithFormat:@"%@mzc/robot/protocol?fromapp=1&apptype=1",weburl];
}

////获取借贷咨询与管理协议pdf：
//- (NSString *)getPdf:(NSString *)contractId {
//    NSString *pathName = [NSString stringWithFormat:@"api/v2/useramountinfo/getRecordProtocoly?contractId=%@&access_token=%@",contractId,AccessToken];
//    return hostName(pathName);
//    
//}

- (NSString *)protocolWithassetId:(NSString *)assetId{
    
    return [NSString stringWithFormat:@"%@mzc/newAccount/CDProtocolList/%@?access_token=%@&fromapp=1",weburl,assetId,AccessToken];
}


- (NSString *)getActivityUrl{
    NSString *url;
    if (AccessToken) {
        url = [NSString stringWithFormat:@"%@mzc/pingtai/huisActivities?fromapp=1&token=%@",weburl,AccessToken];
    }else{
        url = [NSString stringWithFormat:@"%@mzc/pingtai/huisActivities?fromapp=1",weburl];
    }
    return url;
}


//sumapay 徽商
- (NSString *)getsumapayUrl{
    return [NSString stringWithFormat:@"%@?access_token=%@&fromapp=1&token=%@",huishangUrl,AccessToken,AccessToken];
}

// 徽商设置交易密码
- (NSString *)getReplaceWebUrl{
    return [NSString stringWithFormat:@"%@",huishangUrl];
}

//获取自动投标协议
- (NSString *)getAutoSignAuthProtocolUrl {
    return  [NSString stringWithFormat:@"%@mzc/newAccount/autoSignAgreement?fromapp=1&apptype=0&token=%@",weburl,AccessToken];
}

// 自动投标签约
- (NSString *)getAutoMakeABid{
    return [NSString stringWithFormat:@"%@newAccount/autoSign?token=%@&fromapp=1&apptype=0",weburl,AccessToken];
}


- (NSString *)getHuiShangPingTai{
    return [NSString stringWithFormat:@"%@mzc/pingtai/huishang?fromapp=1&apptype=0",weburl];
}
@end
