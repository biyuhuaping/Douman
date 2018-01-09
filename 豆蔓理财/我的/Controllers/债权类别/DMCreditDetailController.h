//
//  DMCreditDetailController.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/9.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMBaseViewController.h"
/**
 债权类型

 - CarInsurancePerson: 车险分期类
 - CarInsuranceCompany: 车险分期类
 - CarMortgagePerson: 汽车抵押类
 - CarMortgageCompany: 汽车抵押类
 */
typedef NS_ENUM(NSInteger, CreditType){
    CarInsurancePerson,
    CarInsuranceCompany,
    CarMortgagePerson,
    CarMortgageCompany
};

@interface DMCreditDetailController : DMBaseViewController

@property (nonatomic) CreditType creditType;

@property (nonatomic, copy) NSString *loanId;

@property (nonatomic, copy) NSString *guarantyStyle;



@end
