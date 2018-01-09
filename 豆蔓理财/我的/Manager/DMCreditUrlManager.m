//
//  DMCreditUrlManager.m
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMCreditUrlManager.h"


@implementation DMCreditUrlManager

+ (instancetype)manager{
    static DMCreditUrlManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMCreditUrlManager alloc] init];
    });
    return manager;
}

// 持有债权列表
- (NSString *)getHoldCreditListUrlWithStyle:(NSString *)style Size:(NSString *)size{
    NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getAssetList?access_token=%@&userId=%@&guarantyStyle=%@&size=%@",AccessToken,USER_ID,style,size];
    return hostName(pathName);
}

// 单期持有债权
- (NSString *)getSingleHoldCreditWithAssetid:(NSString *)assetId Page:(NSString *)page{
    NSString *path = [NSString stringWithFormat:@"apk/userAccount/getLoansByAsset?access_token=%@&userId=%@&assetId=%@&page=%@&size=100",AccessToken,USER_ID,assetId,page];
    return hostName(path);
}

// 车辆质押债权详情
- (NSString *)getCarPledgeCreditDetailWithLoanId:(NSString *)loanId{
    NSString *path = [NSString stringWithFormat:@"apk/userAccount/getLoanDetail?access_token=%@&userId=%@&loanId=%@",AccessToken,USER_ID,loanId];
    return hostName(path);
}

// 车险分期债权详情

- (NSString *)getCarInsuranceCreditDetailWithLoanId:(NSString *)loanId{
    NSString *path = [NSString stringWithFormat:@"apk/userAccount/getCarInsuranceLoanDetail?access_token=%@&userId=%@&loanId=%@",AccessToken,USER_ID,loanId];
    return hostName(path);
}



// 校验登录密码
- (NSString *)getCheckPassWordUrl{
    NSString *path = [NSString stringWithFormat:@"%@api/v2/user/%@/checkLoginPassword?access_token=%@",mainUrl,USER_ID,AccessToken];
    return path;
}


// 我的账户 债转转让列表

- (NSString *)getCreditTransferListUrlStatus:(NSString *)status{
    NSString *path = [NSString stringWithFormat:@"apk/creditassign/listUserAssign?userId=%@&access_token=%@&status=%@&page=1&size=100",USER_ID,AccessToken,status];
    return hostName(path);
}

//我的账户 发起债转

- (NSString *)getCreditTransferStartUrlInvestId:(NSString *)investId{
    NSString *path = [NSString stringWithFormat:@"api/v4/creditassign/startAssignApply?userId=%@&access_token=%@&investId=%@",USER_ID,AccessToken,investId];
    return hostName(path);
}

//我的账户 发起债转

- (NSString *)getCreditTransferRevokeUrlTransferId:(NSString *)transferId{
    NSString *path = [NSString stringWithFormat:@"api/v4/creditassign/cancelAssignApply?userId=%@&access_token=%@&id=%@",USER_ID,AccessToken,transferId];
    return hostName(path);
}

// 债权合同
- (NSString *)getCreditContactUrl:(NSString *)loanId{
    NSString *path = [NSString stringWithFormat:@"api/dmcc/contract/getInvestContract?userId=%@&loanId=%@&access_token=%@",USER_ID,loanId,AccessToken];
    return hostName(path);
}

// 已转让合同
- (NSString *)getTransferContactUrl:(NSString *)assignId{
    NSString *path = [NSString stringWithFormat:@"apk/creditassign/showContractList?assignId=%@",assignId];
    return hostName(path);
}

//提现——保存订单
- (NSString *)getdrawSavePayUrl{
    NSString *path = [NSString stringWithFormat:@"%@api/sumpay/withdraw/savePay?access_token=%@",mainUrl,AccessToken];
    return path;
}

//提现——请求form表单数据
- (NSString *)getFormDataUrl{
    NSString *path = [NSString stringWithFormat:@"%@api/sumpay/withdraw/form?access_token=%@&loginFlag=%@",mainUrl,AccessToken,AccessToken];
    return path;
}

//设置交易密码
- (NSString *)getReplacePassWordUrl{
    NSString *path = [NSString stringWithFormat:@"api/sumpay/account/setPayPwd/%@?access_token=%@&source=APP&loginFlag=%@",USER_ID,AccessToken,AccessToken];
    return hostName(path);
}

@end
