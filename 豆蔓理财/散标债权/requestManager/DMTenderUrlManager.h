//
//  DMTenderUrlManager.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTenderUrlManager : NSObject

+ (instancetype)manager;


#pragma mark --  散标详情

/**
 资产说明
 @param loanId 标的ID
 */
- (NSString *)getCreditDescUrlLoanId:(NSString *)loanId;


- (NSString *)getTenderBuyListWithLoanId:(NSString *)loanId
                                    Size:(NSString *)size;


#pragma mark --  我的服务

- (NSString *)getMyServerRobotInfoUrl;


/**
 我的服务持有列表

 @param status 0持有中   1已结清
 */
- (NSString *)getMyServerHoldListWithStatus:(NSString *)status Size:(NSString *)size;


/**
 持有中列表详情
 */
- (NSString *)getMyserverHoldCreditWithRobotId:(NSString *)robotId Size:(NSString *)size;

@end
