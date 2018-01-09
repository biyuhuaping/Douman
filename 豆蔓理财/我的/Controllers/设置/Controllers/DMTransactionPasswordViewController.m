//
//  DMTransactionPasswordViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMTransactionPasswordViewController.h"


@interface DMTransactionPasswordViewController ()

@property (nonatomic, strong)UITextField *transactionPassword;

@property (nonatomic, strong)UIButton *forgetBtn;
@property (nonatomic, strong)UIButton *immediateWithdrawal;

@end

@implementation DMTransactionPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"确认提现";
    
    [self CreateUI];
    
}

- (void)CreateUI {
    
    UILabel *prompt = [UILabel initWithFrame:CGRectMake(30, 10, DMDeviceWidth-60, 30) Font:14 Text:@"实际到账金额（元）"   Alignment:NSTextAlignmentLeft TextColor:nil];
    [self.view addSubview:prompt];
    
    UILabel *money = [UILabel initWithFrame:CGRectMake(0, 40, DMDeviceWidth, 30) Font:18 Text:@"100.00" Alignment:NSTextAlignmentCenter TextColor:[UIColor redColor]];
    money.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:money];
    
    [self.view addSubview:self.CreateWithdrawalsView];
    [self.view addSubview:self.CrateTransactionPassword];
    [self.view addSubview:self.CreateForgetBtn];
    [self.view addSubview:self.CreateImmediateWithdrawal];
    
    
}

- (UIView *)CreateWithdrawalsView {
    
    UIView *WithdrawalsView = [[UIView alloc] init];
    WithdrawalsView.frame =CGRectMake(-1, 120, DMDeviceWidth+2, 80);
    WithdrawalsView.layer.borderWidth = 1;
    WithdrawalsView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UILabel *sumofMoney = [UILabel initWithFrame:CGRectMake(30, 5, DMDeviceWidth-60, 30) Font:14 Text:@"提现金额"   Alignment:NSTextAlignmentLeft TextColor:nil];
    [WithdrawalsView addSubview:sumofMoney];
    
    UILabel *Money = [UILabel initWithFrame:CGRectMake(DMDeviceWidth-200, 5, 170, 30) Font:14 Text:@"100.00元"   Alignment:NSTextAlignmentRight TextColor: [UIColor redColor]];
    [WithdrawalsView addSubview:Money];
    
    
    UILabel *CounterFee = [UILabel initWithFrame:CGRectMake(30, 45, DMDeviceWidth-60, 30) Font:14 Text:@"提现手续费"   Alignment:NSTextAlignmentLeft TextColor:nil];
    [WithdrawalsView addSubview:CounterFee];
    
    UILabel *CounterFeeMoney = [UILabel initWithFrame:CGRectMake(DMDeviceWidth-200, 45, 170, 30) Font:14 Text:@"暂不收取费用"   Alignment:NSTextAlignmentRight TextColor:[UIColor redColor]];
    [WithdrawalsView addSubview:CounterFeeMoney];
    
    
    
    return WithdrawalsView;
    
}


- (UITextField *)CrateTransactionPassword
{
    
    
    UILabel *TransactionPasswordLabel = [UILabel initWithFrame:CGRectMake(30, 250,60, 30) Font:14 Text:@"交易密码"   Alignment:NSTextAlignmentLeft TextColor:nil];
    [self.view addSubview:TransactionPasswordLabel];
    
    if (!_transactionPassword) {
        _transactionPassword = [[UITextField alloc] init];
        _transactionPassword.frame = CGRectMake(100, 245, DMDeviceWidth - 130, 40);
        _transactionPassword.placeholder = @" 123";
        _transactionPassword.textAlignment = NSTextAlignmentLeft;
        _transactionPassword.borderStyle = UITextBorderStyleRoundedRect;
        _transactionPassword.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_transactionPassword];

    }
    
    
    return _transactionPassword;
    
}

- (UIButton *)CreateForgetBtn {
    
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn.frame = CGRectMake(DMDeviceWidth - 100, 280, 70, 30);
        [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetBtn;


}



- (UIButton *)CreateImmediateWithdrawal
{
    if (!_immediateWithdrawal) {
        _immediateWithdrawal = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediateWithdrawal.frame = CGRectMake((DMDeviceWidth - 300)/2, 500, 300, 40);
        _immediateWithdrawal.backgroundColor = [UIColor redColor];
        _immediateWithdrawal.layer.cornerRadius = 20;
        [_immediateWithdrawal setTitle:@"立即提现" forState:UIControlStateNormal];
        [_immediateWithdrawal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _immediateWithdrawal.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_immediateWithdrawal addTarget:self action:@selector(drawalAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _immediateWithdrawal;
}


- (void)forgetAction {
    
    NSLog(@"修改交易密码页面");
    
}


- (void)drawalAction {
    
    NSLog(@"123");
    
}



@end
