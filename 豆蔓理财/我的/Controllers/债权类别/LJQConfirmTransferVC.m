//
//  LJQConfirmTransferVC.m
//  豆蔓理财
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQConfirmTransferVC.h"
#import "LJQConfirmTransferCell.h"
#import "DMCreditTransferListModel.h"
#import "LJQQuestionView.h"
#import "DMLoginViewController.h"
#import "AutomicTransferView.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
@interface LJQConfirmTransferVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIAlertController *alertViewVC;
@end

static NSString *const confirmTransferIdentifier = @"confirmTransferIdentifierCell";
@implementation LJQConfirmTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买转让";
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenkeyBoard)];
    [self.tableView addGestureRecognizer:tap];

}

- (void)hiddenkeyBoard {
    [self.tableView endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self requestUserInfoData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 280;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [self createFootView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LJQConfirmTransferCell class] forCellReuseIdentifier:confirmTransferIdentifier];
    }
    return _tableView;
}

- (UIView *)createFootView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1000)];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    return view;
}


#pragma tableViewDelegate && tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQConfirmTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:confirmTransferIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.listModel;
    cell.textFieldShow = ^(NSString *string) {
        [self alertShowMessage:@"超过剩余可投金额" action:nil];
    };
    
    //立即购买
    cell.buyNow = ^(NSString *string) {
       
        if (AccessToken) {
            
            if ([ASSIGNSIGNFlag isEqualToString:@"1"]) {
                //已经签约
                if (string.length != 0) {
                    double number = ([string doubleValue] / [self.listModel.SURPLUSAMOUNT doubleValue] * [self.listModel.CREDITINTEREST doubleValue]) + [string doubleValue];
                    if ([string doubleValue] > [self.listModel.SURPLUSAMOUNT doubleValue]) {
                
                    }else {
                        NSString *numberString = [NSString stringWithFormat:@"%.2f",number];
                        [self buyToTransgerapplyAmountPrincipal:string applyAmountActual:numberString creditAssignId:self.listModel.ID];
                        
                    }
                }
            }else {
                //未签约
                
                AutomicTransferView *automicTransfer = [[AutomicTransferView alloc] init];
                
                __weak AutomicTransferView *weakAuto = automicTransfer;
                automicTransfer.autoMicTransfer = ^{
                    [weakAuto dismissFromView];
                    
                [self requestAutomicCreditTransferResult:self.listModel.ID loanId:self.listModel.LOANID];
                    
                };
                
                automicTransfer.jumpToAgreement = ^{
                    [weakAuto dismissFromView];
                   //跳转投标协议
                    [self jumpToAutomicProtocol];
                };
                 [automicTransfer showView];
            }
            
        }else {
            [self loadLoginAlertViewController];
        }
    
    };
    
    cell.questionShow = ^{
      
        LJQQuestionView *question = [[LJQQuestionView alloc] init];
        
        [question show];
    };
    
    return cell;
}

- (void)jumpPage {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadLoginAlertViewController {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){

    }];
    //login action
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        DMLoginViewController *lvc = [[DMLoginViewController alloc]init];
        lvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lvc animated:YES];
    }];
    
    //add actions
    [alertController addAction:registerAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:NO completion:nil];
}


- (void)alertShowMessage:(NSString *)string action:(SEL)actionnn{
    
    
    self.alertViewVC = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (actionnn) {
            //创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
            NSMethodSignature *sigg = [NSNumber instanceMethodSignatureForSelector:@selector(init)];
            NSInvocation *invocatin = [NSInvocation invocationWithMethodSignature:sigg];
            [invocatin setTarget:self];
            [invocatin setSelector:actionnn];
            [invocatin invoke];
        }

        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [self.alertViewVC addAction:cancelAction];
    [self.alertViewVC addAction:libraryAction];
    
    [self.navigationController presentViewController:self.alertViewVC animated:YES completion:^{
        
        
    }];
}

#pragma 

//applyAmountPrincipal :承接本金  applyAmountActual:实际承接金额
- (void)buyToTransgerapplyAmountPrincipal:(NSString *)applyAmountPrincipal applyAmountActual:(NSString *)applyAmountActual creditAssignId:(NSString *)creditAssignId {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager creditTransferToBuyCreditAssignId:creditAssignId applyAmountPrincipal:applyAmountPrincipal applyAmountActual:applyAmountActual successBlock:^{
        
        SEL method = @selector(jumpPage);
        [self alertShowMessage:@"购买成功" action:method];
        
    } faild:^(NSString *message) {
        [self alertShowMessage:message action:nil];
    }];
}

//自动签约接口
- (void)requestAutomicCreditTransferResult:(NSString *)assignId loanId:(NSString *)loanId {
    LJQMineRequestManager *request = [LJQMineRequestManager RequestManager];
    [request automicCreditTransgerAssignId:assignId loanId:loanId successBlock:^(NSString *parameter) {
        DMWebViewController *drawCash = [[DMWebViewController alloc] init];
        drawCash.title = @"债转签约";
        drawCash.parameter = parameter;
        drawCash.webUrl = [[DMWebUrlManager manager] getsumapayUrl];
        [self.navigationController pushViewController:drawCash animated:YES];
    } faild:^{
        
    }];
}

//跳转投标协议
- (void)jumpToAutomicProtocol {
    NSString *urlString = [NSString stringWithFormat:@"%@mzc/debtTransfer/autoCreditAssignprotocol?fromapp=1&token=%@",weburl,AccessToken];
    DMWebViewController *drawCash = [[DMWebViewController alloc] init];
    drawCash.title = @"自动债转投标授权";
    drawCash.webUrl = urlString;
    [self.navigationController pushViewController:drawCash animated:YES];
}

//用户信息
- (void)requestUserInfoData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQUserInfoDataSourceSuccessBlock:^(NSInteger index, LJQUserInfoModel *model, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:model.assignSignFlag forKey:@"assignSignFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
