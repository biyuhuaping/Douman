//
//  DMKeepRecordModel.h
//  豆蔓理财
//
//  Created by bluesky on 2017/8/29.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMKeepRecordModel : NSObject

@property (nonatomic, copy)NSString *CONTRACTTYPE; //类型
@property (nonatomic, copy)NSString *TIMECREATED; //时间
@property (nonatomic, copy)NSString *SECURITYNUMBER; //编号
@property (nonatomic, copy)NSString *LOANID; //标的ID
@property (nonatomic, copy)NSString *NAME; //名称
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *PATH; //查看详情路径
@property (nonatomic, copy)NSString *TYPE; //汉字类型
@property (nonatomic, copy)NSString *ISSIGN; 

@end
