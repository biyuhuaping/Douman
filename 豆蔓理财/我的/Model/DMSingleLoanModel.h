//
//  DMSingleLoanModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/26.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSingleLoanModel : NSObject

@property (nonatomic, copy) NSString *title;    //债权标题
@property (nonatomic, copy) NSString *isAheadSettle;    //是否提前结清
@property (nonatomic, copy) NSString *guarantyStyle;    //债权类型
@property (nonatomic, copy) NSString *loadId;    //债权id
@property (nonatomic, strong) NSNumber *ratio; //满标进度1为百分之百
@property (nonatomic, copy) NSString *investAmount;    //持有金额
@property (nonatomic, copy) NSString *loanStatusName;       // 标的状态;


@end
