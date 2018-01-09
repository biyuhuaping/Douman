//
//  GZContractModel.h
//  豆蔓理财
//
//  Created by armada on 2017/4/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZContractModel : NSObject
/** 客户 */
@property(nonatomic, copy) NSString *client;
/** 内容 */
@property(nonatomic, copy) NSString *content;
/** 合同编号 */
@property(nonatomic, copy) NSString *contractNo;
/** 合同id */
@property(nonatomic, copy) NSString *Id;
/** 签名 */
@property(nonatomic, strong) NSNumber *isSign;
/** 贷款id */
@property(nonatomic, copy) NSString *loanId;
/** 合同名 */
@property(nonatomic, copy) NSString *name;
/** 创建时间 */
@property(nonatomic, strong) NSNumber *timeCreated;
/** 合同类型 */
@property(nonatomic, copy) NSString *type;
/** 用户id */
@property(nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *path;

@end
