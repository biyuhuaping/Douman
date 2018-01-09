//
//  DMTenderDescModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTenderDescModel : NSObject

@property (nonatomic, copy) NSString *loanId;        //债权ID
@property (nonatomic, copy) NSString *timeSettled;        //放款计息时间
@property (nonatomic, copy) NSString *isLoanSettle;        //0未满标，1已满标
@property (nonatomic, copy) NSString *isUserHasLoan;        //是否持有债权1是，0否
@property (nonatomic, copy) NSString *contractStatus;        //0未满标，1已满标未生成合同，2已生成合同
@property (nonatomic, copy) NSString *enterPrise;        //是否为企业(1企业，0个人)

@property (nonatomic, copy) NSString *title;        //借款标题
@property (nonatomic, copy) NSString *guarantyName;        //借款类型名称
@property (nonatomic, copy) NSString *guarantyStyle;        //借款类型
@property (nonatomic, copy) NSString *purpose;        //借款用途
@property (nonatomic, copy) NSString *repaymentGuaranty;        //还款保障
@property (nonatomic, copy) NSString *riskInfo;        //风险提示
@property (nonatomic, copy) NSString *loanAmount;        //借款额度
@property (nonatomic, copy) NSString *period;        //还款期限
@property (nonatomic, copy) NSString *loanDescription;        //资产描述
@property (nonatomic, copy) NSString *sourceOfAssets;        //债券来源
@property (nonatomic, copy) NSString *method;        //还款方式
@property (nonatomic, copy) NSString *methodName;        //还款方式中文
@property (nonatomic, copy) NSString *settlePeriod;        //已结期数
@property (nonatomic, copy) NSString *totalPeriod;        //总期数

@property (nonatomic, copy) NSString *borrowerName;        //借款人
@property (nonatomic, copy) NSString *mobile;        //手机号
@property (nonatomic, copy) NSString *idNumber;        //身份证号
@property (nonatomic, copy) NSString *dateOfBirth;        //出生日期
@property (nonatomic, copy) NSString *educationLevel;        //学历
@property (nonatomic, copy) NSString *nativeAddress;        //籍贯
@property (nonatomic, copy) NSString *house;        //房产1有，0无
@property (nonatomic, copy) NSString *houseLoan;        //房贷1有，0无
@property (nonatomic, copy) NSString *car;        //车产1有，0无
@property (nonatomic, copy) NSString *carLoan;        //车贷1有，0无
@property (nonatomic, copy) NSString *companyIndustry;        //个人从事行业
@property (nonatomic, copy) NSString *jobPositon;        //职位
@property (nonatomic, copy) NSString *totalYearOfService;        //工作年限
@property (nonatomic, copy) NSString *workProvince;        //工作省份

@property (nonatomic, copy) NSString *shortName;        //公司简称
@property (nonatomic, copy) NSString *category;        //公司类型
@property (nonatomic, copy) NSString *businessCope;        //经营范围
@property (nonatomic, copy) NSString *scale;        //公司规模
@property (nonatomic, copy) NSString *annualTurnover;        //年交易额
@property (nonatomic, copy) NSString *timeEstablished;        //成立时间
@property (nonatomic, copy) NSString *industry;        //公司行业
@property (nonatomic, copy) NSString *corpDescription;        //企业描述
@property (nonatomic, copy) NSString *registeredCapital;        //注册资本
@property (nonatomic, copy) NSString *registeredLocation;        //注册地址
@property (nonatomic, copy) NSString *legalPersonName;        //法定代表人

@property (nonatomic, assign) int idNumberAuthen;   //身份证认证（1已认证，0未认证）
@property (nonatomic, assign) int incomeAuthen;     //收入认证 （1已认证，0未认证
@property (nonatomic, assign) int mobileAuthen;     //手机认证
@property (nonatomic, assign) int houseAuthen;      //房产认证
@property (nonatomic, assign) int jobAuthen;        //工作认证
@property (nonatomic, assign) int carAuthen;        //车产认证
@property (nonatomic, assign) int creditAuthen;     //信用认证 （
@property (nonatomic, assign) int yingyeAuthen;     //营业认证
@property (nonatomic, assign) int shidiAuthen;      //实地认证

@property (nonatomic, assign) int isNew;    //是否为新系统标的
@property (nonatomic, assign) int userId;   //借款人ID
@property (nonatomic, assign) int memId;    //借款人旧系统ID
@property (nonatomic, assign) double totalLoanAmount;       //平台借款总额
@property (nonatomic, assign) int totalLoanCount;           //借款总笔数
@property (nonatomic, assign) double undueLoanAmount;       //借贷余额
@property (nonatomic, assign) int undueLoanCount;           //在还笔数
@property (nonatomic, assign) double overdueLoanAmount;     //逾期金额
@property (nonatomic, assign) int overdueLoanCount;         //逾期笔数字段

@property (nonatomic, assign) int termUnit; //期限单位
@end
