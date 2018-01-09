//
//  LJQConfirmWithDrawalVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQConfirmWithDrawalVC.h"
#import "LJQConfirmWithDrawalCell.h"
#import "DMCreditRequestManager.h"
#import "LJQSuccessWithDrawalVC.h"
#import "DMModifytransactionpassword ViewController.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"

static NSString *const LJQConfirmWithDrawalIdentifier = @"LJQConfirmWithDrawalCell";
@interface LJQConfirmWithDrawalVC ()

@end

@implementation LJQConfirmWithDrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"提现";
    //确认提现
    [self.tableView registerClass:[LJQConfirmWithDrawalCell class] forCellReuseIdentifier:LJQConfirmWithDrawalIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 303;
    self.tableView.tableFooterView = [self createBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenkeyBoard)];
    [self.tableView addGestureRecognizer:tap];

}

- (void)hiddenkeyBoard {
    [self.tableView endEditing:YES];
}

- (UIView *)createBtn {
    UIImage *image = [UIImage imageNamed:@"确认"];
    CGFloat number = iPhone5 ? 60 : 130;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130 + image.size.height)];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake((SCREENWIDTH - image.size.width) / 2, number, image.size.width, image.size.height);
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    [button setBackgroundImage:image forState:(UIControlStateHighlighted)];
    [button addTarget: self action:@selector(confirmAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:button];
    
    return view;
}

//确认
- (void)confirmAction:(UIButton *)sender {
    LJQConfirmWithDrawalCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([self.WithDrawalAmount floatValue] >= 3 && [self.WithDrawalAmount floatValue] <= 50000) {
         [self withDrawalTradePd:cell.textField.text amount:self.WithDrawalAmount];
        
    }else if ([self.WithDrawalAmount floatValue] > 50000) {
        if ([SOURCE isEqualToString:@"BACK"]) {
           //借款人不限额
             [self withDrawalTradePd:cell.textField.text amount:self.WithDrawalAmount];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"单笔提现金额不能高于5万元" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提现金额不能低于3元" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQConfirmWithDrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQConfirmWithDrawalIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    double money = [self.WithDrawalAmount doubleValue];
    NSString *moneyString = [self stringFormatterDecimalStyle:@(money)];
    cell.amountLabel.text = [self returnDecimalString:moneyString];
   //忘记密码
    cell.forgetPW = ^(UIButton *sender) {
        DMModifytransactionpassword_ViewController *forgetPd = [[DMModifytransactionpassword_ViewController alloc] init];
        forgetPd.title = @"忘记交易密码";
        forgetPd.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:forgetPd animated:YES];
    };
    
    return cell;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//    [self.tableView endEditing:YES];
    [self.tableView resignFirstResponder];
}

//提现
- (void)withDrawalTradePd:(NSString *)tradePd amount:(NSString *)amount {
//    LJQMineRequestManager *manage = [LJQMineRequestManager RequestManager];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [manage getCashlianlianpayWithUserId:nil PayPassWord:tradePd Amount:amount successBlock:^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        ShowMessage(@"提现成功");
//        [self performSelector:@selector(successWithDrawal) withObject:nil afterDelay:1];
//        
//    } faild:^(NSString *message) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        ShowMessage(message);
//    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DMCreditRequestManager manager] withDrawCash:self.WithDrawalAmount branchName:self.openBranchName Success:^(NSString *requestId) {
        [[DMCreditRequestManager manager] getFormDataWithRequestId:requestId Success:^(NSString *argument) {
            DMWebViewController *drawCash = [[DMWebViewController alloc] init];
            drawCash.title = @"提现";
            drawCash.parameter = argument;
            drawCash.webUrl = [[DMWebUrlManager manager] getReplaceWebUrl];
            [self.navigationController pushViewController:drawCash animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failed:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}


- (void)successWithDrawal {
     [self.navigationController pushViewController:[[LJQSuccessWithDrawalVC alloc] init]animated:YES];
}

@end
