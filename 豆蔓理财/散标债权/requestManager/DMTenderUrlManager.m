//
//  DMTenderUrlManager.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMTenderUrlManager.h"

@implementation DMTenderUrlManager

+ (instancetype)manager{
    static DMTenderUrlManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMTenderUrlManager alloc] init];
    });
    return manager;
}


- (NSString *)getCreditDescUrlLoanId:(NSString *)loanId{
    NSString *pathName = [NSString stringWithFormat:@"apk/index/getLoanInfo?loanId=%@",loanId];
    return hostName(pathName);
}


- (NSString *)getTenderBuyListWithLoanId:(NSString *)loanId Size:(NSString *)size{
    NSString *pathName = [NSString stringWithFormat:@"apk/index/getRetailLoanBuyList?loanId=%@&page=1&size=%@",loanId,size];
    return hostName(pathName);
}


#pragma mark  我的服务

- (NSString *)getMyServerRobotInfoUrl{
    NSString *pathName = [NSString stringWithFormat:@"apk/robot/robotInfo?userId=%@&access_token=%@",USER_ID,AccessToken];
    return hostName(pathName);
}


- (NSString *)getMyServerHoldListWithStatus:(NSString *)status Size:(NSString *)size{
    NSString *pathName = [NSString stringWithFormat:@"apk/robot/listUserRobotsByStatus?userId=%@&access_token=%@&status=%@&page=1&size=%@",USER_ID,AccessToken,status,size];
    return hostName(pathName);
}

- (NSString *)getMyserverHoldCreditWithRobotId:(NSString *)robotId Size:(NSString *)size{
    NSString *pathName = [NSString stringWithFormat:@"apk/robot/listUserRobotLoans?&robotOrderId=%@&userId=%@&access_token=%@&page=1&size=%@",robotId,USER_ID,AccessToken,size];
    return hostName(pathName);
}


@end
