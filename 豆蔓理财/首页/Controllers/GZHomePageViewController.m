//
//  GZHomeSecondSceneViewController.m
//  豆蔓首页分解
//
//  Created by armada on 2016/12/5.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import "GZHomePageViewController.h"

//网络请求单例类
#import "GZHomePageRequestManager.h"
#import "DMLoginRequestManager.h"
#import "DMWebUrlManager.h"
#import "LJQHomeManager.h"
#import "LJQMineRequestManager.h"

//ViewController
#import "HMTabBarViewController.h"
#import "GZOwnedSinglePeriodViewController.h"
#import "GZDistributionTargetViewController.h"
#import "GZReviewedListViewController.h"
#import "GZCouponsViewController.h"
#import "DMLoginViewController.h"
#import "DMRegisterViewController.h"
#import "DMCurrentClaimsViewController.h"
#import "DMLoginViewController.h"
#import "DMRegisterViewController.h"
#import "DMRealNameCertifyViewController.h"
#import "DMAddBandCardViewController.h"
#import "LJQProductIntroductionvc.h"
#import "LJQBuyListVC.h"
#import "LJQTopUpVC.h"
#import "LJQContactVC.h"
//View
#import "DMSlideMenu.h"
#import "DMSlideMenuView.h"
#import "GZCircleSlider.h"
#import "GZPurchaseProgressView.h"
#import "GZCustomStyleButton.h"
#import "GZAnimationIndicator.h"
#import "GZInvestSignReminderView.h"
#import "DMNewHandView.h"
#import "DMLoginRequestManager.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
#import "LJQMineRequestManager.h"
#import "LJQWithDrawalVC.h"
#import "LJQTradePassWordVC.h"
#import "DMCalculateViewController.h"
//Extension
#import "UILabel+YBAttributeTextTapAction.h"


#import "DMOpenPopUpView.h"
#import "DMCodeViewController.h"
#import "LJQCreditTransferTheZoneVC.h"
#import "DMSettingManager.h"
#import "DMCreditRequestManager.h"
#define ToFontSize(px) round((double)px/96*72)


@interface GZHomePageViewController ()<UITextFieldDelegate,UIScrollViewDelegate,CAAnimationDelegate,GZCircleSliderDelegate,DMSlideMenuView,LJQCouponCellDelegate,GZInvestSignSkipDelegate,OpenPopUpDelegate>
{
    UIButton *knowMoreBtn;
    UIButton *searchPastBtn;
   
    UIImageView *separatorImgView;
    UIImageView *leftVerticalSeparatorImgView;
    UIImageView *rightVerticalSeparatorImgView;
    
    //计算器按钮
    UIButton *calculatorBtn;
    //首页底部按钮
    UIButton *purchasedListBtn;
    UIButton *purchaseBtn;
    UIButton *currentCreditorRightBtn;
    UILabel *reminderLabel;
    UILabel *reminderFooterLabel;

    UIButton *backToPreviousPageBtn;
    UIImageView *block_1;
    
    //"我的资产在跑步"按钮
    UIButton *skipToMyAccountBtn;
    //"开启赚钱/继续赚钱"按钮
    GZCustomStyleButton *nextPageBtn;
    
    UILabel *profitRateTitleLabel;
    
    UIImageView *deepGreenImgView;
    UIImageView *lightGreenImgView;
    UIImageView *monthlyBillingTitleImgView;
    
    //查看优惠券
    UIButton *searchCardBtn;

    //购买抛物线图标
    UIImageView *comfirmIconView;
    //原frame
    CGRect originRect;
    
    //assetId记录产品ID
    NSString *assetId;
    //记录基本利率
    double basicInterest;
    //记录产品利率(基本利率+加息率)
    double interestRate;
    //记录借款期限
    double productDuration;
    //记录产品类型
    NSString *assetRepaymentMethod;
    //记录当前buyRecordId
    NSString *assetBuyRecordId;
    //记录优惠券id
    NSString *couponId;
    //类型名
    NSString *guarantyName;
    //产品名
    NSString *guarantyStyle;
    
    //产品介绍是否应该在圆形原则器处显示
    BOOL isShowingSecondSceneOnly;
    //键盘是否是弹出状态
    BOOL isShowingKeyboard;
    //视图是否是第一次加载
    BOOL isLoadedAlready;
    //viewDidLoad是否已经加载完成
    BOOL isDidLoadViews;
    //是否从优惠券页面跳转回首页
    BOOL isBackToHomeFromCoupon;
    
  
    NSDictionary *userdic;//个人信息字典


}

/** 是否是持有 */
@property(nonatomic,assign) BOOL isOwned;
/** 是否是登录状态 */
@property(nonatomic,assign) BOOL isLoggedIn;
/** 侧滑按钮 */
@property(nonatomic,strong)UIButton * slideBtn;
@property(nonatomic,strong) DMSlideMenuView *DMSlideMenuView;
@property(nonatomic,strong) DMSlideMenu *menu;
/** 滚动视图 */
@property(nonatomic,strong) UIScrollView *scrollView;
/** 容器视图 */
@property(nonatomic,strong) UIView *scrollContainerView;
/** 首页环形指示器 */
@property(nonatomic,strong) GZAnimationIndicator *indicator;
/** 累计交易人次 */
@property(nonatomic,strong) UILabel *accumulatedLabel;
/** 交易金额(元) */
@property(nonatomic,strong) UILabel *transacitonAmountLabel;
/** 总投资金额 */
@property(nonatomic,strong) UILabel *investTotalAmountLabel;
/** 环形选择器 */
@property(nonatomic,strong) GZCircleSlider *circleSlider;
/** 收益率 */
@property(nonatomic,strong) UILabel *interestRateLabel;
/** 产品类型容器 */
@property(nonatomic,strong) UIView *productTypeBlockView;
/** 产品类型 */
@property(nonatomic,strong) UILabel *productTypeLabel;
/** 产品标签 */
@property(nonatomic,strong) UIImageView *productTypeTagImageView;
/** 年化利率 */
@property(nonatomic,strong) UILabel *profitRateLabel;
/** 借款期限 */
@property(nonatomic,strong) UILabel *productDurationLabel;
/** 剩余可购 */
@property(nonatomic,strong) UILabel *availablePurchaseLabel;
/** 筹标进度 */
@property(nonatomic,strong) GZPurchaseProgressView *progressView;
/** 筹标百分比显示 */
@property(nonatomic,strong) UILabel *progressPercentLabel;
/** 筹标截止时间 */
@property(nonatomic,strong) UILabel *deadlineLabel;
/** 立即购买block */
@property(nonatomic,strong) UIImageView *purchaseRightNowBlockView;
/** 预期收益 */
@property(nonatomic,strong) UILabel *expectedProfitLabel;
/** 月结本息 */
@property(nonatomic,strong) UILabel *monthlyBillingLabel;
/** 购买金额输入框 */
@property(nonatomic,strong) UITextField *sumInputTextField;
/** 账户余额 */
@property(nonatomic,strong) UIButton *accountBalanceBtn;
/** 新手专享 */
@property(nonatomic,strong) UIImageView *privateEnjoymentForFreshImgView;
/** 图标指示动画定时器 */
@property(nonatomic,strong) NSTimer *iconIndicatingTimer;
/** 无产品数据标签 */
@property(nonatomic,strong) UILabel *noProductDataLabel;
/** 产品信息和购买block*/
@property(nonatomic,strong) UIView *productInfoAndPurchasingBlockView;
/** 自动投票签约提示框 */
@property(nonatomic,strong) GZInvestSignReminderView *investSignReminderView;

@property (nonatomic, strong)LJQMineModel *mineModel;
@property (nonatomic, strong) CLTShareView *shareView;

/** 产品还款方式 */
@property(nonatomic, copy) NSString *repaymentMethod;

@property (nonatomic, strong)LJQUserInfoModel *userModel;

@property (nonatomic, strong)UIAlertController *alertViewVC;

@end

@implementation GZHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //优惠券ID置空
    couponId = @"";
    
    //判断登录状态
    if(AccessToken) {
        _isLoggedIn = YES;
    }else {
        _isLoggedIn = NO;
    }
    
    //布局全局UI
    [self createNav];
    [self createScrollContainer];
    
    [self prepareForNewMemInfoData]; //请求用户数据
    [self prepareForBasicElement]; //请求首页基础数据
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"exit" object:nil];
    [self.navigationController.view addSubview:self.shareView];
    self.shareView.alpha = 0;
    
    if (AccessToken) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"showview"]) {
            [self open];
        }
    }
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_slideBtn];
    
    BOOL activity = [[[NSUserDefaults standardUserDefaults] objectForKey:@"openactivity"] boolValue];
    
    //实例化一个NSDateFormatter对象
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate *deadlineDate = [dateFormatter dateFromString:@"2017-6-14 23:59:59"];
    
    //if ([deadlineDate timeIntervalSinceNow] >= 0) {
        
        if (activity) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"activitygift1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"activitygift"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
        }
   // }
    
    [self createSlideMenu]; //创建侧滑菜单
    
    LJQHomeManager *manager = [LJQHomeManager shareHomeManager];
    
    if(manager.isOpen == 1) {
        
        if(isDidLoadViews) { //views加载完成
            
            if(!_purchaseRightNowBlockView) {
                
                [self calculatorBtnClick];
            }else {
                self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height-DMDeviceHeight+49+64);
            }
            
            manager.isOpen = 0;
        }
    }
    
    //如果页面已经加载,更新用户基本数据和产品数据;否则不需要更新
    if(isLoadedAlready && _circleSlider && self.circleSlider.isDraggedOrTapped) {
        [self updateProductData];
        [self prepareForBasicElement];
    }
    
    //如果跑马灯已经创建,开启动画
    if(_indicator) {
        
        [self.indicator beginAnimation];
    }
    
    //如果定时器没有创建,则创建一个新的定时器
    if(!_iconIndicatingTimer) {
        _iconIndicatingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(iconAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_iconIndicatingTimer forMode:NSRunLoopCommonModes];
    }
    
    //如果购买模块处于展开状态,则刷新用户可用余额
    if(_purchaseRightNowBlockView && USER_ID) {
        [self prepareForUserAvailableAmount];
    }
    //添加键盘监听
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //监听输入框文本改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)open {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cardNbr"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DMSettingManager RequestManager] requestForTieOnCardSuccess:^(BOOL sure) {
            if (!sure) {
                DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:YES];
                open.delegate = self;
                [self.navigationController.tabBarController.view addSubview:open];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } Faild:^() {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:NO];
        open.delegate = self;
        [self.navigationController.tabBarController.view addSubview:open];
    }
}

- (void)openpopupClick {
    DMCodeViewController *code = [[DMCodeViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.shareView hide];
    //文本框放弃第一响应者
    if(_sumInputTextField) {
        [self.sumInputTextField resignFirstResponder];
    }
    
    if(_indicator) {
        //关闭跑马灯动画
        [self.indicator stopAnimation];
    }
    
    //关闭按钮悬浮动画
    if(!_iconIndicatingTimer) {
        
        [_iconIndicatingTimer invalidate];
        _iconIndicatingTimer = nil;
    }
    
    //移除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Networking Request

/** 请求新手专享数据 */
- (void)prepareForNewMemInfoData {
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageIsInvestWithUserId:USER_ID accessToken:AccessToken successBlock:^(BOOL result, NSString *message, NSNumber *isInvested) {
        
        if(result) {
            
            if(isInvested) { //用户已经登录
                
                if(isInvested.doubleValue == 0) { //不是新手
                    
                }else { //是新手
                    
                    if(PhoneNumber) {
                        [self.scrollContainerView addSubview:self.privateEnjoymentForFreshImgView];
                    }
                }
            }else { //用户未登录
                
                [self.scrollContainerView addSubview:self.privateEnjoymentForFreshImgView];
            }
        }else {
            
        }
        
    } failureBlock:^(NSError *err) {
        
        [self.scrollContainerView addSubview:self.privateEnjoymentForFreshImgView];
    }];
}

/** 请求基本数据 */
- (void)prepareForBasicElement {
    if (JudgeStatusOfNetwork()) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[GZHomePageRequestManager defaultManager]requestForHomePageBasicDataWithType:@"doumandingqi" userId:USER_ID successBlock:^(BOOL result, NSString *message, NSString *platformInvestTotalAmount, NSNumber* platformTotalnvestor, NSString *totalAmount, NSString *hasAmount) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(result) {
                
                if(!isLoadedAlready) {
                    
                    isLoadedAlready = YES; //viewDidLoad已经加载
                    
                    //持有资产不为0,并且用户登录
                    if(totalAmount.doubleValue != 0.0 && USER_ID != nil) {
                        _isOwned = YES;
                    }else {
                        _isOwned = NO;
                    }
                    //加载第一屏UI界面
                    [self prepareForDashboardBlocks];
                    [self prepareForNextPageBtn];
                    
                    if(_isOwned && _isLoggedIn) {
                        //登录且持有状态,显示第一屏内容
                        [self loadTopButtonsWithConditionOfShowingProductionIntroAndBackBtn:YES];
                        isShowingSecondSceneOnly = NO;
                    }else {
                        //非登录或者非持有状态,则不显示第一屏内容
                        self.scrollView.contentOffset = CGPointMake(0, DMDeviceHeight-64-49);
                        
                        [self loadTopButtonsWithConditionOfShowingProductionIntroAndBackBtn:NO];
                        isShowingSecondSceneOnly = YES;
                        
                        //非登录或者非持有状态,则下移新手专享图标
                            self.privateEnjoymentForFreshImgView.frame = CGRectMake(self.view.frame.size.width-60*DMDeviceWidth/375, self.view.center.y-100+(DMDeviceHeight-49-64), 60*DMDeviceWidth/375, 60*DMDeviceWidth/375);
                    }
                    
                    [self loadSeparatedRegion]; //载入产品数据模块
                    
                    [self prepareForDefaultProductInHomePage]; //请求默认月份   
                }
                
                if(_isOwned) { //持有状态
                    
                    //用户投资总额
                    self.investTotalAmountLabel.text = [self getFormattedAmountOfNumberWithString:hasAmount];
                    //投资人数
                    self.accumulatedLabel.text = [self getStandardTotalNumOfTradeWithString:[NSString stringWithFormat:@"%ld",platformTotalnvestor.integerValue+472745]];
                    //平台投资总额
                    self.transacitonAmountLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",platformInvestTotalAmount.doubleValue+1362730500]];
                    
                    [nextPageBtn setTitle:@"继续赚钱" forState:UIControlStateNormal];
                    [nextPageBtn setTitle:@"继续赚钱" forState:UIControlStateHighlighted];
                    
                }else { //非持有状态
                    
                    //平台投资总额
                    self.investTotalAmountLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",platformInvestTotalAmount.doubleValue+1362730500]];
                    //投资人数
                    self.accumulatedLabel.text = [self getStandardTotalNumOfTradeWithString:[NSString stringWithFormat:@"%ld",platformTotalnvestor.integerValue+472745]];
                    
                    [nextPageBtn setTitle:@"开启赚钱" forState:UIControlStateNormal];
                    [nextPageBtn setTitle:@"开启赚钱" forState:UIControlStateHighlighted];
                }
                
            }else {
                ShowMessage(message);
            }
            
            [self.scrollView.mj_header endRefreshing];
            
        } failureBlock:^(NSError *err) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.scrollView.mj_header endRefreshing]; //首页基本数据停止刷新
        }];
    }else {
        ShowMessage(@"网络连接不可用 ,请检查您的网络");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.scrollView.mj_header endRefreshing]; //首页基本数据停止刷新

    }
}

/** 请求首页默认显示产品 */
- (void)prepareForDefaultProductInHomePage {

    [self prepareForReommendProductWithMonth:0 updateCoupon:NO];
}

/** 首页产品 */
- (void)prepareForReommendProductWithMonth:(int)month updateCoupon:(BOOL)updateCoupon{
    
    __block int realMonth = 12;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageProductWithMonth:[NSString stringWithFormat:@"%d",month] clientType:@"2" successBlock:^(BOOL result, NSString *message, NSArray<GZProductListModel *> *productListArr) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(result) {
            
           //请求产品成功, "继续赚钱"按钮显示, 视图可以滚动
            self.scrollView.scrollEnabled = YES;
            nextPageBtn.hidden = NO;
            
            if(productListArr.count != 0) {
                
                GZProductListModel *model = [productListArr firstObject];
                assetId = model.assetId;
                productDuration = model.assetDuration.doubleValue;
                assetRepaymentMethod = model.assetRepaymentMethod;
                basicInterest = model.assetRate.doubleValue;
                interestRate = model.assetRate.doubleValue + model.assetInterestRate.doubleValue;
                
                if(month == 0) {
                    
                    [self.circleSlider moveHandleAtIndex:model.assetDuration.intValue];
                    realMonth = model.assetDuration.intValue;
                }else {
                    realMonth = month;
                }
                
                //产品类型
                NSString *type;
                
                if([model.assetRepaymentMethod isEqualToString:@"EqualInstallment"]) {
                    type = @"等额本息";
                    self.repaymentMethod = @"等额本息";
                }else if([model.assetRepaymentMethod isEqualToString:@"MonthlyInterest"]){
                    type = @"按月付息";
                    self.repaymentMethod = @"按月付息";
                }else {
                    type = @"";
                    self.repaymentMethod = @"";
                }
                
                self.productTypeLabel.attributedText = [self getProductTypeStringWithPeriod:model.assetPeriodNum andType:type];
                
                if(monthlyBillingTitleImgView) {
                    //改变titleImgView
                    if([assetRepaymentMethod isEqualToString:@"EqualInstallment"]){
                        [monthlyBillingTitleImgView setImage:[UIImage imageNamed:@"月结本息(元)"]];
                    }else {
                        [monthlyBillingTitleImgView setImage:[UIImage imageNamed:@"月结利息(元)"]];
                    }
                }
                
                //restore产品类型标签布局
                [self.productTypeTagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if(iPhone5) {
                        make.width.mas_equalTo(@45);
                    }else {
                        make.width.mas_equalTo(@63);
                    }
                }];
                
                //产品类型标签
                if([model.guarantyName isEqualToString:@"车险分期"] || [model.guarantyName isEqualToString:@"车保智投"]) {
                    [self.productTypeTagImageView setImage:[UIImage imageNamed:@"车保智投"]];
                    guarantyName = @"车保智投";
                }else if([model.guarantyName isEqualToString:@"车辆抵押"]){
                    [self.productTypeTagImageView setImage:[UIImage imageNamed:@"抵押智投"]];
                    guarantyName = @"抵押智投";
                }else if([model.guarantyName isEqualToString:@"车辆质押"]){
                    [self.productTypeTagImageView setImage:[UIImage imageNamed:@"质押快投"]];
                    guarantyName = @"质押快投";
                }else if([model.guarantyName isEqualToString:@"名品质押"]) {
                    
                    [self.productTypeTagImageView setImage:[UIImage imageNamed:@"质押快投"]];
                    guarantyName = @"质押快投";
                }else if([model.guarantyName isEqualToString:@"分期慧投"]){
                    
                    [self.productTypeTagImageView setImage:[UIImage imageNamed:@"分期慧投"]];
                    guarantyName = @"分期慧投";
                }else {
                    
                    [self.productTypeTagImageView setImage:nil];
                    guarantyName = nil;
                    
                    //不显示产品类型标签
                    [self.productTypeTagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(@0);
                    }];
                }
                
                guarantyStyle = model.guarantyStyle;
                
                //利息率
                self.profitRateLabel.attributedText = [self getFormatProfitRateWithBaseInterest:model.assetRate.stringValue andAdditionalInterest:model.assetInterestRate.stringValue];
                //产品期限
                self.productDurationLabel.attributedText = [self getFormatProductPeriodStr:model.assetDuration.stringValue];
                //产品可购余额
                self.availablePurchaseLabel.text = [self getFormattedAmountOfNumberWithString:model.assetBalance];
                //已购百分比
                [self.progressView setProgress:model.assetSoldPercent.doubleValue/100];
                self.progressPercentLabel.text = [NSString stringWithFormat:@"%.2f%%",model.assetSoldPercent.floatValue];
                //筹集截至时间
                if(model.timeOut && ![model isEqual:[NSNull null]]) {
                    
                    NSArray *separatedStrings = [model.timeOut componentsSeparatedByString:@"/"];
                    self.deadlineLabel.text = [NSString stringWithFormat:@"募集期截至:%@年%@月%@日",separatedStrings[0],separatedStrings[1],separatedStrings[2]];
                }else {
                    self.deadlineLabel.text = @"募集期截至:xxxx年xx月xx日 00:00";
                }
                
                //隐藏"无数据标签",并且显示产品数据和购买页
                self.noProductDataLabel.hidden = YES;
                self.productInfoAndPurchasingBlockView.hidden = NO;
                
            }else {//当月没有产品
                
                realMonth = month;
                
                assetId = @"";
                basicInterest = 0;
                productDuration = 0.0f;
                assetRepaymentMethod = @"";
                guarantyStyle = nil;
                
                //产品类型
                self.productTypeLabel.text = @"";
                //设置产品标签
                self.productTypeTagImageView.image = nil;
                //利息率
                self.profitRateLabel.attributedText = [self getFormatProfitRateWithBaseInterest:@"0" andAdditionalInterest:@"0"];
                //产品期限
                self.productDurationLabel.attributedText = [self getFormatProductPeriodStr:@"0"];
                //产品可购余额
                self.availablePurchaseLabel.text = [self getFormattedAmountOfNumberWithString:@"0"];
                //已购百分比
                [self.progressView setProgress:0];
                self.progressPercentLabel.text = @"0%";
                self.deadlineLabel.text = @"";
                
                if(_purchaseRightNowBlockView) {
                    [self calculatorBtnClick];
                }
                
                //显示"无数据标签",隐藏显示产品数据和购买页
                self.noProductDataLabel.hidden = NO;
                self.productInfoAndPurchasingBlockView.hidden = YES;
            }
            
            
            NSString * fixedInterest = [self getfixInterestMonth:realMonth];
            //利息率(基本利率+加息率)
            self.interestRateLabel.attributedText = [self getInterestRatePercentString:fixedInterest];
            if ((realMonth == 1) ||(realMonth == 3)||(realMonth == 6)||(realMonth == 12)) {
                _interestRateLabel.font = BOLDSYSTEMFONT(30);
            } else {
                
            }
            
            //如果购买区域为展开状态,请求优惠券信息,并且计算收益
            if(_purchaseRightNowBlockView != nil) {
                
                if([assetId isEqualToString:@""]) { //没有产品被选中
                    
                    self.expectedProfitLabel.text = [self getFormattedAmountOfNumberWithString:@"0.00"];
                    self.monthlyBillingLabel.text = [self getFormattedAmountOfNumberWithString:@"0.00"];
                }else {
                    
                    double baseAmount = self.sumInputTextField.text.doubleValue;
                    
                    if([assetRepaymentMethod isEqualToString:@"MonthlyInterest"]) {//按月付息到期还本
                        
                        self.expectedProfitLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",baseAmount*interestRate/100/12*productDuration]];
                        
                        self.monthlyBillingLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",baseAmount*interestRate/100/12]];
                        
                    }else {//等额本息
                        
                        double monthlyInterest = interestRate/100/12;
                        
                        double monthlyPayment = (baseAmount*monthlyInterest*pow(1+monthlyInterest, productDuration))/(pow(1+monthlyInterest, productDuration)-1);
                        
                        self.monthlyBillingLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",monthlyPayment]];
                        
                        self.expectedProfitLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",monthlyPayment*productDuration-baseAmount]];
                    }
                }
            }
            
            if(updateCoupon) {
                //请求首页产品成功,优惠券id清空
                couponId = @"";
                
                if(_purchaseRightNowBlockView) {
                    [self prepareForCouponList];
                }
            }
            
        }else {
            
            //在请求不到产品的情况下, "继续赚钱"按钮隐藏显示,视图无法滚动
            nextPageBtn.hidden = YES;
            self.scrollView.scrollEnabled = NO;
            
            ShowMessage(message);
        }
        
    } failureBlock:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/** 可用余额 */
- (void)prepareForUserAvailableAmount {
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageUserAvailableAmountWithUserId:USER_ID accessToken:AccessToken successBlock:^(BOOL result, NSString *message, NSString *availableAmount) {
        
        if(result){
            
            if(_purchaseRightNowBlockView && USER_ID) {
                //登录状态,则按钮不可点击
                self.accountBalanceBtn.enabled = false;
    
                [self.accountBalanceBtn setTitle:[NSString stringWithFormat:@"账户余额: %@元",[self getFormattedAmountOfNumberWithString:availableAmount]] forState:UIControlStateNormal];
            }
            
        }else {
            ShowMessage(message);
        }
        
    } failureBlock:^(NSError *err) {
        
    }];
}

/** 首页可用优惠券 */
- (void)prepareForCouponList {
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageCouponListWithUserId:USER_ID accessToken:AccessToken assetId:assetId successBlock:^(BOOL result, NSString *message, NSArray<GZCouponModel *> *couponList) {
        
        if(result){
            
            if(_purchaseRightNowBlockView) {
               [self formattedAvailiableCouponWithInt:couponList.count];
            }
            
        }else {
            ShowMessage(message);
            
            if(_purchaseRightNowBlockView) {
                [self formattedAvailiableCouponWithInt:0];
            }
        }
        
    } failureBlock:^(NSError *err) {
        
    }];
}

/** 认购 */
- (void)prepareForPurchasingAssets {
    
    [[GZHomePageRequestManager defaultManager] requestForPurchasingAssetsWithUserId:USER_ID accessToken:AccessToken assetId:assetId  investAmount:self.sumInputTextField.text couponId:couponId source:@"APP" successBlock:^(BOOL status, NSArray *err, NSNumber *interest, NSString *bidResult, NSNumber *investAmount, NSString *storeId) {
        
        if(!err) {
            
            assetBuyRecordId = storeId;
            
            [self.sumInputTextField resignFirstResponder];
            
            [self animationAfterBuy];
        }else {
            
            ShowMessage([err firstObject][@"message"]);
        }
    } failureBlock:^(NSError *err) {
        NSLog(@"error--------%@",err);
    }];
}


/** 检查自动签约状态 */
- (void)checkStatusOfAutoSign {
    
    [[GZHomePageRequestManager defaultManager] requestStatusOfAutoSignWithUserId:USER_ID successBlock:^(NSString *status, NSString *msg) {
        
        if([status isEqualToString:@"0"]) {
            //已签约,检查余额
            [self checkUserAvailableAmountWithSum:self.sumInputTextField.text.doubleValue];
            
        }else if([status isEqualToString:@"1"]) {
            //托管开关未打开
            //[self loadAutomaticalInvestSignReminder];
            ShowMessage(msg);
            
        }else if([status isEqualToString:@"2"]){
            //未签约,弹出提示框
            [self loadAutomaticalInvestSignReminder];
        }
        
    } failureBlock:^(NSError *err,NSString *msg) {
        
        if (err) {
            ShowMessage(@"网络请求失败, 请检查您的网络");
        }
        
        if (msg) {
            ShowMessage(msg);
        }
    }];
}


/** 检查可用余额 **/
- (void)checkUserAvailableAmountWithSum:(double)sum {
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageUserAvailableAmountWithUserId:USER_ID accessToken:AccessToken successBlock:^(BOOL result, NSString *message, NSString *availableAmount) {
        
        if(result){
            
            if(availableAmount.doubleValue >= sum) {
                
                //余额充足,弹出确认窗口
                [self showConfirmationAlert];
                
            }else {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"余额不足,请及时充值" preferredStyle: UIAlertControllerStyleAlert];
                
                UIAlertAction *topUpAction = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
                    chargeVC.title = @"充值";
                    chargeVC.type = @"charge";
                    chargeVC.webUrl = [[DMWebUrlManager manager] getChargeUrl];
                    [self.navigationController pushViewController:chargeVC animated:YES];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                
                [alertController addAction:topUpAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:NO completion:nil];
            }
        }else {
            ShowMessage(message);
        }
        
    } failureBlock:^(NSError *err) {
        
    }];
}


//绑卡信息
- (void)bindBankCardInfoRequest{
    DMSettingManager *settingManager = [DMSettingManager RequestManager];
    [settingManager requestForTieOnCardSuccess:^(BOOL sure) {
        if (sure == YES) {
            //已绑卡, 检测是否签约自动投标
            [self checkStatusOfAutoSign];
            
        }else {
        
            DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:YES];
            open.delegate = self;
            [self.navigationController.tabBarController.view addSubview:open];

        }

    }Faild:^() {
        

    }];
}

#pragma mark ===  购买流程
//是否实名认证
- (void)userIsRealNameRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQIsRealNamesuccessblock:^(NSString *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isEqualToString:@"true"]) {
            //实名认证通过,判断是否绑卡
            [self bindBankCardInfoRequest];
        }else {
            //未实名认证跳转实名认证页面
            DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:NO];
            open.delegate = self;
            [self.navigationController.tabBarController.view addSubview:open];
        }
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)alertShowMessage:(NSString *)string cancelString:(NSString *)cancelString confirmString:(NSString *)confirmString action:(SEL)actionnn{
    
    self.alertViewVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:confirmString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (actionnn) {
            //创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
            NSMethodSignature *sigg = [NSNumber instanceMethodSignatureForSelector:@selector(init)];
            NSInvocation *invocatin = [NSInvocation invocationWithMethodSignature:sigg];
            [invocatin setTarget:self];
            [invocatin setSelector:actionnn];
            [invocatin invoke];
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleCancel handler:nil];
    [self.alertViewVC addAction:cancelAction];
    [self.alertViewVC addAction:libraryAction];
    
    [self.navigationController presentViewController:self.alertViewVC animated:YES completion:^{
        
        
    }];
}

//设置交易密码
- (void)jumpToTradePassWord {
    //    LJQTradePassWordVC *trade = [[LJQTradePassWordVC alloc] init];
    //    [self.navigationController pushViewController:trade animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DMCreditRequestManager manager] replacePassWordSuccess:^(NSString *argument) {
        DMWebViewController *drawCash = [[DMWebViewController alloc] init];
        drawCash.parameter = argument;
        drawCash.webUrl = [[DMWebUrlManager manager] getsumapayUrl];
        [self.navigationController pushViewController:drawCash animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)updateProductData {
    
    if(isBackToHomeFromCoupon) {
        
        if(self.circleSlider.currentIndex == 0) {
            [self prepareForReommendProductWithMonth:12 updateCoupon:NO];
        }else {
            [self prepareForReommendProductWithMonth:self.circleSlider.currentIndex updateCoupon:NO];
        }
        isBackToHomeFromCoupon = NO;
    }else {
        
        if(self.circleSlider.currentIndex == 0) {
            [self prepareForReommendProductWithMonth:12 updateCoupon:YES];
        }else {
            [self prepareForReommendProductWithMonth:self.circleSlider.currentIndex updateCoupon:YES];
        }
    }
}

#pragma mark - Lazy Loading

- (UIImageView *)privateEnjoymentForFreshImgView {
    
    if(!_privateEnjoymentForFreshImgView) {
        _privateEnjoymentForFreshImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新手专享礼"]];
        _privateEnjoymentForFreshImgView.frame = CGRectMake(self.view.frame.size.width-60*DMDeviceWidth/375, self.view.center.y-100, 60*DMDeviceWidth/375, 60*DMDeviceWidth/375);
        //添加滑动手势
        _privateEnjoymentForFreshImgView.userInteractionEnabled = YES;
        _privateEnjoymentForFreshImgView.contentMode = UIViewContentModeScaleAspectFill;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(privateEnjoymentPanAction:)];
        [_privateEnjoymentForFreshImgView addGestureRecognizer:panGesture];
        
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(privateEnjoymentTapAction:)];
        [_privateEnjoymentForFreshImgView addGestureRecognizer:tapGesture];
    }
    return _privateEnjoymentForFreshImgView;
}

//跑马灯指示器
- (GZAnimationIndicator *)indicator {
    
    if(!_indicator) {
        
        //add circleIndicator
        _indicator = [[GZAnimationIndicator alloc]initWithFrame:CGRectMake(0, 36, DMDeviceWidth-38*2, DMDeviceWidth-38*2) circleColor:[UIColor blueColor] dotColor:UIColorFromRGB(0x1a2438) lightedDotColor:UIColorFromRGB(0x50f3c0)];
        
        CGPoint indicatorCenter = CGPointMake(self.view.center.x, self.indicator.center.y);
        self.indicator.center = indicatorCenter;
        [self.scrollContainerView addSubview:self.indicator];
        
        skipToMyAccountBtn = [[UIButton alloc]init];
        [self.scrollContainerView addSubview:skipToMyAccountBtn];
        [skipToMyAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.indicator);
            if(iPhone5) {
                make.top.equalTo(self.indicator).offset(70+7);
            }else {
                make.top.equalTo(self.indicator).offset(70+14);
            }
            make.width.equalTo(@150);
            make.height.equalTo(@25);
        }];
        
        skipToMyAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //区分持有状态和未持有状态
        if(_isOwned) {
            
            NSMutableAttributedString *mutableAttributedStr;
            
            if(iPhone5) {
                
                mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:@"我的资产在" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7)}];
                NSAttributedString *attributedStr = [[NSAttributedString alloc]initWithString:@"跑步 >" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0x51e0a2)}];
                [mutableAttributedStr appendAttributedString:attributedStr];
            }else {
                
                mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:@"我的资产在" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7)}];
                NSAttributedString *attributedStr = [[NSAttributedString alloc]initWithString:@"跑步 >" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:UIColorFromRGB(0x51e0a2)}];
                [mutableAttributedStr appendAttributedString:attributedStr];
            }
            
            [skipToMyAccountBtn setAttributedTitle:mutableAttributedStr forState:UIControlStateNormal];
            [skipToMyAccountBtn setAttributedTitle:mutableAttributedStr forState:UIControlStateHighlighted];
            [skipToMyAccountBtn addTarget:self action:@selector(skipToMyAccountBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
        }else {
            
            NSAttributedString *attributedStr = [[NSAttributedString alloc]initWithString:@"累积交易额(元)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7)}];
            [skipToMyAccountBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
            [skipToMyAccountBtn setAttributedTitle:attributedStr forState:UIControlStateHighlighted];
        }
        
        //create know more button
        knowMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollContainerView addSubview:knowMoreBtn];
        [knowMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.scrollContainerView);
            
            if(iPhone5) {
                make.top.equalTo(self.investTotalAmountLabel.mas_bottom).offset(18);
                make.height.mas_equalTo(@20);
                make.width.mas_equalTo(@70);
            }else {
                make.top.equalTo(self.investTotalAmountLabel.mas_bottom).offset(22);
                make.height.mas_equalTo(@23);
                make.width.mas_equalTo(@89);
            }
        }];
        
        [knowMoreBtn setBackgroundImage:[UIImage imageNamed:@"了解豆蔓"] forState:UIControlStateNormal];
        [knowMoreBtn setBackgroundImage:[UIImage imageNamed:@"了解豆蔓"] forState:UIControlStateHighlighted];
        [knowMoreBtn addTarget:self action:@selector(knowMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //create double arrow
        deepGreenImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"浅绿色-箭头"]];
        deepGreenImgView.alpha = 0.3;
        [self.scrollContainerView addSubview:deepGreenImgView];
        [deepGreenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(knowMoreBtn.mas_bottom).offset(11);
            make.centerX.equalTo(self.scrollContainerView);
            if(iPhone5) {
                make.width.mas_equalTo(@14);
                make.height.mas_equalTo(@12);
            }else {
                make.width.mas_equalTo(@21);
                make.height.mas_equalTo(@18);
            }
        }];
        
        lightGreenImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"深绿色-箭头"]];
        lightGreenImgView.alpha = 0.3;
        [self.scrollContainerView addSubview:lightGreenImgView];
        
        [lightGreenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deepGreenImgView.mas_bottom).offset(-5);
            make.centerX.equalTo(self.scrollView);
            if (iPhone5) {
                make.width.mas_equalTo(11);
                make.height.mas_equalTo(10);
            }else {
                make.width.mas_equalTo(17);
                make.height.mas_equalTo(15);
            }
        }];
    }
    return _indicator;
}

- (UILabel *)investTotalAmountLabel {
    
    if(!_investTotalAmountLabel){
        
        _investTotalAmountLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:_investTotalAmountLabel];
        
        [_investTotalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.scrollContainerView);
            make.centerY.equalTo(self.indicator);
            //屏幕适配
            if(iPhone5) {
                make.height.mas_equalTo(@20);
            }else {
                make.height.mas_equalTo(@30);
            }
        }];
        
        [_investTotalAmountLabel setTextAlignment:NSTextAlignmentCenter];
        
        if(iPhone5) {
            [_investTotalAmountLabel setFont:[UIFont systemFontOfSize:25]];
        }else {
            [_investTotalAmountLabel setFont:[UIFont systemFontOfSize:35]];
        }
        
        [_investTotalAmountLabel setTextColor:UIColorFromRGB(0xffd542)];
    }
    return _investTotalAmountLabel;
}

- (GZCircleSlider *)circleSlider {
    
    if(!_circleSlider) {
        if(iPhone5) {
            
            CGFloat circleViewSide = 200;
            _circleSlider = [[GZCircleSlider alloc]initWithFrame:CGRectMake(0, 0 , circleViewSide, circleViewSide) lineWidth:8 circleColor:UIColorFromRGB(0x2a6ecb) currentIndex:0 andHandleSytle:GZCircleHandleWithGradient];
            _circleSlider.center = CGPointMake(DMDeviceWidth/2, (DMDeviceHeight-64-49)+5+11+11+20+_circleSlider.bounds.size.height/2+20-20);
            _circleSlider.delegate = self;
            [self.scrollContainerView addSubview:_circleSlider];
            
        }else {
            
            CGFloat circleViewSide = 270;
            _circleSlider = [[GZCircleSlider alloc]initWithFrame:CGRectMake(0, 0 , circleViewSide, circleViewSide) lineWidth:10 circleColor:UIColorFromRGB(0x2a6ecb) currentIndex:0 andHandleSytle:GZCircleHandleWithGradient];
            _circleSlider.center = CGPointMake(DMDeviceWidth/2, (DMDeviceHeight-64-49)+11+20+_circleSlider.bounds.size.height/2+20-20);
            _circleSlider.delegate = self;
            [self.scrollContainerView addSubview:_circleSlider];
        }
        [_circleSlider highlightDots];
    }
    return _circleSlider;
}

//年化利率
- (UILabel *)interestRateLabel {
    
    if(!_interestRateLabel) {
        
        _interestRateLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:_interestRateLabel];
        [_interestRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.circleSlider);
        }];
        
        _interestRateLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *interestRateTitleLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:interestRateTitleLabel];
        [interestRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.circleSlider);
            
            if(isShowingSecondSceneOnly) {
                
                if(iPhone5) {
                    make.bottom.equalTo(_interestRateLabel.mas_top);
                }else {
                    make.bottom.equalTo(_interestRateLabel.mas_top).offset(-5);
                }
            }else {
                
                if(iPhone5) {
                    make.top.equalTo(_interestRateLabel.mas_bottom);
                }else {
                    make.top.equalTo(_interestRateLabel.mas_bottom).offset(5);
                }
            }
            make.height.equalTo(@20);
        }];
        [interestRateTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [interestRateTitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:11]];
        [interestRateTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [interestRateTitleLabel setText:@"年化利率"];
        
        if(isShowingSecondSceneOnly) {
            //create product introduction button
            UIButton *productIntroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.scrollContainerView addSubview:productIntroBtn];
            [productIntroBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.circleSlider);
                if(iPhone5) {
                    make.centerY.equalTo(self.circleSlider).offset(40);
                    make.width.mas_equalTo(@50);
                    make.height.mas_equalTo(@15);
                    
                }else {
                    make.centerY.equalTo(self.circleSlider).offset(60);
                    make.width.mas_equalTo(@70);
                    make.height.mas_equalTo(@23);
                }
                
            }];
            [productIntroBtn setBackgroundImage:[UIImage imageNamed:@"产品简介"] forState:UIControlStateNormal];
            [productIntroBtn setBackgroundImage:[UIImage imageNamed:@"产品简介"] forState:UIControlStateHighlighted];
            [productIntroBtn addTarget:self action:@selector(productIntroBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _interestRateLabel;
}

//产品类型容器
- (UIView *)productTypeBlockView {
    
    if(!_productTypeBlockView) {
        
        _productTypeBlockView = [[UIView alloc]init];
        [self.productInfoAndPurchasingBlockView addSubview:_productTypeBlockView];
        [_productTypeBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(iPhone6plus) {
                make.top.equalTo(self.productInfoAndPurchasingBlockView.mas_top);
            }else {
                make.top.equalTo(self.productInfoAndPurchasingBlockView.mas_top);
            }
            make.centerX.equalTo(self.productInfoAndPurchasingBlockView);
            make.left.mas_equalTo(self.productTypeLabel);
            make.right.mas_equalTo(self.productTypeTagImageView);
            make.height.mas_equalTo(@12);
        }];
    }
    return _productTypeBlockView;
}

//产品类型
- (UILabel *)productTypeLabel {
    
    if(!_productTypeLabel) {
        
        _productTypeLabel = [[UILabel alloc]init];
        [self.productTypeBlockView addSubview:_productTypeLabel];
        [_productTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productTypeBlockView);
            make.right.equalTo(self.productTypeTagImageView.mas_left);
            make.height.mas_equalTo(@12);
        }];
        
        _productTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _productTypeLabel;
}

//分类标签
- (UIImageView *)productTypeTagImageView {
    
    if(!_productTypeTagImageView) {
        
        _productTypeTagImageView = [[UIImageView alloc]init];
        [self.productTypeBlockView addSubview:_productTypeTagImageView];
        [_productTypeTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.productTypeBlockView);
            if(iPhone5) {
                
                make.width.mas_equalTo(@45);
                make.height.mas_equalTo(@15);
            }else {
                
                make.width.mas_equalTo(@63);
                make.height.mas_equalTo(@21);
            }
        }];
    }
    return _productTypeTagImageView;
}

//筹标进度
- (GZPurchaseProgressView *)progressView{
    
    if(!_progressView) {
        
        if(iPhone5) {
            _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, 250, 3)];
        }else if(iPhone6) {
            _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, 290, 3)];
        }else {
            _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, 315, 3)];
        }
        
        [self.productInfoAndPurchasingBlockView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productDurationLabel.mas_bottom).offset(20);
            make.left.equalTo(profitRateTitleLabel);
            if(iPhone5) {
                make.width.mas_equalTo(@250);
            }else if(iPhone6) {
                make.width.mas_equalTo(@290);
            }else {
                make.width.mas_equalTo(@315);
            }
            make.height.mas_equalTo(@3);
        }];
        
        _progressPercentLabel = [[UILabel alloc]init];
        [self.productInfoAndPurchasingBlockView addSubview:_progressPercentLabel];
        [_progressPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_progressView);
            make.left.equalTo(_progressView.mas_right).offset(2);
            make.height.mas_equalTo(@20);
        }];
        [_progressPercentLabel setFont:[UIFont systemFontOfSize:12]];
        [_progressPercentLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        
        [self loadBottomButtons];
    }
    return _progressView;
}

- (UILabel *)deadlineLabel {
    
    if (!_deadlineLabel) {
        
        _deadlineLabel = [[UILabel alloc] init];
        [self.productInfoAndPurchasingBlockView addSubview:_deadlineLabel];
        [_deadlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.progressView.mas_bottom).offset(9);
            make.left.equalTo(self.scrollContainerView).offset(35);
            make.height.mas_equalTo(@15);
        }];
        _deadlineLabel.font = [UIFont systemFontOfSize:12];
        _deadlineLabel.textColor = [UIColor cyanColor];
    }
    return _deadlineLabel;
}

//产品信息和购买模块
- (UIView *)productInfoAndPurchasingBlockView {
    
    if(!_productInfoAndPurchasingBlockView) {
        
        _productInfoAndPurchasingBlockView = [[UIView alloc]init];
        [self.scrollContainerView addSubview:_productInfoAndPurchasingBlockView];
        
        [_productInfoAndPurchasingBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(iPhone6plus) {
                make.top.equalTo(self.circleSlider.mas_bottom).offset(50);
            }else {
                make.top.equalTo(self.circleSlider.mas_bottom).offset(40);
            }
            make.left.equalTo(self.scrollContainerView);
            make.right.equalTo(self.scrollContainerView);
            
        }];
    }
    return _productInfoAndPurchasingBlockView;
}

- (UIImageView *)purchaseRightNowBlockView {
    
    if(!_purchaseRightNowBlockView) {
        
        couponId = @"";
        
        _purchaseRightNowBlockView = [[UIImageView alloc]init];
        _purchaseRightNowBlockView.image = [UIImage imageNamed:@"背景"];
        _purchaseRightNowBlockView.layer.masksToBounds = YES;
        _purchaseRightNowBlockView.userInteractionEnabled = YES;
        
        [self.productInfoAndPurchasingBlockView addSubview:_purchaseRightNowBlockView];
        [_purchaseRightNowBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.deadlineLabel.mas_bottom).offset(9);
            make.left.equalTo(self.scrollContainerView).offset(DMDeviceWidth);
            make.width.mas_equalTo(DMDeviceWidth);
        }];
        
        //Make constraints with purchaseBtn
        [purchaseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_purchaseRightNowBlockView.mas_bottom);
            make.centerX.equalTo(self.scrollContainerView);
        }];
        
        //Create deep background view
        //block_3
        CGFloat blockWidth = (DMDeviceWidth-10*2-4)/2;
        CGFloat blockHeight = 80;
        
        UIImageView *block_3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-12"]];
        [_purchaseRightNowBlockView addSubview:block_3];
        [block_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_purchaseRightNowBlockView).offset(10);
            make.top.equalTo(_purchaseRightNowBlockView).offset(9);
            make.height.mas_equalTo(blockHeight);
            make.width.mas_equalTo(blockWidth);
        }];
        block_3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapToSkipBenefitDetailGesture_1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipToBenefitDetailAction)];
        [block_3 addGestureRecognizer:tapToSkipBenefitDetailGesture_1];
        
        UIImageView *expectedProfitTitleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"应收利息(元)"]];
        [block_3 addSubview:expectedProfitTitleImgView];
        [expectedProfitTitleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(block_3).offset(12);
            make.centerX.equalTo(block_3);
            make.width.mas_equalTo(@84);
            make.height.mas_equalTo(@13);
        }];
        
        _expectedProfitLabel = [[UILabel alloc]init];
        [block_3 addSubview:self.expectedProfitLabel];
        [_expectedProfitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(expectedProfitTitleImgView.mas_bottom).offset(18);
            make.centerX.equalTo(block_3);
            make.width.mas_equalTo(@150);
            make.height.mas_equalTo(@25);
        }];
        
        [_expectedProfitLabel setTextAlignment:NSTextAlignmentCenter];
        [_expectedProfitLabel setTextColor:UIColorFromRGB(0x51e0a2)];
        [_expectedProfitLabel setText:[self getFormattedAmountOfNumberWithString:@"0"]];
        
        UIImageView *moreImage3 = [[UIImageView alloc] init];
        moreImage3.image = [[UIImage imageNamed:@"箭头-右"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [block_3 addSubview:moreImage3];
        [block_3 bringSubviewToFront:moreImage3];
        [block_3 addConstrainsWithVisualFormat:@"H:[v0(==13)]-10-|" Views:@[moreImage3]];
        [block_3 addConstrainsWithVisualFormat:@"V:[v0(==13)]" Views:@[moreImage3]];
        [block_3 addConstraintWithSetView:moreImage3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:block_3 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

        
        //block_4
        UIImageView *block_4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-12"]];
        [_purchaseRightNowBlockView addSubview:block_4];
        [block_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_purchaseRightNowBlockView).offset(-10);
            make.top.mas_equalTo(@9);
            make.height.mas_equalTo(blockHeight);
            make.width.mas_equalTo(blockWidth);
        }];
        
        block_4.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapToSkipBenefitDetailGesture_2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipToBenefitDetailAction)];
        [block_4 addGestureRecognizer:tapToSkipBenefitDetailGesture_2];
        
        if([assetRepaymentMethod isEqualToString:@"EqualInstallment"]){
            monthlyBillingTitleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"月结本息(元)"]];
        }else {
            monthlyBillingTitleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"月结利息(元)"]];
        }

        [block_4 addSubview:monthlyBillingTitleImgView];
        [monthlyBillingTitleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(block_4).offset(12);
            make.centerX.equalTo(block_4);
            make.width.mas_equalTo(@87);
            make.height.mas_equalTo(@15);
        }];
        
        _monthlyBillingLabel = [[UILabel alloc]init];
        [block_4 addSubview:self.monthlyBillingLabel];
        [_monthlyBillingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(monthlyBillingTitleImgView.mas_bottom).offset(18);
            make.centerX.equalTo(block_4);
            make.width.mas_equalTo(@150);
            make.height.mas_equalTo(@25);
        }];
        [_monthlyBillingLabel setTextAlignment:NSTextAlignmentCenter];
        [_monthlyBillingLabel setTextColor:UIColorFromRGB(0x51e0a2)];
        [_monthlyBillingLabel setText:[self getFormattedAmountOfNumberWithString:@"0"]];
        
        UIImageView *moreImage4 = [[UIImageView alloc] init];
        moreImage4.image = [[UIImage imageNamed:@"箭头-右"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [block_4 addSubview:moreImage4];
        [block_4 bringSubviewToFront:moreImage4];
        [block_4 addConstrainsWithVisualFormat:@"H:[v0(==13)]-10-|" Views:@[moreImage4]];
        [block_4 addConstrainsWithVisualFormat:@"V:[v0(==13)]" Views:@[moreImage4]];
        [block_4 addConstraintWithSetView:moreImage4 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:block_4 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

        //Create input TextField
        _sumInputTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0) PlaceHoldFont:12 PlaceHoldColor:UIColorFromRGB(0x4b6ca7)];
        [_purchaseRightNowBlockView addSubview: _sumInputTextField];
        [_sumInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(block_3.mas_bottom).offset(10);
            make.left.equalTo(_purchaseRightNowBlockView).offset(12);
            make.right.equalTo(_purchaseRightNowBlockView).offset(-12);
            make.height.mas_equalTo(@48);
        }];
        
        [_sumInputTextField setFont:[UIFont systemFontOfSize:14]];
        [_sumInputTextField setBackground:[UIImage imageNamed:@"输入框"]];
        [_sumInputTextField setTextAlignment:NSTextAlignmentCenter];
        [_sumInputTextField setTextColor:UIColorFromRGB(0x4b6ca7)];
        _sumInputTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入为100元整数倍的金额"];
        _sumInputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _sumInputTextField.delegate = self;
        _sumInputTextField.returnKeyType = UIReturnKeyDone;
        _sumInputTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        //Create use card Label
        UILabel *useCardTitleLabel = [[UILabel alloc]init];
        [_purchaseRightNowBlockView addSubview:useCardTitleLabel];
        [useCardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sumInputTextField.mas_bottom).offset(18);
            make.left.equalTo(self.sumInputTextField).offset(20);
            make.width.mas_equalTo(@60);
            make.height.mas_equalTo(@13);
        }];
        [useCardTitleLabel setFont:[UIFont systemFontOfSize:13]];
        [useCardTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [useCardTitleLabel setText:@"使用卡券"];
        
        searchCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_purchaseRightNowBlockView addSubview:searchCardBtn];
        [searchCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(useCardTitleLabel);
            make.right.equalTo(_purchaseRightNowBlockView).offset(-9);
            make.height.mas_equalTo(@20);
        }];
        [searchCardBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];

        if(AccessToken) {
            
            [searchCardBtn setEnabled:NO];
            [searchCardBtn addTarget:self action:@selector(searchCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }else {
            
            NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@"优惠券登录可见" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7)}];
            
            [searchCardBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
            [searchCardBtn setAttributedTitle:attributedString forState:UIControlStateHighlighted];
            [searchCardBtn addTarget:self action:@selector(searchCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }

        //Create dashline image view
        UIImageView *dashLineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割虚线"]];
        [_purchaseRightNowBlockView addSubview:dashLineImageView];
        [dashLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(useCardTitleLabel.mas_bottom).offset(18);
            make.left.equalTo(_purchaseRightNowBlockView).offset(13);
            make.right.equalTo(_purchaseRightNowBlockView).offset(-13);
            make.height.mas_equalTo(@1);
        }];
        
        //Create account balance title label
        _accountBalanceBtn = [[UIButton alloc]init];
        [_purchaseRightNowBlockView addSubview:_accountBalanceBtn];
        [_accountBalanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dashLineImageView.mas_bottom).offset(18);
            make.left.equalTo(useCardTitleLabel);
            make.height.equalTo(@12);
        }];
        
        [_accountBalanceBtn setTitleColor:UIColorFromRGB(0x4b6ca7) forState:UIControlStateNormal];
        [_accountBalanceBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_accountBalanceBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_accountBalanceBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        
        //Create top up button
        UIButton *topUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_purchaseRightNowBlockView addSubview:topUpBtn];
        [topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_accountBalanceBtn);
            make.right.equalTo(_purchaseRightNowBlockView).offset(-20);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@50);
        }];
        
        NSAttributedString *topUpAttrStr = [[NSAttributedString alloc]initWithString:@"充值" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [topUpBtn setAttributedTitle:topUpAttrStr forState:UIControlStateNormal];
        [topUpBtn setAttributedTitle:topUpAttrStr forState:UIControlStateHighlighted];
        [topUpBtn addTarget:self action:@selector(topUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //Finish blockView Constraints
        [_purchaseRightNowBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_accountBalanceBtn.mas_bottom).offset(18);
        }];
        
        [purchaseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_purchaseRightNowBlockView.mas_bottom).offset(18);
            make.centerX.equalTo(self.scrollContainerView);
            make.width.mas_equalTo(@146);
            make.height.mas_equalTo(@34);
        }];
        
        //Update layout
        [_purchaseRightNowBlockView.superview layoutIfNeeded];
        
        if(USER_ID) {//登录状态请求余额
            self.accountBalanceBtn.enabled = NO;
            [self prepareForUserAvailableAmount];
        }else { //未登录状态显示未登录
            self.accountBalanceBtn.enabled = YES;
            [self.accountBalanceBtn setTitle:@"未登录" forState:UIControlStateNormal];
        }

        //请求可用优惠券
        [self prepareForCouponList];
    }
    return _purchaseRightNowBlockView;
}

- (UILabel *)noProductDataLabel {
    
    if(!_noProductDataLabel) {
        
        _noProductDataLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:_noProductDataLabel];
        [_noProductDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(iPhone6plus) {
                make.top.equalTo(self.circleSlider.mas_bottom).offset(50);
            }else {
                make.top.equalTo(self.circleSlider.mas_bottom).offset(40);
            }
            make.left.equalTo(self.scrollContainerView);
            make.right.equalTo(self.scrollContainerView);
            
            if(iPhone5) {
                make.bottom.equalTo(self.scrollContainerView).offset(-100);
            }else {
                make.bottom.equalTo(self.scrollContainerView);
            }
        }];
        
        [_noProductDataLabel setTextAlignment:NSTextAlignmentCenter];
        [_noProductDataLabel setText:@"当前期限暂无产品 敬请期待"];
        [_noProductDataLabel setFont:[UIFont systemFontOfSize:15]];
        [_noProductDataLabel setTextColor:UIColorFromRGB(0x51e0a2)];
    }
    return _noProductDataLabel;
}


#pragma mark - Global layout

-(void)createSlideMenu {
    
    self.DMSlideMenuView = [[DMSlideMenuView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth * 0.75, [[UIScreen mainScreen] bounds].size.height)];
    
    self.DMSlideMenuView.customDelegate = self;
    
    self.menu = [[DMSlideMenu alloc] initWithDependencyView:self.view MenuView:self.DMSlideMenuView tabarView:self.tabBarController.view isShowCoverView:YES];
}

- (void)createNav {
    
    _slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _slideBtn.frame = CGRectMake(0, 0, 36/2, 29/2);
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"侧边栏按钮"] forState:UIControlStateNormal];
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"侧边栏按钮"] forState:UIControlStateHighlighted];
    [_slideBtn addTarget: self action:@selector(slideClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareAction:(UIBarButtonItem *)item{
    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = @"投资满额送好礼";
    chargeVC.webUrl = [[DMWebUrlManager manager] getActivityUrl];
    [self.navigationController pushViewController:chargeVC animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"openactivity"];
}

- (void)createScrollContainer {
    
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(DMDeviceWidth,DMDeviceHeight-49);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView setDelaysContentTouches:NO];
    //添加下拉刷新
    __weak typeof(self) weakSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf prepareForBasicElement];
    }];
    
    _scrollContainerView = [[UIView alloc]init];
    [self.scrollView addSubview:self.scrollContainerView];
    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.scrollView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
    }];
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSpaceToResignFirstResponderAction:)];
    [_scrollContainerView addGestureRecognizer:tap];

}

- (void)loadLoginAlertViewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        DMRegisterViewController *rvc = [[DMRegisterViewController alloc]init];
        rvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rvc animated:YES];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DMLoginViewController *lvc = [[DMLoginViewController alloc]init];
        lvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lvc animated:YES];
    }];
    [alertController addAction:registerAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadAutomaticalInvestSignReminder {
 
    [GZInvestSignReminderView showPopviewToView:self.view];
    [GZInvestSignReminderView setDelegateOfSingletonWith:self];
}

#pragma mark - 新手专享

- (void)loadPrivateEnjoymentForFreshScene {
    DMNewHandView *newHandView = [[DMNewHandView alloc] initWithFrame:DMDeviceFrame];
    [[UIApplication sharedApplication].keyWindow addSubview:newHandView];
    newHandView.registerBlock = ^{
        DMRegisterViewController *rvc = [[DMRegisterViewController alloc]init];
        [self.navigationController pushViewController:rvc animated:YES];
    };
    
    newHandView.detailBlock = ^{
        [self getWebViewWithUrl:[[DMWebUrlManager manager] getActivityUrl] Title:@"投资满额送好礼" Type:@""];
    };
    
    newHandView.closeBlock = ^{
        [self.scrollContainerView addSubview:self.privateEnjoymentForFreshImgView];
    };
}

#pragma mark - 首页一屏
- (void)prepareForDashboardBlocks {
    
    if(_isOwned) {
        
        //create block_1 imageView
        // CGFloat titleWidth = 97.5;
        CGFloat titleHeight = 13.5;
        
        CGFloat blockWidth = (DMDeviceWidth-3-10*2)/2;
        CGFloat blockHeight = 14+18+12+titleHeight+25;
        
        block_1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-12"]];
        [self.scrollContainerView addSubview:block_1];
        [block_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.indicator.mas_bottom).offset(35-10);
            make.left.equalTo(self.scrollContainerView).offset(10);
            make.width.mas_equalTo(blockWidth);
            make.height.mas_equalTo(blockHeight);
        }];
        
        UIImageView *accumulatedImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"累计交易人次"]];
        [block_1 addSubview:accumulatedImgView];
        [accumulatedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(block_1);
            make.top.equalTo(block_1).offset(14);
            make.width.mas_equalTo(97.5);
            make.height.mas_equalTo(13.5);
        }];
        
        _accumulatedLabel = [[UILabel alloc]init];
        [block_1 addSubview:self.accumulatedLabel];
        [self.accumulatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accumulatedImgView.mas_bottom).offset(18);
            make.centerX.equalTo(block_1);
            make.width.mas_equalTo(block_1.mas_width);
            make.height.mas_equalTo(block_1.bounds.size.height-14-18-12-accumulatedImgView.frame.size.height);
        }];
        
        self.accumulatedLabel.textAlignment = NSTextAlignmentCenter;
        self.accumulatedLabel.textColor = UIColorFromRGB(0x86a7e8);
        
        if(iPhone5) {
            self.accumulatedLabel.font = [UIFont systemFontOfSize:17];
        }else {
            self.accumulatedLabel.font = [UIFont systemFontOfSize:19];
        }
        
        //create block_2
        UIImageView *block_2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-12"]];
        [self.scrollContainerView addSubview:block_2];
        [block_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.indicator.mas_bottom).offset(35-10);
            make.right.equalTo(self.scrollContainerView).offset(-10);
            make.width.mas_equalTo(blockWidth);
            make.height.mas_equalTo(blockHeight);
        }];
        
        UIImageView *transacitonAmountImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"累计交易金额(元)"]];
        [block_2 addSubview:transacitonAmountImgView];
        [transacitonAmountImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(block_2);
            make.top.equalTo(block_1).offset(14);
            make.width.mas_equalTo(112);
            make.height.mas_equalTo(14);
        }];
        
        _transacitonAmountLabel = [[UILabel alloc]init];
        [block_2 addSubview:self.transacitonAmountLabel];
        [self.transacitonAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(transacitonAmountImgView.mas_bottom).offset(18);
            make.centerX.equalTo(block_2);
            make.width.mas_equalTo(block_2.mas_width);
            make.height.mas_equalTo(block_1.bounds.size.height-14-18-12-transacitonAmountImgView.frame.size.height);
        }];
        self.transacitonAmountLabel.textAlignment = NSTextAlignmentCenter;
        self.transacitonAmountLabel.textColor = UIColorFromRGB(0x86a7e8);
        if (iPhone5) {
            self.transacitonAmountLabel.font = [UIFont systemFontOfSize:17];
        }else {
            self.transacitonAmountLabel.font = [UIFont systemFontOfSize:19];
        }
    }else {
        
        UILabel *accumulatedTitleLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:accumulatedTitleLabel];
        [accumulatedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.scrollContainerView.mas_centerX);
            make.top.equalTo(self.indicator.mas_bottom).offset(45);
            make.height.mas_equalTo(@20);
        }];
        [accumulatedTitleLabel setTextAlignment:NSTextAlignmentRight];
        [accumulatedTitleLabel setFont:[UIFont systemFontOfSize:13]];
        [accumulatedTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [accumulatedTitleLabel setText:@"累积交易人次:"];
        
        _accumulatedLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:_accumulatedLabel];
        [_accumulatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollContainerView.mas_centerX).offset(5);
            make.centerY.equalTo(accumulatedTitleLabel);
            make.height.mas_equalTo(@20);
        }];
        [_accumulatedLabel setTextColor:UIColorFromRGB(0x86a7e8)];
        [_accumulatedLabel setTextAlignment:NSTextAlignmentLeft];
        [_accumulatedLabel setFont:[UIFont systemFontOfSize:19]];
    }
}

- (void)prepareForNextPageBtn {
    
    nextPageBtn = [[GZCustomStyleButton alloc] initWithFrame:CGRectMake(0, 0, 61, 36)];
    [nextPageBtn setImageRect:CGRectMake(24, 21, 13, 15)];
    [nextPageBtn setTitleRect:CGRectMake(0, 0, 61, 21)];
    
    nextPageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [nextPageBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [nextPageBtn setTitleColor:UIColorFromRGB(0x86a7e8) forState:UIControlStateNormal];
    [nextPageBtn setTitleColor:UIColorFromRGB(0x86a7e8) forState:UIControlStateHighlighted];
    
    [nextPageBtn setImage:[UIImage imageNamed:@"next_page"] forState:UIControlStateNormal];
    [nextPageBtn setImage:[UIImage imageNamed:@"next_page"] forState:UIControlStateHighlighted];
    [nextPageBtn setTitle:@"开启赚钱" forState:UIControlStateNormal];
    [nextPageBtn setTitle:@"开启赚钱" forState:UIControlStateHighlighted];
    
    nextPageBtn.adjustsImageWhenHighlighted = NO;
    [self.scrollContainerView addSubview:nextPageBtn];
    [nextPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(iPhone5) {
            make.top.equalTo(self.scrollContainerView).offset(DMDeviceHeight-50-49-64);
        }else {
            make.top.equalTo(self.scrollContainerView).offset(DMDeviceHeight-50-49-64-15);
        }
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(36);
    }];
    
    [nextPageBtn addTarget:self action:@selector(nextPageAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 首页二屏
- (void)loadTopButtonsWithConditionOfShowingProductionIntroAndBackBtn:(BOOL)isShown {
    
    searchPastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollContainerView addSubview:searchPastBtn];
    [searchPastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollContainerView).offset(DMDeviceHeight-49-64+11);
        make.left.equalTo(self.scrollContainerView).offset(19);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@23);
    }];
    
    [searchPastBtn setBackgroundImage:[UIImage imageNamed:@"查看往期"] forState:UIControlStateNormal];
    [searchPastBtn setBackgroundImage:[UIImage imageNamed:@"查看往期"] forState:UIControlStateHighlighted];
    [searchPastBtn addTarget:self action:@selector(searchPastBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(isShown) {
        
        //create product introduction button
        UIButton *productIntroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollContainerView addSubview:productIntroBtn];
        [productIntroBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.scrollContainerView).offset(-19);
            make.centerY.equalTo(searchPastBtn);
            make.width.mas_equalTo(@70);
            make.height.mas_equalTo(@23);
        }];
        [productIntroBtn setBackgroundImage:[UIImage imageNamed:@"产品简介"] forState:UIControlStateNormal];
        [productIntroBtn setBackgroundImage:[UIImage imageNamed:@"产品简介"] forState:UIControlStateHighlighted];
        [productIntroBtn addTarget:self action:@selector(productIntroBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //create backToPreviousPage Button
        backToPreviousPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollContainerView addSubview:backToPreviousPageBtn];
        [backToPreviousPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(searchPastBtn);
            make.centerX.equalTo(self.scrollContainerView);
            make.width.mas_equalTo(@12);
            make.height.mas_equalTo(@13);
        }];
        [backToPreviousPageBtn setBackgroundImage:[UIImage imageNamed:@"箭头-向上"] forState:UIControlStateNormal];
        [backToPreviousPageBtn setBackgroundImage:[UIImage imageNamed:@"箭头-向上"] forState:UIControlStateHighlighted];
        [backToPreviousPageBtn addTarget:self action:@selector(backToPreviousPageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
        
        UIButton *knowMeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollContainerView addSubview:knowMeBtn];
        [knowMeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.scrollContainerView).offset(-19);
            make.centerY.equalTo(searchPastBtn);
            make.width.mas_equalTo(@90);
            make.height.mas_equalTo(@23);
        }];
        [knowMeBtn setBackgroundImage:[UIImage imageNamed:@"了解豆蔓"] forState:UIControlStateNormal];
        [knowMeBtn setBackgroundImage:[UIImage imageNamed:@"了解豆蔓"] forState:UIControlStateHighlighted];
        [knowMeBtn addTarget:self action:@selector(knowMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)loadSeparatedRegion {
    
    //top separator line
    separatorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-首页"]];
    [self.productInfoAndPurchasingBlockView addSubview:separatorImgView];
    [separatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(iPhone6plus) {
            make.top.equalTo(self.productTypeBlockView.mas_bottom).offset(17);
        }else {
            make.top.equalTo(self.productTypeBlockView.mas_bottom).offset(12);
        }
        make.centerX.equalTo(self.productInfoAndPurchasingBlockView);
        make.width.mas_equalTo(@334);
        make.height.mas_equalTo(@12);
    }];
    
    //create calculator button
    calculatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.productInfoAndPurchasingBlockView addSubview:calculatorBtn];
    [calculatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(separatorImgView.mas_top).offset(-5);
        if(iPhone5) {
            make.right.equalTo(self.productInfoAndPurchasingBlockView.mas_right).offset(-15);
        }else {
            make.right.equalTo(self.productInfoAndPurchasingBlockView.mas_right).offset(-22);
        }
        make.width.mas_equalTo(@28);
        make.height.mas_equalTo(@28);
    }];
    [calculatorBtn setBackgroundImage:[UIImage imageNamed:@"计算器"] forState:UIControlStateNormal];
    [calculatorBtn setBackgroundImage:[UIImage imageNamed:@"计算器"] forState:UIControlStateHighlighted];
    [calculatorBtn addTarget:self action:@selector(calculatorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //vertical separator line
    leftVerticalSeparatorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
    [self.productInfoAndPurchasingBlockView addSubview:leftVerticalSeparatorImgView];
    [leftVerticalSeparatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorImgView.mas_bottom).offset(17);
        make.left.equalTo(self.productInfoAndPurchasingBlockView).offset(DMDeviceWidth/3);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@35);
    }];
    
    rightVerticalSeparatorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
    [self.productInfoAndPurchasingBlockView addSubview:rightVerticalSeparatorImgView];
    [rightVerticalSeparatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorImgView.mas_bottom).offset(17);
        make.right.equalTo(self.productInfoAndPurchasingBlockView).offset(-DMDeviceWidth/3);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@35);
    }];
    
    //profitRate
    profitRateTitleLabel = [[UILabel alloc]init];
    [self.productInfoAndPurchasingBlockView addSubview:profitRateTitleLabel];
    [profitRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftVerticalSeparatorImgView);
        make.centerX.equalTo(self.productInfoAndPurchasingBlockView).offset(-DMDeviceWidth/3);
        make.height.mas_equalTo(@13);
    }];
    [profitRateTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [profitRateTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [profitRateTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    [profitRateTitleLabel setText:@"年化利率"];
    
    _profitRateLabel = [[UILabel alloc]init];
    [self.productInfoAndPurchasingBlockView addSubview:self.profitRateLabel];
    [self.profitRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(profitRateTitleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.productInfoAndPurchasingBlockView.mas_left).offset(DMDeviceWidth/6);
        make.height.mas_equalTo(@25);
    }];
    [self.profitRateLabel setTextAlignment:NSTextAlignmentCenter];
    
    //duration of product
    UILabel *productDurationTitleLabel =  [[UILabel alloc]init];
    [self.productInfoAndPurchasingBlockView addSubview:productDurationTitleLabel];
    [productDurationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftVerticalSeparatorImgView);
        make.centerX.equalTo(self.productInfoAndPurchasingBlockView);
        make.height.mas_equalTo(@13);
    }];
    [productDurationTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [productDurationTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [productDurationTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    [productDurationTitleLabel setText:@"借款期限"];
    
    _productDurationLabel = [[UILabel alloc]init];
    [self.productInfoAndPurchasingBlockView addSubview:self.productDurationLabel];
    [self.productDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productDurationTitleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(productDurationTitleLabel);
        make.height.mas_equalTo(@25);
    }];
    [self.productDurationLabel setTextAlignment:NSTextAlignmentCenter];
    
    //availablePurchase purchase
    UILabel *availablePurchaseTitleLabel = [[UILabel alloc]init];
    [self.productInfoAndPurchasingBlockView addSubview:availablePurchaseTitleLabel];
    [availablePurchaseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightVerticalSeparatorImgView);
        make.centerX.equalTo(self.productInfoAndPurchasingBlockView).offset(DMDeviceWidth/3);
        make.height.mas_equalTo(@13);
    }];
    [availablePurchaseTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [availablePurchaseTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [availablePurchaseTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    [availablePurchaseTitleLabel setText:@"剩余可购(元)"];
    
    _availablePurchaseLabel = [[UILabel alloc]init];
    [self.productInfoAndPurchasingBlockView addSubview:self.availablePurchaseLabel];
    [self.availablePurchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.productDurationLabel);
        make.centerX.equalTo(self.productInfoAndPurchasingBlockView.mas_right).offset(-DMDeviceWidth/6);
        make.height.mas_equalTo(@17);
    }];
    [self.availablePurchaseLabel setTextAlignment:NSTextAlignmentCenter];
    [self.availablePurchaseLabel setFont:[UIFont systemFontOfSize:17]];
    [self.availablePurchaseLabel setTextColor:UIColorFromRGB(0xffd542)];
}

- (void)loadBottomButtons {
    //立即认购
    purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.productInfoAndPurchasingBlockView addSubview:purchaseBtn];
    [purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deadlineLabel.mas_bottom).offset(16);
        make.centerX.equalTo(self.productInfoAndPurchasingBlockView);
        make.width.mas_equalTo(@146);
        make.height.mas_equalTo(@34);
    }];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"立即认购"] forState:UIControlStateNormal];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"立即认购"] forState:UIControlStateHighlighted];
    [purchaseBtn addTarget:self action:@selector(purchaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //本期债权
    currentCreditorRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.productInfoAndPurchasingBlockView addSubview:currentCreditorRightBtn];
    [currentCreditorRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(purchaseBtn);
        if(iPhone5) {
            make.right.equalTo(purchaseBtn.mas_left).offset(-8);
        }else if(iPhone6) {
            make.right.equalTo(purchaseBtn.mas_left).offset(-15);
        }else {
            make.right.equalTo(purchaseBtn.mas_left).offset(-25);
        }
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@23);
    }];
    [currentCreditorRightBtn setBackgroundImage:[UIImage imageNamed:@"本期债权"] forState:UIControlStateNormal];
    [currentCreditorRightBtn setBackgroundImage:[UIImage imageNamed:@"本期债权"] forState:UIControlStateHighlighted];
    [currentCreditorRightBtn addTarget:self action:@selector(currentCreditorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //认购列表
    purchasedListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.productInfoAndPurchasingBlockView addSubview:purchasedListBtn];
    [purchasedListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(purchaseBtn);
        if(iPhone5) {
            make.left.equalTo(purchaseBtn.mas_right).offset(8);
        }else if(iPhone6) {
            make.left.equalTo(purchaseBtn.mas_right).offset(15);
        }else {
            make.left.equalTo(purchaseBtn.mas_right).offset(25);
        }
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@23);
    }];
    [purchasedListBtn setBackgroundImage:[UIImage imageNamed:@"认购列表"] forState:UIControlStateNormal];
    [purchasedListBtn setBackgroundImage:[UIImage imageNamed:@"认购列表"] forState:UIControlStateHighlighted];
    [purchasedListBtn addTarget:self action:@selector(purchasedListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //提示消息
    reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth-70, 24)];
    [self.productInfoAndPurchasingBlockView addSubview:reminderLabel];
    [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(purchaseBtn.mas_bottom).offset(10);
        make.left.equalTo(self.productInfoAndPurchasingBlockView).offset(35);
        make.right.equalTo(self.productInfoAndPurchasingBlockView).offset(-35);
    }];
    reminderLabel.enabledTapEffect = NO;
    reminderLabel.numberOfLines = 0;
    
    [self.productInfoAndPurchasingBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(reminderLabel.mas_bottom).offset(30);
    }];
    
    if(iPhone6plus) {
        [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((DMDeviceHeight-49-64)*2+24);
        }];
    }else if(iPhone6){
        [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((DMDeviceHeight-49-64)*2+15+24);
        }];
    }else {
        [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.productInfoAndPurchasingBlockView.mas_bottom);
        }];
    }
    
    //底部风险提示标签
    reminderFooterLabel = [[UILabel alloc] init];
    [self.scrollView addSubview:reminderFooterLabel];
    [reminderFooterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.scrollView);
        make.top.equalTo(_scrollContainerView.mas_bottom);
    }];

    reminderFooterLabel.textAlignment = NSTextAlignmentCenter;
    reminderFooterLabel.font = [UIFont systemFontOfSize:13];
    reminderFooterLabel.textColor = UIColorFromRGB(0x4b6ca7);
    reminderFooterLabel.text = @"市场有风险，投资需谨慎";
    
    //将新手专享图标置于ContainerView顶层
    [self.scrollContainerView bringSubviewToFront:self.privateEnjoymentForFreshImgView];
    
    //views全部加载完成,置标志位
      isDidLoadViews = YES;
    
    //展开购买页
    LJQHomeManager *manager = [LJQHomeManager shareHomeManager];
    
    if(manager.isOpen == 1) {
        
        if(!self.productInfoAndPurchasingBlockView.hidden) {
            [self calculatorBtnClick];
        }
        manager.isOpen = 0;
    }
}

#pragma mark - Timer Selector
- (void)iconAnimation {
    
    [deepGreenImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(knowMoreBtn.mas_bottom).offset(2);
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        [deepGreenImgView.superview layoutIfNeeded];
        deepGreenImgView.alpha = 1.0;
        lightGreenImgView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [deepGreenImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(knowMoreBtn.mas_bottom).offset(11);
        }];
        
        [UIView animateWithDuration:1 animations:^{
            
            [deepGreenImgView.superview layoutIfNeeded];
            deepGreenImgView.alpha = 0.3;
            lightGreenImgView.alpha = 0.3;
        }];
    }];
}

#pragma mark - Guesture action

//拖动新手专享
- (void)privateEnjoymentPanAction:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint currentPoint = [panGesture locationInView:self.scrollContainerView];
    
    if(panGesture.state == UIGestureRecognizerStateChanged) {
        
        self.privateEnjoymentForFreshImgView.center = currentPoint;
        
    }else if(panGesture.state == UIGestureRecognizerStateEnded) {
        
        self.privateEnjoymentForFreshImgView.center = currentPoint;
    }
}

//点击新手专享
- (void)privateEnjoymentTapAction:(UIPanGestureRecognizer *)tapGesture {
    [self getWebViewWithUrl:[[DMWebUrlManager manager] newHang] Title:@"新手专享" Type:@"new"];
}

- (void)tapSpaceToResignFirstResponderAction:(UITapGestureRecognizer *)tap {
    
    [self.sumInputTextField resignFirstResponder];
}

//跳转收益详情页
- (void)skipToBenefitDetailAction {
    
    if (self.sumInputTextField.text == nil || [self.sumInputTextField.text isEqualToString:@""]) {
        ShowMessage(@"请输入投资金额");
    }else {
        
        DMCalculateViewController *calVC = [[DMCalculateViewController alloc] init];
        calVC.hidesBottomBarWhenPushed = YES;
        
        calVC.type = self.repaymentMethod;
        calVC.investAmount = self.sumInputTextField.text;
        if(self.circleSlider.currentIndex == 0) {
            calVC.month = 12;
        }else {
            calVC.month = self.circleSlider.currentIndex;
        }
        calVC.rate = [NSString stringWithFormat:@"%f",interestRate];
        [self.navigationController pushViewController:calVC animated:YES];
    }
}

#pragma mark - Button click action

-(void)slideClick:(id)sender {
    
    [self.menu show];
}


//点击我的资产在跑步,跳转账户
- (void)skipToMyAccountBtnClick {
    
    [self.navigationController.tabBarController setSelectedIndex:3];
}

//点击"了解豆蔓"
- (void)knowMoreBtnClick {
    
    [self getWebViewWithUrl:[[DMWebUrlManager manager] getAboutUs] Title:@"关于我们" Type:@"model"];
}

//点击"我要理财"
- (void)nextPageAction {
    [UIView animateWithDuration:1.0 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, DMDeviceHeight-64-49);
    }];
}

//点击向上按钮
- (void)backToPreviousPageBtnClick {
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

//点击"查看往期列表"
- (void)searchPastBtnClick {
    
    GZReviewedListViewController *rlvc = [[GZReviewedListViewController alloc]init];
    [rlvc.navigationItem setTitle:@"往期列表"];
    rlvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rlvc animated:YES];
}

//点击产品简介
- (void)productIntroBtnClick {
    
    if(![assetId isEqualToString:@""]) {
        
        LJQProductIntroductionvc *pivc = [[LJQProductIntroductionvc alloc]init];
        pivc.assetRate = basicInterest;
        pivc.assetDuration = productDuration;
        
        if([assetRepaymentMethod isEqualToString:@"EqualInstallment"]) {
            pivc.assetRepaymentMethod = 0;
        }else if([assetRepaymentMethod isEqualToString:@"MonthlyInterest"]){
            pivc.assetRepaymentMethod = 1;
        }else {
            pivc.assetRepaymentMethod = -1;
        }
        
        [pivc.navigationItem setTitle:@"产品简介"];
        pivc.hidesBottomBarWhenPushed = YES;
        pivc.guarantyName = guarantyName;
        [self.navigationController pushViewController:pivc animated:YES];
        
    }else {
        ShowMessage(@"请先选择产品");
    }
}

//点击"本期债权"
- (void)currentCreditorBtnClick {
    
    if(![assetId isEqualToString:@""]) {
        
        DMCurrentClaimsViewController *ccvc = [[DMCurrentClaimsViewController alloc]init];
        ccvc.assetId = assetId;
        ccvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ccvc animated:YES];
    }else {
        ShowMessage(@"请先选择产品");
    }
}

//登录
- (void)loginAction {
    
    DMLoginViewController *loginVC = [[DMLoginViewController alloc]init];
    
    [self.navigationController pushViewController:loginVC animated:YES];
}

//点击"可用优惠券"
- (void)searchCardBtnClick {
    
    if(AccessToken) {
        
        if(![assetId isEqualToString:@""]) {
            
            GZCouponsViewController *cvc = [[GZCouponsViewController alloc]init];
            cvc.assetId = assetId;
            cvc.delegate = self;
            cvc.navigationItem.title = @"选择卡券";
            isBackToHomeFromCoupon = YES;
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }else {
     
        DMLoginViewController *loginVC = [[DMLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}

//点击"充值"按钮
- (void)topUpBtnClick {
    if(AccessToken) {
        [self althoruserIsRealNameRequest];
    }else {
        [self loadLoginAlertViewController];
    }
}

#pragma mark 充值流程
//是否实名认证
- (void)althoruserIsRealNameRequest{
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager LJQIsRealNamesuccessblock:^(NSString *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isEqualToString:@"true"]) {
            //实名认证通过,判断是否绑卡
            [self MineBankCardInfoRequest];
        }else {
            //未实名认证
            //跳转实名认证页面
            DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:NO];
            open.delegate = self;
            [self.navigationController.tabBarController.view addSubview:open];
        }
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


//银行卡信息
- (void)MineBankCardInfoRequest{
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQ_MineBankCardInfoSuccessBlock:^{
        //充值
        DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
        chargeVC.title = @"充值";
        chargeVC.type = @"charge";
        chargeVC.webUrl = [[DMWebUrlManager manager] getChargeUrl];
        [self.navigationController pushViewController:chargeVC animated:YES];
    } faild:^{
        DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:YES];
        open.delegate = self;
        [self.navigationController.tabBarController.view addSubview:open];
    }];
}


//点击"认购列表"
- (void)purchasedListBtnClick {
    
    if(![assetId isEqualToString:@""]) {
        
        LJQBuyListVC *blvc = [[LJQBuyListVC alloc]init];
        blvc.assetId = assetId;
        [blvc.navigationItem setTitle:@"认购列表"];
        blvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:blvc animated:YES];
    }else {
        
        ShowMessage(@"请先选择产品");
    }
}

//点击立即购买
- (void)purchaseBtnClick {

    if(!_purchaseRightNowBlockView) {
        
        [self.purchaseRightNowBlockView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollContainerView).offset(0);
        }];
        
        [self.purchaseRightNowBlockView.superview setNeedsUpdateConstraints];
        [self.purchaseRightNowBlockView.superview updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:1.0f animations:^{
            
            [self.purchaseRightNowBlockView.superview layoutIfNeeded];
        }];
        
        [self.scrollContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView).insets(UIEdgeInsetsZero);
            make.width.equalTo(self.scrollView);
            make.bottom.equalTo(reminderLabel.mas_bottom).offset(15);
        }];
        
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height);
        
        [self showProtocolAndReminderLabel:YES];
        
    }else {
        
        //输入框放弃第一响应者
        [self.sumInputTextField resignFirstResponder];
        
        if([assetId isEqualToString:@""]) {
            
            ShowMessage(@"请先选择产品");
        }else {
            
            //判断输入框
            if(AccessToken) {
                //登录状态, 验证实名信息
                [self userIsRealNameRequest];

            }else {
                //未登录,提示用户登录
                [self loadLoginAlertViewController];
            }
        }
    }
}

//点击计算器
- (void)calculatorBtnClick {
    
    if(!_purchaseRightNowBlockView) {
        
        //购买页面创建时,优惠券id清空
        couponId = @"";
        
        [self.purchaseRightNowBlockView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollContainerView).offset(0);
        }];
        
        [self.purchaseRightNowBlockView.superview setNeedsUpdateConstraints];
        [self.purchaseRightNowBlockView.superview updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:1.0f animations:^{
            
            [self.purchaseRightNowBlockView.superview layoutIfNeeded];
        }];
        
        [self.scrollContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView).insets(UIEdgeInsetsZero);
            make.width.equalTo(self.scrollView);
            make.bottom.equalTo(reminderLabel.mas_bottom).offset(15);
        }];

        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height);
        
        //显示协议和风险提示
        [self showProtocolAndReminderLabel:YES];
        
    }else {
        
        [self.scrollContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView).insets(UIEdgeInsetsZero);
            make.width.equalTo(self.scrollView);
            make.height.mas_equalTo((DMDeviceHeight-49-64)*2+15+25);
        }];
        
        [purchaseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.deadlineLabel.mas_bottom).offset(18);
            make.centerX.equalTo(self.scrollContainerView);
            make.width.mas_equalTo(@146);
            make.height.mas_equalTo(@34);
        }];
        
        self.scrollView.contentOffset = CGPointMake(0,DMDeviceHeight-64-49);
        
        [self.purchaseRightNowBlockView removeFromSuperview];
        _purchaseRightNowBlockView = nil;
        
        //购买模块收起, 优惠券id记录清空
        couponId = @"";
        
        //隐藏协议和风险提示
        [self showProtocolAndReminderLabel:NO];
    }
}

#pragma mark - GZCircleSliderDelegate

- (void)circleSliderChangeToIndex:(int)index {
    
    [self prepareForReommendProductWithMonth:index updateCoupon:YES];
}

#pragma mark - GZInvestSignSkipDelegate

- (void)skipToDetailOfInvestSign {
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.title = @"自动投标签约";
    webVC.webUrl = [[DMWebUrlManager manager] getAutoMakeABid];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)skipToAutoSignAuthProtocol {
    
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.webUrl = [[DMWebUrlManager manager] getAutoSignAuthProtocolUrl];
    webVC.navigationItem.title = @"自动投标授权";
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - LJQCouponCellDelegate
- (void)updateUserInterfaceWithCouponModel:(LJQCouponsModel *)model {
    
    if([model.type isEqualToString:@"REBATE"]) {
        
        NSAttributedString *searchCardAttrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@返%@",model.minimumInvest,model.parValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateNormal];
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateHighlighted];
        
        if(model.couponId) {
            couponId = model.couponId;
        }
        
    }else if([model.type isEqualToString:@"INTEREST"]){
        
        NSAttributedString *searchCardAttrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"加息%@%%",model.parValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateNormal];
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateHighlighted];
        
        if(model.couponId) {
            couponId = model.couponId;
        }
    }
}

- (void)cancelCouponSelection {
    
    //优惠券id清空
    couponId = @"";
    //重新获取优惠券个数
    [self prepareForCouponList];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(isShowingSecondSceneOnly) {
        
        self.scrollView.pagingEnabled = NO; //不显示第一屏时禁止翻页
        
        if(scrollView.contentOffset.y<DMDeviceHeight-64-49) {
            scrollView.contentOffset = CGPointMake(0, DMDeviceHeight-64-49);
        }
        
    }else {
        
        if(scrollView.contentOffset.y>DMDeviceHeight-64-49) {
            self.scrollView.pagingEnabled = NO;
        }else {
            self.scrollView.pagingEnabled = YES;
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if(isShowingKeyboard) {
        [self.sumInputTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.sumInputTextField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.view.frame = originRect;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark - CAAnimation Delegate

- (void)animationAfterBuy {
    
    comfirmIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购物车-钱币"]];
    comfirmIconView.frame = CGRectMake(0, 0, 28, 28);
    comfirmIconView.center = self.view.center;
    [[UIApplication sharedApplication].keyWindow addSubview:comfirmIconView];
    
    //动画 终点 都以sel.view为参考系
    CGPoint endpoint = CGPointMake(DMDeviceWidth-45, DMDeviceHeight - 25);
    UIBezierPath *path = [UIBezierPath bezierPath];
    //动画起点
    CGPoint startPoint = self.view.center;
    [path moveToPoint:startPoint];
    //贝塞尔曲线控制点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endpoint.x;
    float ey = endpoint.y;
    float x = sx + (ex - sx) / 3;
    float y = sy + (ey - sy) * 0.5 - 400;
    CGPoint centerPoint=CGPointMake(x, y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    //key frame animation to show the bezier path animation
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 1.0;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation  *scaleAnimation;
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat: 0.1];
    scaleAnimation.duration = 1.0;
    scaleAnimation.cumulative = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.repeatCount = 0;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:animation, scaleAnimation ,nil];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.autoreverses = NO;
    groupAnimation.duration = 1.0;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.delegate = self;
    
    [comfirmIconView.layer addAnimation:groupAnimation forKey:@"buy"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if([comfirmIconView.layer animationForKey:@"buy"] == anim && flag) {
        
        [comfirmIconView removeFromSuperview];
        
        GZDistributionTargetViewController *dtvc = [[GZDistributionTargetViewController alloc]init];
        dtvc.assetBuyRecordId = assetBuyRecordId;
        dtvc.assetId = assetId;
        dtvc.repayAmount = self.monthlyBillingLabel.text;
        dtvc.hidesBottomBarWhenPushed = YES;
        dtvc.navigationItem.title = @"资产配标";
        [self.navigationController pushViewController:dtvc animated:NO];
    }
}


//确认金额对话框
- (void)showConfirmationAlert {
    
    //判断金额是否为100的倍数
    NSInteger amount = self.sumInputTextField.text.integerValue;
    if(amount%100 !=0 || amount == 0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入为100元整数倍的金额" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"认购金额" message:[NSString stringWithFormat:@"认购%ld元",(long)amount] preferredStyle:UIAlertControllerStyleAlert];
        
        //Comfirm purchase
        __weak __typeof__(self) weakSelf = self;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
             [weakSelf prepareForPurchasingAssets];
        }];
        
        //Cancel
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }
}

#pragma mark - Helper Functions

- (void)showProtocolAndReminderLabel:(BOOL)isShow {
    
    if(isShow) {
        NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:@"点击'立即认购'即代表您已了解" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [mutableAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《风险提示函》" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7)}]];
        [mutableAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"以及" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        [mutableAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《咨询与管理协议》" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7)}]];
        
        reminderLabel.attributedText = mutableAttributedStr;
        
        __weak typeof(self) weakSelf = self;
        [reminderLabel DM_addAttributeTapActionWithStrings:@[@"《风险提示函》",@"《咨询与管理协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            
            if ([string isEqualToString:@"《风险提示函》"]) {
                [weakSelf getWebViewWithUrl:[NSString stringWithFormat:@"%@%@",weburl,@"mzc/help/protocol/cjfxtsh?fromapp=1"] Title:@"风险提示函" Type:@""];
            }else if([string isEqualToString:@"《咨询与管理协议》"]){
                
                if ([guarantyStyle isEqualToString:@"CarInsurance"]) {
                 
                    [weakSelf getWebViewWithUrl:[NSString stringWithFormat:@"%@%@",weburl,@"mzc/help/protocol/cxzxgl?fromapp=1"] Title:@"咨询与管理协议" Type:@""];
                }else {
                    
                    [weakSelf getWebViewWithUrl:[NSString stringWithFormat:@"%@%@",weburl,@"mzc/help/protocol/grzxgl?fromapp=1"] Title:@"咨询与管理协议" Type:@""];
                }
            }
        }];
        
    }else {
        
        reminderLabel.attributedText = nil;
    }
}

//"100,000.00" -> "100000.00"
- (NSString *)getStringByDeletingCommaOf:(NSString *)str {
    
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:20];
    
    for(int i=1;i<=[str length];i++) {
        
        if([[str substringWithRange:NSMakeRange([str length]-i, 1)] isEqualToString:@","]) {
            
            continue;
        }
        
        [mutableStr insertString:[str substringWithRange:NSMakeRange([str length]-i, 1)] atIndex:0];
    }
    return [mutableStr copy];
}

- (NSAttributedString *)getAccumulatedAttributeTextWithString:(NSString *)str {
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:@"累积交易人次 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7)}];
    
    NSAttributedString *appendingStr = [[NSAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:UIColorFromRGB(0x86a7e8)}];
    
    [mutableAttributedStr appendAttributedString:appendingStr];
    
    return mutableAttributedStr;
}

- (NSMutableAttributedString *)getInterestRatePercentString:(NSString *)str {
    
    NSMutableAttributedString *mutableAttributedStr;
    
    if(iPhone5) {
        mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        
        NSAttributedString *percentSymbol = [[NSAttributedString alloc]initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        [mutableAttributedStr appendAttributedString:percentSymbol];
    }else {
        mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:68],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        
        NSAttributedString *percentSymbol = [[NSAttributedString alloc]initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:31],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        [mutableAttributedStr appendAttributedString:percentSymbol];
    }
    return mutableAttributedStr;
}

- (NSMutableAttributedString *)getProductTypeStringWithPeriod:(NSString *)period andType:(NSString *)type {
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"第%@期",period] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x86a7e8)}];
    
    NSAttributedString *typeString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"·%@",type] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x50f1bf)}];
    [mutableAttributedStr appendAttributedString:typeString];
    
    return mutableAttributedStr;
}

//格式化"累积交易人次"数值
- (NSString *)getStandardTotalNumOfTradeWithString:(NSString *)str {
    
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:20];
    
    for(int i=1;i<=[str length];i++) {
    
        [mutableStr insertString:[str substringWithRange:NSMakeRange([str length]-i, 1)] atIndex:0];
        
        if(i%3 == 0 && i != [str length]) {
            [mutableStr insertString:@"," atIndex:0];
        }
    }
    
    return [mutableStr copy];
}

//格式化"年化利率"数值
- (NSAttributedString *)getFormatProfitRateWithBaseInterest:(NSString *)baseInterest andAdditionalInterest:(NSString *)additionalInterest{
    
    NSAttributedString *attStr_1 = [[NSAttributedString alloc] initWithString:baseInterest attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    NSAttributedString *attStr_2 = [[NSAttributedString alloc] initWithString:@"%" attributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    NSAttributedString *attStr_3;
    
    if (additionalInterest.doubleValue != 0) {
        
        attStr_3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@%%",additionalInterest] attributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:UIColorFromRGB(0x50f1bf)}];
        
        return CombineAttributedStrings(CombineAttributedStrings(attStr_1, attStr_2),attStr_3);
    }else {

        return CombineAttributedStrings(attStr_1, attStr_2);
    }
}

//格式化"借款期限"
- (NSAttributedString *)getFormatProductPeriodStr:(NSString *)originStr {
    
    NSAttributedString *attStr_1 = [[NSAttributedString alloc]initWithString:originStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    NSAttributedString *attStr_2 = [[NSAttributedString alloc]initWithString:@"个月" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    return CombineAttributedStrings(attStr_1, attStr_2);
}

//格式化可用优惠券
- (void)formattedAvailiableCouponWithInt:(NSInteger)number {
    
    //无可用优惠券
    if (number == 0) {
        
        NSAttributedString *searchCardAttrStr = [[NSAttributedString alloc]initWithString:@"无" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0x4b6ca7),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [searchCardBtn setEnabled:NO];
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateNormal];
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateHighlighted];
    }else {
        
        NSAttributedString *searchCardAttrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld张可用 >",number] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [searchCardBtn setEnabled:YES];
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateNormal];
        [searchCardBtn setAttributedTitle:searchCardAttrStr forState:UIControlStateHighlighted];
    }
}

//格式化金额数目
- (NSString *)getFormattedAmountOfNumberWithString:(NSString *)str {
    
    NSString *strWithTwoDecimals = [NSString stringWithFormat:@"%.2f",str.doubleValue];
    
    NSArray *separatedStrs = [strWithTwoDecimals componentsSeparatedByString:@"."];
    
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:20];
    
    for(int i=1;i<=[separatedStrs[0] length];i++) {
        
        [mutableStr insertString:[separatedStrs[0] substringWithRange:NSMakeRange([separatedStrs[0] length]-i, 1)] atIndex:0];
        
        if(i%3 == 0 && i != [separatedStrs[0] length]) {
            [mutableStr insertString:@"," atIndex:0];
        }
    }
    
    [mutableStr appendString:@"."];
    [mutableStr appendString:separatedStrs[1]];
    
    return mutableStr;
}

#pragma mark - MenuDelegate

-(void)LeftMenuViewClick:(NSInteger)tag{
    
    [self.menu hidenWithAnimation];
    
    switch (tag) {
        case 0:
        {
            [self getWebViewWithUrl:[[DMWebUrlManager manager] getAboutUs] Title:@"关于我们" Type:@"model"];
        }
            break;
        case 1:
        {
            [self getWebViewWithUrl:[[DMWebUrlManager manager] getHuiShangPingTai] Title:@"银行存管" Type:@""];
        }
            break;
        case 2:
        {
            self.tabBarController.selectedIndex = 2;
        }
            break;
        case 3:
        {
            [self getWebViewWithUrl:[[DMWebUrlManager manager] getHelpCenter] Title:@"帮助中心" Type:@""];
        }
            break;
        case 4:
        {
            [self contact];
        }
            break;
        case 5:
        {
            [self topUpBtnClick];
        }
            break;
        case 6:
        {
            if (!AccessToken) {
                DMLoginViewController *DMlogin = [[DMLoginViewController alloc] init];
                [self.navigationController pushViewController:DMlogin animated:true];
            } else {
                [[DMLoginRequestManager manager] exit];
            }
            break;
        case 7:
            {
                //转让债权
                [self credit];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)credit {
    LJQCreditTransferTheZoneVC *creditTransfer = [[LJQCreditTransferTheZoneVC alloc] init];
    [self.navigationController pushViewController:creditTransfer animated:YES];
}

//是否设置交易密码
- (void)isTradePassWordRequest {
    
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQIsSetTradePassWordSuccessblock:^(NSString *result) {
        if ([result isEqualToString:@"true"]) {
            //设置过
            LJQWithDrawalVC *with = [[LJQWithDrawalVC alloc] init];
            with.availableAmount = [NSString stringWithFormat:@"%.2lf",self.mineModel.availableAmount];
            [self.navigationController pushViewController:with animated:YES];
        }else {
            //未设置交易密码
            SEL method = @selector(jumpToTradePassWord);
            [self alertShowMessage:@"请先设置交易密码再提现" cancelString:@"取消" confirmString:@"设置密码" action:method];
        }
    } faild:^{
        
    }];
}

- (void)getWebViewWithUrl:(NSString *) url Title:(NSString *)title Type:(NSString *)type{
    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = title;
    chargeVC.type = type;
    chargeVC.webUrl = url;
    [self.navigationController pushViewController:chargeVC animated:YES];
}

//联系客服
- (void)contact {
    LJQContactVC *userInfo = [[LJQContactVC alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}


#pragma mark - Notificatoin Selector

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    isShowingKeyboard = YES;
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    originRect = self.view.frame;
    CGRect newRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-height+64+46);
    
    
    CGPoint currentOffset = self.scrollView.contentOffset;
    self.scrollView.contentOffset = CGPointMake(currentOffset.x, currentOffset.y+height-49);
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.frame = newRect;
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    isShowingKeyboard = false;
    
    [UIView animateWithDuration:1.0f animations:^{
        self.view.frame = originRect;
        
        [self.view layoutIfNeeded];
    }];
}

//输入框文本改变时调用
- (void)textFieldTextDidChange:(NSNotification *)aNotification {
    
    /*
     月结收益：认购金额 * 利率 / 100 / 12 * 期限
     
     月结本息：
     按月付息到期还本：认购金额 * 利率 / 100 / 12
     
     等额本息：贷款本金×[月利率×（1+月利率）^还款月数]÷[（1+月利率）^还款月数—1]
     */
    
    if([assetId isEqualToString:@""]) {
        
        self.expectedProfitLabel.text = [self getFormattedAmountOfNumberWithString:@"0.0"];
        self.monthlyBillingLabel.text = [self getFormattedAmountOfNumberWithString:@"0.0"];
    }else {
        
        double baseAmount = self.sumInputTextField.text.doubleValue;
        
        if([assetRepaymentMethod isEqualToString:@"MonthlyInterest"]) {//按月付息到期还本
            
            self.expectedProfitLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",baseAmount*interestRate/100/12*productDuration]];
            
            self.monthlyBillingLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",baseAmount*interestRate/100/12]];
            
        }else {//等额本息
            
            double monthlyInterest = interestRate/100/12;
            
            double monthlyPayment = (baseAmount*monthlyInterest*pow(1+monthlyInterest, productDuration))/(pow(1+monthlyInterest, productDuration)-1);
            
            self.monthlyBillingLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",monthlyPayment]];
            
            self.expectedProfitLabel.text = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",monthlyPayment*productDuration-baseAmount]];
        }
    }
}

- (void)receiveMessage:(NSNotification *)notification{
    
    [self createSlideMenu];
}

- (CLTShareView *)shareView{
    if (!_shareView) {
        self.shareView = [[CLTShareView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shareView.wechatBlock = ^(NSInteger index){
            if (index == 0) {
                [[ShareManager sharedManager] sharedFrindWithType:sharedTypeWeChat
                                                    andController:weakSelf
                                                          andText:@"豆蔓智投喊你赚钱啦!"
                                                         andImage:[UIImage imageNamed:@"shareimage"]
                                                          Content:@"定期理财 坐享收益 你本身就有做土豪的潜质"
                                                              Url:@"https://www.douman.com/mzc"];
            }else{
                [[ShareManager sharedManager] sharedFrindWithType:sharedTypeFriendQurn
                                                    andController:weakSelf
                                                          andText:@"豆蔓智投喊你赚钱啦！"
                                                         andImage:[UIImage imageNamed:@"shareimage"]
                                                          Content:@"定期理财 坐享收益 你本身就有做土豪的潜质"
                                                              Url:@"https://www.douman.com/mzc"];
            }
        };
    }
    return _shareView;
}

- (NSString *)getfixInterestMonth:(int)month{
    switch (month) {
        case 1: return @"6～9";break;
        case 2: return @"7";break;
        case 3: return @"7.5～10";break;
        case 4: return @"8";break;
        case 5: return @"8.5";break;
        case 6: return @"9～12";break;
        case 7: return @"9.5";break;
        case 8: return @"10";break;
        case 9: return @"10.5";break;
        case 10: return @"11";break;
        case 11: return @"11.5";break;
        case 12: return @"12～15";break;
        default:
            return nil;
        break;
    }
}



#pragma mark - memoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
