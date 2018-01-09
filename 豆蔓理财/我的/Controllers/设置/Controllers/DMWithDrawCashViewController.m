//
//  DMWithDrawCashViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/17.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMWithDrawCashViewController.h"
#import "DMTransactionPasswordViewController.h"

@interface DMWithDrawCashViewController ()


@property (nonatomic, strong)UILabel *moneyL;

@property (nonatomic, strong)UITextField *sumofMoney;

@property (nonatomic, strong)UIButton *allreflectBtn;
@property (nonatomic, strong)UIButton *reminderBtn;
@property (nonatomic, strong)UIButton *immediateWithdrawal;


@end

@implementation DMWithDrawCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现";
    
    [self.view addSubview:self.CreateBalanceView];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(jump)];
    

}

- (void)jump {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)CreateBalanceView {

    UIView *balanceView = [[UIView alloc] init];
    balanceView.frame = CGRectMake(0, 0, DMDeviceWidth, 105);
    
    
    
    UILabel *balance = [[UILabel alloc] init];
    balance.frame = CGRectMake(35, 15, 100, 14);
    balance.text = @"账户余额（元）";
    balance.font = [UIFont systemFontOfSize:14];
    balance.textColor =UIColorFromRGB(0xa8abb1);
    [balanceView addSubview:balance];
    
    _moneyL = [[UILabel alloc] init];
    _moneyL.frame = CGRectMake(35, 40, DMDeviceWidth - 70, 22);
    _moneyL.text = @"1000000.00";
    _moneyL.textColor = UIColorFromRGB(0x6b727a);
    _moneyL.font = [UIFont systemFontOfSize:22];
    [balanceView addSubview:_moneyL];
    
    
    
    
    return balanceView;
    
}

- (UIView *)CreateBandcardView {
    
    UIView *WithDrawCashView = [[UIView alloc] init];
    WithDrawCashView.frame = CGRectMake(-1, 150, DMDeviceWidth + 2, 60);
    WithDrawCashView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    WithDrawCashView.layer.borderWidth = 1;
    
    UILabel *withDrawCash = [UILabel initWithFrame:CGRectMake(30, 0, 60, 60) Font:14 Text:@"提现金额" Alignment:NSTextAlignmentCenter TextColor:nil];
    [WithDrawCashView addSubview:withDrawCash];
    
    
    if (!_sumofMoney) {
        _sumofMoney = [[UITextField alloc] init];
        _sumofMoney.frame = CGRectMake(100, 0, DMDeviceWidth - 170, 60);
        _sumofMoney.placeholder = @"请输入您要体现的金额";
        _sumofMoney.textAlignment = NSTextAlignmentCenter;
        _sumofMoney.font = [UIFont systemFontOfSize:14];
        [WithDrawCashView addSubview:_sumofMoney];
    }
    
    UILabel *sumofMoneyline = [[UILabel alloc] init];
    sumofMoneyline.frame = CGRectMake(100, 50-1, DMDeviceWidth - 170, 1);
    sumofMoneyline.backgroundColor = [UIColor lightGrayColor];
    [WithDrawCashView addSubview:sumofMoneyline];
    
    UILabel  *money = [UILabel initWithFrame:CGRectMake(DMDeviceWidth - 80, 0, 15, 60) Font:14 Text:@"元" Alignment:NSTextAlignmentCenter TextColor:nil];
    [WithDrawCashView addSubview:money];
    
    
    NSString *str = [NSString stringWithFormat:@"全部\n体现"];
    
    if (!_allreflectBtn) {
        
        _allreflectBtn = [UIButton createBtnType:UIButtonTypeCustom BtnFrame:CGRectMake(DMDeviceWidth - 55, 10, 40, 40) BtnTittle:str state:UIControlStateNormal];
        _allreflectBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _allreflectBtn.titleLabel.numberOfLines = 0;
        [_allreflectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_allreflectBtn setBackgroundColor:[UIColor orangeColor]];
        [WithDrawCashView addSubview:_allreflectBtn];
    }
    

    return WithDrawCashView;

}

- (UIView *)CardView {
    
    
    UIView *cardView = [[UIView alloc] init];
    cardView.frame = CGRectMake(40, 260, DMDeviceWidth - 80, 80);
    cardView.layer.borderWidth = 1;
    cardView.layer.borderColor = [UIColor redColor].CGColor;
    cardView.layer.cornerRadius = 10;
    
    UIImageView *bandcardimg = [[UIImageView alloc] init];
    bandcardimg.frame = CGRectMake(20, 20, 40, 40);
    bandcardimg.backgroundColor = [UIColor blueColor];
    [cardView addSubview:bandcardimg];
    
    
    NSString *bandnum = @"6217 0000 0000 8395";
    NSString *band = [bandnum stringByReplacingCharactersInRange:NSMakeRange(4, 11) withString:@" **** **** "];
    UILabel *bandCardNum = [UILabel initWithFrame:CGRectMake(80, 20, DMDeviceWidth - 80 - 120, 15) Font:14 Text:band Alignment:NSTextAlignmentLeft TextColor:[UIColor redColor]];
    [cardView addSubview:bandCardNum];
    
    UILabel *bandName = [UILabel initWithFrame:CGRectMake(80, 45, DMDeviceWidth - 80 - 120, 15) Font:12 Text:@"中国建设银行" Alignment:NSTextAlignmentLeft TextColor:[UIColor lightGrayColor]];
    [cardView addSubview:bandName];
    
    
    return cardView;
}

- (UIButton *)CreaterReminderBtn
{
    
    if (!_reminderBtn) {
        _reminderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reminderBtn.frame = CGRectMake((DMDeviceWidth- 120)/2, 400, 100, 30);
        _reminderBtn.layer.borderColor = [UIColor purpleColor].CGColor;
        _reminderBtn.layer.borderWidth = 1;
        _reminderBtn.layer.cornerRadius = 10;
        _reminderBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);//上左下右
        [_reminderBtn setImage:[UIImage imageNamed:@"tishi.png"] forState:UIControlStateNormal];
        [_reminderBtn setImage:[UIImage imageNamed:@"tishi.png"] forState:UIControlStateHighlighted];
        [_reminderBtn setTitle:@"温馨提示" forState:UIControlStateNormal];
        [_reminderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _reminderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_reminderBtn];
    }
    
    return _reminderBtn;
    
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

- (void)drawalAction {
    
    DMTransactionPasswordViewController *transaction = [[DMTransactionPasswordViewController alloc] init];
    [self.navigationController pushViewController:transaction animated:YES];
    
}



@end
