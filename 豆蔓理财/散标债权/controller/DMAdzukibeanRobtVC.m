//
//  DMAdzukibeanRobtVC.m
//  豆蔓理财
//
//  Created by edz on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMAdzukibeanRobtVC.h"
#import "DMRobtCell.h"
#import "DMRobtProductCell.h"
#import "DMRobtServiceCell.h"
#import "DMRobtServiceInfoCell.h"
#import "DMRobtJoinListCell.h"
#import "DMAmountInfoView.h"
#import "DMLoginViewController.h"
#import "GZDistributionTargetViewController.h"
#import "GZInvestSignReminderView.h"
#import "GZHomePageRequestManager.h"
#import "DMOpenPopUpView.h"
#import "DMSettingManager.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
#import "DMCodeViewController.h"
#import "DMRobtPastServiceVC.h"
#import "DMScafferCreditManager.h"
#import "DMRobtOpeningModel.h"
#import "DMRobtOpenInfoModel.h"
#import "DMPopUpWindowView.h"
#import "DMMyServerViewController.h"
#import "DMRobotHeaderView.h"
typedef NS_ENUM(NSUInteger ,loadingCycleType) {
    loadingCycleTypeOneMonth,
    loadingCycleTypeThreeMonth,
    loadingCycleTypeSixMonth,
    loadingCycleTypeNineMonth,
    loadingCycleTypeTwelveMonth
};
@interface DMAdzukibeanRobtVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,OpenPopUpDelegate,GZInvestSignSkipDelegate,UIGestureRecognizerDelegate>

{
    CGFloat offectY;
    NSInteger pageNumber;
    NSInteger sizeNumber;
    NSInteger monthIndex; //记录选择的月份
    NSString *usedAmount; //可使用的余额
    
    NSString *selectedMonthsStyle; //选取的月份
    BOOL isOrLoadPage; //是否是第一次加载
}

@property (nonatomic, strong)UIScrollView *bottomScrollView;
@property (nonatomic, strong)UITableView *firstScreenView;//第一屏
@property (nonatomic, strong)UITableView *secondScreenView;//第二屏
@property (nonatomic, strong)UILabel *footerTabHanderLabel;

@property (nonatomic, assign)NSInteger selectedIndex; //选择的标识
@property (nonatomic, assign)BOOL keybordIsOpen;
@property (nonatomic, assign)CGFloat keybordFrame;

@property (nonatomic, assign)BOOL isFirstPage;

@property (nonatomic, copy)NSString *robotID;
@property (nonatomic, strong)NSMutableArray *openDataSource;
@property (nonatomic, strong)NSMutableArray *infoDataSource;
@property (nonatomic, strong)NSMutableArray *joinListArr;

@property (nonatomic, strong)DMRobotHeaderView *robotHeaderView;

@property (nonatomic, assign)BOOL isPopToView;
@end

static NSString *const robtIdentifier = @"DMRobtCellIdentifer";
static NSString *const robtProcuctIdentifier = @"DMRobtProductCellIdentifier";
static NSString *const serviceIdentifier = @"DMRobtServiceCellIdentifier";
static NSString *const serviceInfoIdentifier = @"DMRobtServiceInfoCellIdentifer";
static NSString *const robtJoinListIdentifer =@"DMRobtJoinListCellIdentifier";
@implementation DMAdzukibeanRobtVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.keybordIsOpen = NO;
    self.isFirstPage = YES;
    isOrLoadPage = YES;
    pageNumber = 1;
    sizeNumber = 10;
    usedAmount = @"0";
    [self requestRobotDataWithRobotCycle:nil];
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenkeyBoardEvent)];
    tapEvent.delegate = self;
    [self.firstScreenView addGestureRecognizer:tapEvent];
    
    [self.view addSubview:self.bottomScrollView];
    [self creaeUI];
    [self addtableviewfooter];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"barHidden"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isPopToView = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 40;
    [self.view registerAsDodgeViewForMLInputDodger];
}


- (UIScrollView *)bottomScrollView {
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bottomScrollView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.delegate = self;
        _bottomScrollView.contentSize = CGSizeMake(DMDeviceWidth,(DMDeviceHeight) * 2);
        [_bottomScrollView setDelaysContentTouches:NO];
        
        //添加下拉刷新
        __weak typeof(self) weakSelf = self;
        self.bottomScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            DMRobtOpenInfoModel *model = [weakSelf.infoDataSource firstObject];
            if (isOrEmpty([@(monthIndex) stringValue]) || monthIndex == 0) {
                monthIndex = [model.robotCycle integerValue];
            }
            [weakSelf requestRobotDataWithRobotCycle:[@(monthIndex) stringValue]];
        }];

    }
    return _bottomScrollView;
}

#pragma mark tapGestureRecgnizerdelegate 解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    return NO;
}

- (void)hiddenkeyBoardEvent {
    [self.firstScreenView endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.isPopToView = YES;
   // [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (AccessToken) {
        [self prepareForUserAvailableAmount];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)creaeUI{
   self.firstScreenView = [[UITableView alloc]initWithFrame:CGRectMake(0, -60, DMDeviceWidth, DMDeviceHeight - 49) style:UITableViewStylePlain];
    [self.firstScreenView registerClass:[DMRobtCell class] forCellReuseIdentifier:robtIdentifier];
    [self.firstScreenView registerClass:[DMRobtProductCell class] forCellReuseIdentifier:robtProcuctIdentifier];
    self.firstScreenView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.firstScreenView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.firstScreenView.delegate = self;
    self.firstScreenView.dataSource = self;
    self.firstScreenView.scrollEnabled = YES;
    self.firstScreenView.tableHeaderView = self.robotHeaderView;
    [self.bottomScrollView addSubview: self.firstScreenView];
    [self addfootertext];
}

- (DMRobotHeaderView *)robotHeaderView {
    if (!_robotHeaderView) {
        __weak typeof(self) weakSelf = self;
        _robotHeaderView = [[DMRobotHeaderView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceWidth * 494 / 750)];
        _robotHeaderView.openModel = [self.openDataSource lastObject];
        _robotHeaderView.robotBackAction = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _robotHeaderView;
}

- (void)addfootertext{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 60)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 30)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [self pitcureStringName:@"上滑查看详情" imageBounds:CGRectMake(0, 20, 73, 10)];
    [view addSubview:label];
    self.firstScreenView.tableFooterView = view;
}





- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    offectY = self.bottomScrollView.contentOffset.y;
     [self.firstScreenView endEditing:YES];

}

- (void)footerTabHeaderView{
    
    UILabel * handerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25)];
    handerLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    handerLabel.attributedText = [self pitcureStringName:@"下滑返回" imageBounds:CGRectMake(0, 0, 52, 10)];
    handerLabel.font = [UIFont systemFontOfSize:14.f];
    self.footerTabHanderLabel = handerLabel;
    handerLabel.textAlignment = NSTextAlignmentCenter;
    self.secondScreenView.tableHeaderView = handerLabel;
}

//第二屏内容
- (void)addtableviewfooter {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, DMDeviceHeight, DMDeviceWidth, DMDeviceHeight)];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);

    self.secondScreenView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight - 64 - 49) style:UITableViewStylePlain];
    self.secondScreenView.showsVerticalScrollIndicator = NO;
    self.secondScreenView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.secondScreenView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.secondScreenView registerClass:[DMRobtServiceCell class] forCellReuseIdentifier:serviceIdentifier];
    [self.secondScreenView registerClass:[DMRobtServiceInfoCell class] forCellReuseIdentifier:serviceInfoIdentifier];
    [self.secondScreenView registerClass:[DMRobtJoinListCell class] forCellReuseIdentifier:robtJoinListIdentifer];
    self.secondScreenView.delegate = self;
    self.secondScreenView.dataSource = self;
    self.secondScreenView.tableFooterView = [UIView new];
    [view addSubview:self.secondScreenView];
    [self.bottomScrollView addSubview:view];
    [self footerTabHeaderView];
    [self setSecondFootView];

}

- (void)robotBackClickpage:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setSecondFootView{
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 30)];
    warnLabel.text = @"市场有风险，投资需谨慎";
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    warnLabel.textColor = UIColorFromRGB(0x9a9a9a);
    warnLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
     self.secondScreenView.tableFooterView = warnLabel;
}



#pragma tableViewDelegate && tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.secondScreenView) {
        if (section == 0) {
            return 1;
        }else {
            if (self.selectedIndex == 1) {
                return self.joinListArr.count;
            }else {
                return 1;
            }
        }
    }else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.secondScreenView) {
        return 2;
    }else {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.secondScreenView) {
    
        if (indexPath.section == 0) {
            return 44;
        }else {
            if (self.selectedIndex == 1) {
                return 54;
            }else {
                DMRobtServiceInfoCell *cell = [[DMRobtServiceInfoCell alloc] init];
                return [cell returnRowHeight] + 15;
            }
        }
    }else {
//        if (indexPath.row == 0) {
//            return DMDeviceWidth * 494 / 750;
//        }else {
//           
//        }
        UIImage *image = [UIImage imageNamed:@"robtBottomView"];
        return (DMDeviceWidth - 24) * image.size.height / image.size.width + 195;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.secondScreenView) {
        if (section == 1) {
            if (self.selectedIndex == 1) {
                return  43;
            }else {
                return 0;
            }
        }else {
            return 0;
        }
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.secondScreenView) {
        if (section == 1) {
            if (self.selectedIndex == 1) {
                return  [self createHeaderView:CGRectMake(20, 0, DMDeviceWidth - 40, 43)];
            }else {
                return [UIView new];
            }
        }else {
            return [UIView new];
        }
    }else {
        return [UIView new];
    }
}

- (UIView *)createHeaderView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    NSArray *array = @[@"认购时间",@"认购用户",@"认购金额(元)"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((frame.size.width) / 3 * i + 20, 0, frame.size.width / 3, 43) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:13.f];
        label.backgroundColor = UIColorFromRGB(0xffffff);
        label.text = array[i];
        [view addSubview:label];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.secondScreenView) {
        if (indexPath.section == 0) {
            DMRobtServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceIdentifier forIndexPath:indexPath];
            //
            cell.touchSegment = ^(NSInteger index) {
                self.selectedIndex = index;
                if (index == 1) {
                    [self.joinListArr removeAllObjects];
                    self.secondScreenView.tableFooterView = [UIView new];
                    
                    DMRobtOpeningModel *model = [self.openDataSource firstObject];
                    if ([model.saleStatus isEqualToString:@"0"]) {
                        [self setFootView];
                    }else {
                        [self requestJoinListWithRobotID:self.robotID];
                        __weak typeof(self) weakSelf = self;
                        self.bottomScrollView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                            sizeNumber += 10;
                            [weakSelf requestJoinListWithRobotID:self.robotID];
                        }];
                    }
                    
                    
                }else {
                    self.bottomScrollView.mj_footer = nil;
                    [self setSecondFootView];
                }
                [self.secondScreenView reloadData];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            if (self.selectedIndex == 1) {
                DMRobtJoinListCell *listcell = [tableView dequeueReusableCellWithIdentifier:robtJoinListIdentifer forIndexPath:indexPath];
                listcell.listModel = self.joinListArr[indexPath.row];
                listcell.selectionStyle = UITableViewCellSelectionStyleNone;
                return listcell;
            }else {
                DMRobtServiceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceInfoIdentifier forIndexPath:indexPath];
                cell.openModel = [self.openDataSource lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.ContactAction = ^{
                    [self getWebViewWithUrl:[[DMWebUrlManager manager] getRobotProtocolUrl] Title:@"借款协议" Type:@""];
                };
                return cell;
            }
        }
    }else {
        if (indexPath.row == 1) {
            DMRobtCell *cell = [self.firstScreenView dequeueReusableCellWithIdentifier:robtIdentifier forIndexPath:indexPath];
            cell.robotBackAction = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            cell.openModel = [self.openDataSource lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            DMRobtProductCell *cell = [self.firstScreenView dequeueReusableCellWithIdentifier:robtProcuctIdentifier forIndexPath:indexPath];
            if (self.infoDataSource.count != 0) {
                cell.infoArr = self.infoDataSource;
                cell.openModel = [self.openDataSource lastObject];
            }
            
            if (!isOrEmpty(selectedMonthsStyle)) {
                cell.SelectedGuarantyStyle = selectedMonthsStyle;
            }
            
            //立即加入
            __weak typeof(self) weakSelf = self;
            cell.robtJoin = ^(NSString *string) {
                [weakSelf robtJoinTouchEvent:string];
            };
            //查看往期服务
            cell.pastService = ^{
                [weakSelf LookPastService];
            };
            
            cell.selectedCycle = ^(NSInteger index) {
                NSLog(@"------%ld",index);
                monthIndex = index;
                [weakSelf requestRobotDataWithRobotCycle:[@(index) stringValue]];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)robtJoinTouchEvent:(NSString *)string {
    if (AccessToken) {
        NSInteger number = [((DMRobtOpeningModel *)[self.openDataSource lastObject]).minPurchaseAmount integerValue];
        if ([string doubleValue] < number) {
            NSString *string = [NSString stringWithFormat:@"%@元起投，请重新输入",((DMRobtOpeningModel *)[self.openDataSource lastObject]).minPurchaseAmount];
            DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:string flag:1];
            [infoView showView];
        }else if ([string doubleValue] > [usedAmount doubleValue]) {
            DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:@"账户余额不足，请先充值" flag:2];
            infoView.jumpToAgreement = ^(NSInteger number) {
                //充值
                [self userIsRealNameRequest:1 buyAmount:@"0"];
            };
            [infoView showView];
        }else if ([string integerValue] % number != 0) {
            NSString *string = [NSString stringWithFormat:@"请输入%@元整数倍的金额",((DMRobtOpeningModel *)[self.openDataSource lastObject]).minPurchaseAmount];
            DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:string flag:1];
            [infoView showView];
        }else {
            NSString *infoMessage = [NSString stringWithFormat:@"您输入的金额为%@元，请您确认",string];
            DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:infoMessage flag:1];
            infoView.jumpToAgreement = ^(NSInteger number) {
                //开始购买
                [self userIsRealNameRequest:2 buyAmount:string];
            };
            [infoView showView];
        }
    }else {
        self.isPopToView = NO;
        
        UIColor *color = MainRed;
        UIColor *color2 = UIColorFromRGB(0xffffff);
        DMPopUpWindowView *popUpView = [[DMPopUpWindowView alloc] initWithIsMessageStr:@[@"温馨提示",@"您的账号暂未登录，请先登录"] buttonTitle:@[@"注册",@"登录"] btnColorArr:@[color,color2] flag:2];
        popUpView.jumpToAgreement = ^(NSInteger number) {
            if (number == 1000) {
                [self comeTozhuce];
            }
            if (number == 1001) {
                [self comeToLogin];
            }
        };
        [popUpView showView];
    }
}

//预约购买
- (void)toMakeAppointmentToBuy:(NSString *)amountStr {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMRobtToMakeAppointmentToBuyWithOrderInvestAmount:amountStr robotID:self.robotID showView:self.view success:^(NSString *message) {
        UIColor *color = MainRed;
        UIColor *color2 = UIColorFromRGB(0xffffff);
        CGFloat value = [message floatValue];
        NSString *string = [NSString stringWithFormat:@"系统正在为您匹配合适的债权，本次预计为您节省%.2f元平台服务费",value];
        DMPopUpWindowView *popUpView = [[DMPopUpWindowView alloc] initWithIsMessageStr:@[@"已成功加入",string] buttonTitle:@[@"查看服务",@"确认"] btnColorArr:@[color,color2] flag:1];
        popUpView.jumpToAgreement = ^(NSInteger number) {
            if (number == 1000) {
                self.isPopToView = NO;
                DMMyServerViewController *myServer = [[DMMyServerViewController alloc] init];
                [self.navigationController pushViewController:myServer animated:YES];
            }else {
                NSLog(@"确认");
            }
        };
        [popUpView showView];
    } faild:^(NSString *message) {
        NSLog(@"robotID----%@",self.robotID);
        NSLog(@"amountStr===%@",amountStr);
        ShowMessage(message);
    }];
}



//跳转登录
- (void)comeToLogin {
    DMLoginViewController *loginvc=[[DMLoginViewController alloc] init];
    loginvc.current = YES;
    [self.navigationController pushViewController:loginvc animated:YES];
}

- (void)comeTozhuce {
    DMLoginViewController *loginvc=[[DMLoginViewController alloc] init];
    loginvc.current = NO;
    [self.navigationController pushViewController:loginvc animated:YES];
}

- (void)LookPastService {
    self.isPopToView = NO;
    DMRobtPastServiceVC *pastService = [[DMRobtPastServiceVC alloc] init];
    [self.navigationController pushViewController:pastService animated:YES];
}

/** 检查自动签约状态 */
- (void)checkStatusOfAutoSignbuyAmount:(NSString *)buyAmount{
    
    [[GZHomePageRequestManager defaultManager] requestStatusOfAutoSignWithUserId:USER_ID successBlock:^(NSString *status, NSString *msg) {
        
        if([status isEqualToString:@"0"]) {
            //已签约
          [self toMakeAppointmentToBuy:buyAmount];
            
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


//银行卡信息
- (void)MineBankCardInfoRequest:(NSInteger)index buyAmount:(NSString *)buyAmount{
    DMSettingManager *settingManager = [DMSettingManager RequestManager];
    [settingManager requestForTieOnCardSuccess:^(BOOL sure) {
        
        if (sure == YES) {
            //帮过卡
            if (index == 1) {
                //充值
                DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
                chargeVC.title = @"充值";
                chargeVC.type = @"charge";
                chargeVC.webUrl = [[DMWebUrlManager manager] getChargeUrl];
                [self.navigationController pushViewController:chargeVC animated:YES];
            }
            if (index == 2) {
                //自动签约
                [self checkStatusOfAutoSignbuyAmount:buyAmount];
            }
        }else {
            DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:YES];
            open.delegate = self;
            [self.navigationController.tabBarController.view addSubview:open];
        }
    } Faild:^() {
        
    }];
}

//是否实名认证
- (void)userIsRealNameRequest:(NSInteger)index buyAmount:(NSString *)buyAmount{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQIsRealNamesuccessblock:^(NSString *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isEqualToString:@"true"]) {
            //实名认证通过,判断是否绑卡
            [self MineBankCardInfoRequest:index buyAmount:buyAmount];
        }else {
            //未实名认证//跳转实名认证页面
            DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:NO];
            open.delegate = self;
            [self.navigationController.tabBarController.view addSubview:open];
        }
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)loadAutomaticalInvestSignReminder {
    
    [GZInvestSignReminderView showPopviewToView:self.view];
    [GZInvestSignReminderView setDelegateOfSingletonWith:self];
}

#pragma mark - GZInvestSignSkipDelegate
//自动投标
- (void)skipToDetailOfInvestSign {
    self.isPopToView = NO;
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.title = @"自动投标签约";
    webVC.webUrl = [[DMWebUrlManager manager] getAutoMakeABid];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)skipToAutoSignAuthProtocol {
    self.isPopToView = NO;
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.webUrl = [[DMWebUrlManager manager] getAutoSignAuthProtocolUrl];
    webVC.navigationItem.title = @"自动投标授权";
    
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma OpenPopUpDelegate
//开户页面
- (void) openpopupClick {
    self.isPopToView = NO;
    DMCodeViewController *code = [[DMCodeViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
}


#pragma 小豆机器人数据

- (void)requestRobotDataWithRobotCycle:(NSString *)robotCycle {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMRobtToGetOpeningWithRobtCycle:robotCycle showView:self.view success:^(NSArray<DMRobtOpeningModel *> *robtOpenArr, NSArray<DMRobtOpenInfoModel *> *robtInfoArr) {
        
        self.infoDataSource = [NSMutableArray arrayWithArray:robtInfoArr];
        if (robtOpenArr.count > 0) {
             [self.openDataSource removeAllObjects];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changebtnstatus" object:nil];
            self.openDataSource = [NSMutableArray arrayWithArray:robtOpenArr];
            self.robotID = ((DMRobtOpeningModel *)[robtOpenArr lastObject]).ID;
            
            self.robotHeaderView.openModel = [self.openDataSource lastObject];
            
            if (isOrLoadPage == YES) {
                selectedMonthsStyle = ((DMRobtOpeningModel *)[robtOpenArr lastObject]).robotCycle;
                isOrLoadPage = !isOrLoadPage;
            }else {
                selectedMonthsStyle = @"";
            }
            
            NSLog(@"-----------%@",self.robotID);
            if ([((DMRobtOpeningModel *)[robtOpenArr lastObject]).saleStatus isEqualToString:@"0"]) {
                [self.joinListArr removeAllObjects];
            }
            self.bottomScrollView.scrollEnabled = YES;
            [self addfootertext];
        }else {
            self.firstScreenView.tableFooterView = [UIView new];
            self.bottomScrollView.scrollEnabled = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changebtnstatus" object:nil];
            self.robotHeaderView.openModel = nil;
            selectedMonthsStyle = robotCycle;
            
        }
        [self.firstScreenView reloadData];
        [self.secondScreenView reloadData];
        [self.bottomScrollView.mj_header endRefreshing];

    } faild:^{
        [self setToRate];
        [self.firstScreenView reloadData];
        [self.bottomScrollView.mj_header endRefreshing];
    }];
}
//加入列表
- (void)requestJoinListWithRobotID:(NSString *)RobotID {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMRobtToGetListRobtBuyWithPage:pageNumber size:sizeNumber showView:self.view robtID:RobotID success:^(NSArray *buyArr) {
        self.joinListArr = [NSMutableArray arrayWithArray:buyArr];
        if (self.joinListArr.count <= 0) {
            [self setFootView];
        }
        
        [self.secondScreenView reloadData];
        
        if (self.joinListArr.count != sizeNumber) {
            [self.bottomScrollView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.bottomScrollView.mj_footer endRefreshing];
        }
        if (self.isFirstPage == NO) {
           // [self setContentOffect];
        }
    } faild:^{
        [self.bottomScrollView.mj_header endRefreshing];
    }];
}

/** 可用余额 */
- (void)prepareForUserAvailableAmount {
    [[GZHomePageRequestManager defaultManager] requestForHomePageUserAvailableAmountWithUserId:USER_ID accessToken:AccessToken successBlock:^(BOOL result, NSString *message, NSString *availableAmount) {
        if(result){
            
            usedAmount = [NSString stringWithFormat:@"%@",availableAmount];
        }else {
            ShowMessage(message);
            usedAmount = @"0";
        }
        
    } failureBlock:^(NSError *err) {
        usedAmount = @"0";
    }];
}


- (void)setFootView{
    if (self.joinListArr.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, self.secondScreenView.bounds.size.height - 100)];
        UILabel *label = [UILabel initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 15)
                                           Font:14
                                           Text:@"暂无加入数据"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:UIColorFromRGB(0x878787)];
        label.center = view.center;
        
        UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 40, DMDeviceWidth, 30)];
        warnLabel.text = @"市场有风险，投资需谨慎";
        warnLabel.textAlignment = NSTextAlignmentCenter;
        warnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        warnLabel.textColor = UIColorFromRGB(0x9a9a9a);
        warnLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);

        [view addSubview:label];
        [view addSubview:warnLabel];
        self.secondScreenView.tableFooterView = view;
    }
}

- (NSMutableArray *)infoDataSource {
    if (!_infoDataSource) {
        _infoDataSource = [@[] mutableCopy];
    }
    return _infoDataSource;
}

- (NSMutableArray *)openDataSource {
    if (!_openDataSource) {
        _openDataSource = [@[] mutableCopy];
    }
    return _openDataSource;
}

- (NSMutableArray *)joinListArr {
    if (!_joinListArr) {
        _joinListArr = [@[] mutableCopy];
    }
    return _joinListArr;
}

- (void)setToRate {
    NSArray *maxArr = @[@"8",@"10",@"11"];
    NSArray *addRate = @[@"1",@"2",@"3"];
    NSArray *monthArr = @[@"3",@"6",@"9"];
    
    [self.infoDataSource removeAllObjects];
    for (int i = 0; i < 3; i++) {
        DMRobtOpenInfoModel *model = [[DMRobtOpenInfoModel alloc] init];
        model.minRate = @"7";
        model.maxRate = maxArr[i];
        model.disCountRate = addRate[i];
        model.robotCycle = monthArr[i];
        [self.infoDataSource addObject:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changestatus" object:nil];
}


- (void)getWebViewWithUrl:(NSString *) url Title:(NSString *)title Type:(NSString *)type{
    self.isPopToView = NO;
    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = title;
    chargeVC.type = type;
    chargeVC.webUrl = url;
    [self.navigationController pushViewController:chargeVC animated:YES];
}
@end
