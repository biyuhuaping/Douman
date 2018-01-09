//
//  DMMineViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMMineViewController.h"
#import "HMTabBarViewController.h"
#import "LJQMineCell.h"
#import "ZJDrawerController.h"
#import "DMHoldCreditViewController.h"
#import "LJQWithDrawalVC.h"
#import "LJQTopUpVC.h"
#import "DMLoginViewController.h"
#import "LJQTransactionDetailVC.h"
#import "LJQCouponsVC.h"
#import "LJQSystemMessageVC.h"
#import "DMCreditRequestManager.h"
#import "DMRightSlideMenu.h"
#import "DMRightSlideMenuView.h"
#import <CoreText/CoreText.h>

#import "LJQUserInfoVC.h"
#import "LJQContactVC.h"
#import "LJQSettingMessageVC.h"
#import "LJQSetPassWordVC.h"
#import "DMHoldingAssetsViewController.h"

#import "LJQMineRequestManager.h"
#import "LJQMineModel.h"
#import "DMLoginRequestManager.h"

#import "DMRealNameCertifyViewController.h"
#import "DMAddBandCardViewController.h"
#import "DMCodeViewController.h"
#import "LJQTradePassWordVC.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
#import "AppDelegate.h"

#import "LJQShareSuperView.h"

#import "DMOpenPopUpView.h"

#import "RiskMeasurementVC.h"
#import "LJQPlatformNoticeVC.h"
#import "LJQCreditTransferTheZoneVC.h"
#import "DMSettingManager.h"
#import "DMMyServerViewController.h"


#import "LLLockViewController.h"
#import "DMMyAccountHeaderView.h"
#import "CommonMethod.h"
#import "DMMyAccountJumpCell.h"
#import "DMMyAccountInfoVC.h"

@interface DMMineViewController ()<OpenPopUpDelegate,DMSlideMenuView>
{
    NSDictionary *userdic;
}
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) DMRightSlideMenu *menu;
@property (nonatomic ,strong) DMRightSlideMenuView *DMSlideMenuView;

@property (nonatomic, strong)LJQMineModel *mineModel;
@property (nonatomic, strong) DMLoginViewController *loginVC;

@property (nonatomic, strong)UIAlertController *alertViewVC;

@property (nonatomic, strong)DMMyAccountHeaderView *myAccountHeaderView;
@property (nonatomic, strong)NSArray<NSString *> *DMimageArr;
@property (nonatomic, strong)NSArray<NSString *> *DMcellTextArr;
@property (nonatomic, strong)NSArray<NSString *> *DMVCClassNameArr;
@property (nonatomic, strong)CAGradientLayer *gradientLayer;

@property (nonatomic, copy)NSString *coupinNumber;
@end


static NSString *const MyAccountIdentifier = @"MyAccountIdentifierCell";

@implementation DMMineViewController

- (DMMyAccountHeaderView *)myAccountHeaderView {
    UIImage *bottomImage = [UIImage imageNamed:@"MyAccountStyle"];
    if (!_myAccountHeaderView) {
        _myAccountHeaderView = [[DMMyAccountHeaderView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 124 + DMDeviceWidth *bottomImage.size.height / bottomImage.size.width)];
        //提现
        __weak typeof(self) weakSelf = self;
        _myAccountHeaderView.myAccountToWithDrawal = ^{
            [weakSelf userIsRealNameRequest:0];
        };
        //充值
        _myAccountHeaderView.myAccountToTopUp = ^{
            [weakSelf userIsRealNameRequest:1];
        };
    }
    return _myAccountHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight - 64) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMMyAccountJumpCell class] forCellReuseIdentifier:@"MyAccountIdentifierCell"];
        _tableView.tableHeaderView = self.myAccountHeaderView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.gradientLayer];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    self.gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0xa5bad9).CGColor,(__bridge id)UIColorFromRGB(0xf3f3f3).CGColor,(__bridge id)UIColorFromRGB(0xf3f3f3).CGColor];
    self.gradientLayer.locations = @[@(0.4f),@(0.5f),@(1.0f)];

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"exit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"hidelogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"hideSideMenu" object:nil];
}


- (void)receiveMessage:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"exit"]) {
        [self setLoginInfo];
    }else if ([notification.name isEqualToString:@"hidelogin"]) {
        [self setMineInfo];
    }else if ([notification.name isEqualToString:@"hideSideMenu"]){
        [self.menu hidenWithAnimation];
    }else{
        
    }
}

- (void)setMineInfo{
    self.title = @"我的";
    UILabel *label = [UILabel createLabelFrame:CGRectMake(0, 0, 100, 18) labelColor:UIColorFromRGB(0xa5bad9) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
    label.text = @"";
    self.navigationItem.titleView = label;
    [self.menu add];
    
    [self requestSystemMessage];
    [self createLeftNavigationItem:@"xiaoxi_iconxiaoxi_icon"];
    [self createRightNavigationItem];
    
    [self.loginVC removeFromParentViewController];
    [self.loginVC.view removeFromSuperview];
    self.loginVC = nil;

    [self requestMineData];
    [self requestCouponsNmuberData:@"PLACED" page:1 size:10];
    
    [self.view addSubview:self.tableView];
    [self.view addConstrainsWithVisualFormat:@"H:|-0-[v0]-0-|" Views:@[self.tableView]];
    [self.view addConstrainsWithVisualFormat:@"V:|-0-[v0]-0-|" Views:@[self.tableView]];
    [self.view bringSubviewToFront:self.tableView];
    [self CreateSlideMenu];
    [self showBandCardView];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void) openpopupClick {
    DMCodeViewController *code = [[DMCodeViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
}


- (void)setLoginInfo{
    self.title = @"登录";
    [self setExitNavgationBar];
    [self addChildViewController:self.loginVC];
    [self.view addSubview:self.loginVC.view];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems= nil;
    self.DMSlideMenuView=nil;
    self.menu=nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (AccessToken) {
        [self setMineInfo];
         [self setNavGationBar];
    }else{
        [self setLoginInfo];
    }
    
}


- (void)setNavGationBar {
   UIImage *image = [[CommonMethod methodCall] createImageWithColor:UIColorFromRGB(0xa5bad9) frame:CGRectMake(0, 0, DMDeviceWidth, 64)];
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xa5bad9)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)setExitNavgationBar {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)showBandCardView{
    if (AccessToken) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"showview"]) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cardNbr"]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[DMSettingManager RequestManager] requestForTieOnCardSuccess:^(BOOL sure) {
                    if (!sure) {
                        DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:YES];
                        open.delegate = self;
                        [[UIApplication sharedApplication].keyWindow addSubview:open];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } Faild:^() {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }else{
                DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:NO];
                open.delegate = self;
                [[UIApplication sharedApplication].keyWindow addSubview:open];
            }
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self setExitNavgationBar];
    [self.menu remove];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: YES];
    [self setExitNavgationBar];
//    self.mineModel = nil;
}

- (void)createLeftNavigationItem:(NSString *)imageName {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]style:UIBarButtonItemStylePlain target:self action:@selector(systemMessage:)];

}
//系统消息
- (void)systemMessage:(UIBarButtonItem *)item {
    LJQSystemMessageVC * message = [[LJQSystemMessageVC alloc] init];
    [self.navigationController pushViewController:message animated:YES];
}

-(void)CreateSlideMenu {
    
    self.DMSlideMenuView = [[DMRightSlideMenuView alloc] initWithFrame:CGRectMake(DMDeviceWidth, 0, DMDeviceWidth * 0.75, [[UIScreen mainScreen] bounds].size.height)];
    self.DMSlideMenuView.customDelegate = self;
    self.menu = [[DMRightSlideMenu alloc]initWithDependencyView:self.tabBarController.view MenuView:self.DMSlideMenuView  isShowCoverView:YES];

}

#pragma mark - MenuDelegate
-(void)LeftMenuViewClick:(NSInteger)tag{
    
    [self.menu hidenWithAnimation];
    NSArray *methodArr = @[@"passWord",@"shareGoodFriend",@"reward",@"contact",@"helpCenter",@"getWebViewWithUrl:Title:",@"myAccountExit"];
    SEL mehtodStr = NSSelectorFromString(methodArr[tag]);
    [self createMethodSignatureForSelector:mehtodStr withparameter:tag == 5 ? @[@"https://www.zlot.cn/mzc/help/aboutUs?fromapp=1",@"关于我们"]: @[]];
}

- (void)createMethodSignatureForSelector:(SEL)aSelector withparameter:(NSArray *)parameter{
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    if (parameter.count > 0) {
        for (int i = 0; i < parameter.count; i++) {
            NSString *arg = parameter[i];
            [invocation setArgument:&arg atIndex:(2 + i)];
        }
    }
    [invocation invoke];
    
    if (signature.methodReturnLength > 0) {
        NSString *result = nil;
        [invocation getReturnValue:&result];
        NSLog(@"%@",result);
    }
}

- (void)createRightNavigationItem {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"shezhi_iconshezhi_icon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:UIBarButtonItemStylePlain target:self action:@selector(systemSetting:)];
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpace.width = 1;
    self.navigationItem.rightBarButtonItems = @[item1,rightSpace];
}
//系统设置
- (void)systemSetting:(UIBarButtonItem *)item {
     [self.menu show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.DMcellTextArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 10)];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DMMyAccountJumpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAccountIdentifierCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageName = self.DMimageArr[indexPath.row];
    cell.labelText = self.DMcellTextArr[indexPath.row];
    if (indexPath.row == 4) {
        cell.isOrShowTextLabel = YES;
        cell.showText = self.coupinNumber;
    }else {
        cell.isOrShowTextLabel = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcString = self.DMVCClassNameArr[indexPath.row];
    Class vcClass = NSClassFromString(vcString);
    
    if (indexPath.row == 0) {
        DMHoldingAssetsViewController *vc = [[DMHoldingAssetsViewController alloc] init];
        vc.push = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        DMBaseViewController *jumpVC = [[vcClass alloc] init];
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    
}

//联系客服
- (void)contact {
    LJQContactVC *userInfo = [[LJQContactVC alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}

//分享好友
- (void)shareGoodFriend {
    
    LJQShareSuperView *shareView = [[LJQShareSuperView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.tabBarController.view addSubview:shareView];
}

//密码设置
- (void)passWord {
    LJQSetPassWordVC *userInfo = [[LJQSetPassWordVC alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];}

//消息设置
- (void)message {
    LJQSettingMessageVC *userInfo = [[LJQSettingMessageVC alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}

//赏赐好评
- (void)reward {
    NSLog(@"赏赐好评");
    
    [MobClick event:@""]; // 事件点击次数
    
    NSURL *appUrl = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/cai-lu-tong/id1197297468?mt=8"];
    [[UIApplication sharedApplication]openURL:appUrl];
}

//帮助中心
- (void)helpCenter {
    [self getWebViewWithUrl:[[DMWebUrlManager manager] getHelpCenter] Title:@"帮助中心"];
}

- (void)getWebViewWithUrl:(NSString *) url Title:(NSString *)title{
    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = title;
    chargeVC.webUrl = url;
    [self.navigationController pushViewController:chargeVC animated:YES];
}

//账户退出
- (void)myAccountExit {
    [[DMLoginRequestManager manager] exit];
    self.mineModel = nil;
    [self.tableView reloadData];
}


//我的账户数据
- (void)requestMineData {
    if (AccessToken) {
        LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager LJQRequestMineDataStringSuccessBlock:^(NSInteger index, LJQMineModel *mineModel) {
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.2];
            self.mineModel = mineModel;
            self.myAccountHeaderView.mineModel = self.mineModel;
            [self.tableView reloadData];
        } faildBlock:^{
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.2];
        }];
    }
}

//获取优惠券数量
- (void)requestCouponsNmuberData:(NSString *)status page:(NSInteger)page size:(NSInteger)size{
    
    [[LJQMineRequestManager RequestManager] LJQCouponsDataStatus:status page:page size:size successBlock:^(NSInteger index, NSArray *array, NSString *message) {
        //成功
        if (array.count != 0) {
            self.coupinNumber = [NSString stringWithFormat:@"%@张可用",message];
        }else {
            self.coupinNumber = @"";
        }
       
        [self.tableView reloadData];


    } faild:^{
        
    }];
}

//未读消息
- (void)requestSystemMessage {
    
    [[LJQMineRequestManager RequestManager] LJQSystemMessageDataPage:1 size:2 SuccessBlock:^(NSArray *array, NSInteger index) {
        if (index != 0) {
            //有未读消息
        [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"weidu_xiaoxi_icon"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
        }else {
            [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"xiaoxi_iconxiaoxi_icon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
        }
        
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (DMLoginViewController *)loginVC{
    if (!_loginVC) {
        self.loginVC = [[DMLoginViewController alloc] init];
        self.loginVC.mine = YES;
        _loginVC.isExpanded = YES;
    }
    return _loginVC;
}


- (void)isTradePassWordRequest {
    
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQIsSetTradePassWordSuccessblock:^(NSString *result) {
        if ([result isEqualToString:@"true"]) {
            //设置过
            if (self.mineModel.availableAmount == 0) {
                //不可进行提现操作
                [self alertShowMessage:@"余额为0，暂无法提现" cancelString:@"取消" confirmString:@"确定" action:nil];
            }else {
                LJQWithDrawalVC *with = [[LJQWithDrawalVC alloc] init];
                // with.availableAmount = [NSString stringWithFormat:@"%.2lf",self.mineModel.availableAmount];
                with.availableAmount = [self stringFormatterDecimalStyle:@(self.mineModel.availableAmount)];
                with.availableAmount = [self returnDecimalString:with.availableAmount];
                [self.navigationController pushViewController:with animated:YES];
            }

        }else {
            //未设置交易密码

            SEL method = @selector(jumpToTradePassWord);
            [self alertShowMessage:@"请先设置交易密码再提现" cancelString:@"取消" confirmString:@"设置密码" action:method];

        }
    } faild:^{
        
    }];
}

//银行卡信息
- (void)MineBankCardInfoRequest:(NSInteger)index {
    DMSettingManager *settingManager = [DMSettingManager RequestManager];
    [settingManager requestForTieOnCardSuccess:^(BOOL sure) {
        
        if (sure == YES) {
            //帮过卡
            if (index == 0) {
                //提现
                [self isTradePassWordRequest];
            }
            if (index == 1) {
                //充值
                DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
                chargeVC.title = @"充值";
                chargeVC.type = @"charge";
                chargeVC.webUrl = [[DMWebUrlManager manager] getChargeUrl];
                [self.navigationController pushViewController:chargeVC animated:YES];
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
- (void)userIsRealNameRequest:(NSInteger)index {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQIsRealNamesuccessblock:^(NSString *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isEqualToString:@"true"]) {
            //实名认证通过,判断是否绑卡
            [self MineBankCardInfoRequest:index];
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
    
    [self.navigationController presentViewController:self.alertViewVC animated:YES completion:nil];
}



//设置交易密码
- (void)jumpToTradePassWord {
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

- (void)hideHUD:(MBProgressHUD *)progress {
    __block MBProgressHUD *progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hide:YES];
        progressC = nil;
    });
}

- (NSArray<NSString *> *)DMimageArr {
    if (!_DMimageArr) {
        _DMimageArr = [@[@"1liebiao_icon",@"2liebiao_icon",@"3liebiao_icon",@"4liebiao_icon",@"5liebiao_icon"] copy];
    }
    return _DMimageArr;
}

- (NSArray<NSString *> *)DMcellTextArr {
    if (!_DMcellTextArr) {
        _DMcellTextArr = [@[@"持有资产详情",@"小豆机器人",@"交易记录",@"账户信息",@"优惠券"] copy];
    }
    return _DMcellTextArr;
}

- (NSArray<NSString *> *)DMVCClassNameArr {
    if (!_DMVCClassNameArr) {
        _DMVCClassNameArr = [@[@"DMHoldingAssetsViewController",@"DMMyServerViewController",@"LJQTransactionDetailVC",@"DMMyAccountInfoVC",@"LJQCouponsVC"] copy];
    }
    return _DMVCClassNameArr;
}

@end
