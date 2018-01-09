//
//  DMWebViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/1/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMWebViewController.h"
#import "DMLoginViewController.h"
#import "DMSetupBankAccountViewController.h"
#import "DMRegisterViewController.h"
#import "LJQCouponsVC.h"
#import "DMCurrentClaimsViewController.h"
#import "LJQBuyListVC.h"
#import "GZDistributionTargetViewController.h"
#import "DMRealNameCertifyViewController.h"
#import "DMWebUrlManager.h"
#import "DMAddBandCardViewController.h"
#import "LJQHomeManager.h"
#import "DMCreditRequestManager.h"
#import "DMOpenPopUpView.h"
#import "DMCodeViewController.h"
#import "HMTabBarViewController.h"

#import "NSURLRequest+SSL.h"
@interface DMWebViewController ()<UIWebViewDelegate,OpenPopUpDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, assign) BOOL JsCallNative;
@property (nonatomic, strong) CLTShareView *shareView;
@property (nonatomic, strong)NSDictionary *userdic;

@property (nonatomic, strong) UILabel *reloadLabel;
@end

@implementation DMWebViewController
@synthesize userdic;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.JsCallNative = NO;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64)];

    self.webView.backgroundColor = UIColorFromRGB(0xffffff);
    self.webView.delegate=self;
    [self.webView setScalesPageToFit:YES];
    [self.view addSubview: self.webView];
    [self.view addSubview:self.reloadLabel];

    [self webRequest];
    [self setItem];

}

- (void)setItem{
    if (_root) {
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    }
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if ([self.type isEqualToString:@"charge"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"限额说明" style:UIBarButtonItemStylePlain target:self action:@selector(limitAccount:)];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
    
    [self.navigationController.view addSubview:self.shareView];
    self.shareView.alpha = 0;
    if ([self.type isEqualToString:@"model"]) { /////////douman_share
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share_friend_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
        
        __weak __typeof(self) weakSelf = self;
        _shareView.wechatBlock = ^(NSInteger index){
            if (index == 0) {
                [[ShareManager sharedManager] sharedFrindWithType:sharedTypeWeChat
                                                    andController:weakSelf
                                                          andText:@"豆蔓智投喊你赚钱啦!"
                                                         andImage:[UIImage imageNamed:@"shareimage"]
                                                          Content:@"定期理财 坐享收益 你本身就有做土豪的潜质"
                                                              Url:weakSelf.webUrl?weakSelf.webUrl:@"https://www.douman.com/mzc"];
            }else{
                [[ShareManager sharedManager] sharedFrindWithType:sharedTypeFriendQurn
                                                    andController:weakSelf
                                                          andText:@"豆蔓智投喊你赚钱啦！"
                                                         andImage:[UIImage imageNamed:@"shareimage"]
                                                          Content:@"定期理财 坐享收益 你本身就有做土豪的潜质"
                                                              Url:weakSelf.webUrl?weakSelf.webUrl:@"https://www.douman.com/mzc"];
            }
        };
    }else if ([self.type isEqualToString:@"new"]){ //////////douman_share
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share_friend_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
        
        __weak __typeof(self) weakSelf = self;
        _shareView.wechatBlock = ^(NSInteger index){
            if (index == 0) {
                [[ShareManager sharedManager] sharedFrindWithType:sharedTypeWeChat
                                                    andController:weakSelf
                                                          andText:@"新手注册即送大礼包!"
                                                         andImage:[UIImage imageNamed:@"shareimage"]
                                                          Content:@"注册即送现金红包  你来或不来红包都在等着你"
                                                              Url:@"https://www.douman.com/mzc/help/newHang-lp"];
            }else{
                [[ShareManager sharedManager] sharedFrindWithType:sharedTypeFriendQurn
                                                    andController:weakSelf
                                                          andText:@"新手注册即送大礼包!"
                                                         andImage:[UIImage imageNamed:@"shareimage"]
                                                          Content:@"注册即送现金红包  你来或不来红包都在等着你"
                                                              Url:@"https://www.douman.com/mzc/help/newHang-lp"];
            }
        };
    }
}

- (void)shareAction:(UIBarButtonItem *)item{
    [self.shareView show];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.shareView hide];
}


- (void)back:(UIBarButtonItem *)item{
    if (self.JsCallNative == YES || self.webView.canGoBack == NO) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.webView goBack];
    }
}

- (void)limitAccount:(UIBarButtonItem *)item{
    DMSetupBankAccountViewController *bankAccount = [[DMSetupBankAccountViewController alloc] init];
    [self.navigationController pushViewController:bankAccount animated:YES];
}


- (void)webRequest{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"weburl   %@",self.webUrl);
    NSMutableURLRequest *request;
    if (self.parameter) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
        request.HTTPMethod = @"POST";
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        request.HTTPBody = [self.parameter dataUsingEncoding:gbkEncoding];
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"https"];
    }else{
        request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    }
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeFormSubmitted)
    {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
        UIBarButtonItem * closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeAction:)];
        self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
    }

    return YES;
}

- (void)closeAction:(UIBarButtonItem *)itme{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.reloadLabel.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.webView.scrollView.mj_header endRefreshing];
    //加载完成
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    
    __weak __typeof(self) weakSelf = self;
    /**
     *  点击JS充值完成，回到账户中心
     */
    self.jsContext[@"callNativeHome"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tabBarController.selectedIndex = 2;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            weakSelf.JsCallNative = YES;
        });
    };
    
    
    /**
     web 调登录
     */
    
    self.jsContext[@"callNativeLogin"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            DMLoginViewController *loginVC = [[DMLoginViewController alloc] init];
            loginVC.current = YES;
            loginVC.LoginSuccess = ^{
                if (AccessToken) {
                    weakSelf.webUrl= [weakSelf.webUrl stringByAppendingString:[NSString stringWithFormat:@"&token=%@",AccessToken]];
                    [weakSelf webRequest];
                }
            };
            [weakSelf.navigationController pushViewController:loginVC animated:YES];
            weakSelf.JsCallNative = YES;
        });
    };
    
    /**
     注册
     */
    self.jsContext[@"callNativeRegister"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            DMRegisterViewController *regiseterVC = [[DMRegisterViewController alloc] init];
            regiseterVC.login = NO;
            [weakSelf.navigationController pushViewController:regiseterVC animated:YES];
            weakSelf.JsCallNative = YES;
        });
    };
    
    /**
     优惠券
     */
    self.jsContext[@"callNativeCoupons"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            LJQCouponsVC *couponsVC = [[LJQCouponsVC alloc] init];
            [weakSelf.navigationController pushViewController:couponsVC animated:YES];
            weakSelf.JsCallNative = YES;
        });
    };
    
    /**
     本期债权
     */
    self.jsContext[@"callNativeCurrentPeriod"] = ^(NSString *assetId){
        dispatch_async(dispatch_get_main_queue(), ^{
            DMCurrentClaimsViewController *current = [[DMCurrentClaimsViewController alloc] init];
            current.assetId = assetId;
            [weakSelf.navigationController pushViewController:current animated:YES];
        });
    };
    
    
    /**
     认购列表
     */
    self.jsContext[@"callNativeSubList"] = ^(NSString *assetId){
        dispatch_async(dispatch_get_main_queue(), ^{
            LJQBuyListVC *blvc = [[LJQBuyListVC alloc]init];
            blvc.assetId = assetId;
            NSLog(@"%@",assetId);
            [blvc.navigationItem setTitle:@"认购列表"];
            [weakSelf.navigationController pushViewController:blvc animated:YES];
        });
    };
    
    
    /**
     认购列表
     */
    self.jsContext[@"callNativeBuySuccess"] = ^(NSString *assetBuyRecordId,NSString *assetId,NSString *repayAmount){
        dispatch_async(dispatch_get_main_queue(), ^{
            GZDistributionTargetViewController *dtvc = [[GZDistributionTargetViewController alloc]init];
            dtvc.assetBuyRecordId = assetBuyRecordId;
            dtvc.assetId = assetId;
            dtvc.repayAmount = repayAmount;
            dtvc.navigationItem.title = @"资产配标";
            [weakSelf.navigationController pushViewController:dtvc animated:NO];
        });
    };
    
    /**
     充值
     */
    self.jsContext[@"callNativeCharge"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.JsCallNative = YES;
            if (!AccessToken) {
                DMLoginViewController *loginVC = [[DMLoginViewController alloc] init];
                [weakSelf.navigationController pushViewController:loginVC animated:YES];
            }else{
                [weakSelf userIsRealNameRequest];
            }
        
        });
    };

    /**
     首页
     */
    self.jsContext[@"callNativeIndex"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tabBarController setSelectedIndex:0];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    };
    
    /**
     出借
     */
    self.jsContext[@"callNativeLoan"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tabBarController setSelectedIndex:1];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exchange" object:nil userInfo:@{@"index":@(1)}];
        });
    };


    /**
     小豆立即投资
     */
    self.jsContext[@"callNativeRobotInvest"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tabBarController setSelectedIndex:1];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exchange" object:nil userInfo:@{@"index":@(2)}];
        });
    };
    
    /**
     徽商银行提现成功
     */
    self.jsContext[@"callNativeWithDrawCashSuccess"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    };
    
    /**
     忘记密码
     */
    self.jsContext[@"callNativeForgetPassword"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    };
    
    /**
     设置密码成功
     */
    self.jsContext[@"callNativeReplacePasswordSuccess"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    
    /**
     设置密码失败
     */
    self.jsContext[@"callNativeReplacePasswordFail"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    };
    
    /**
     * 跳转回之前的native页面
     */
    self.jsContext[@"backToPreviousPage"] = ^() {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //弹回根视图控制器, 并返回首页
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            
            HMTabBarViewController *tabVC = (HMTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            
            [tabVC setSelectedIndex:0];
            
        });
    };

    /**
     自动签约失败
     */
    self.jsContext[@"callNativeAutoMicFail"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    
    /**
     实名绑卡
     */
    self.jsContext[@"callNativeTiedCard"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            DMCodeViewController *code = [[DMCodeViewController alloc] init];
            [weakSelf.navigationController pushViewController:code animated:YES];
        });
    };
    
    
    self.jsContext[@"skipToTradePasswordSetting"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [[DMCreditRequestManager manager] replacePassWordSuccess:^(NSString *argument) {
                DMWebViewController *drawCash = [[DMWebViewController alloc] init];
                drawCash.title = @"交易密码";
                drawCash.parameter = argument;
                drawCash.webUrl = [[DMWebUrlManager manager] getsumapayUrl];
                [weakSelf.navigationController pushViewController:drawCash animated:YES];
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            } failed:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }];

        });
    };

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    ShowMessage(error.userInfo[@"NSLocalizedDescription"]);
    [self.webView.scrollView.mj_header endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.reloadLabel.hidden = NO;
}


- (void)reloadAction:(UITapGestureRecognizer *)tap{
    [self webRequest];
}

- (UILabel *)reloadLabel{
    if (!_reloadLabel) {
        _reloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64)];
        _reloadLabel.text = @"点击屏幕，重新加载";
        _reloadLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _reloadLabel.textAlignment = NSTextAlignmentCenter;
        _reloadLabel.textColor = UIColorFromRGB(0x888888);
        _reloadLabel.font = [UIFont fontWithName:@"HelveticaNeue-Mediumltalic" size:15];
        _reloadLabel.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadAction:)];
        [_reloadLabel addGestureRecognizer:tap];
        _reloadLabel.hidden = YES;
    }
    return _reloadLabel;
}


//是否实名认证
- (void)userIsRealNameRequest {
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

- (void)openpopupClick {
    DMCodeViewController *code = [[DMCodeViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
}


- (CLTShareView *)shareView{
    if (!_shareView) {
        self.shareView = [[CLTShareView alloc] init];
    }
    return _shareView;
}

@end
