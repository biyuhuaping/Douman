//
//  DMRealNameCertifyViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMRealNameCertifyViewController.h"
#import "DMAddBandCardViewController.h"
#import "DMSetupBankAccountViewController.h"
#import "LJQMineRequestManager.h"

#define porprotion 1.3f

@interface DMRealNameCertifyViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UIImageView *ZCImg;
@property (nonatomic, strong)UIImageView *SMImg;
@property (nonatomic, strong)UIImageView *CZImg;

@property (nonatomic, strong)UIImageView *NameImg;
@property (nonatomic, strong)UIImageView *IdCardImg;

@property (nonatomic, strong)UITextField *realnameTextField;
@property (nonatomic, strong)UITextField *IdCardNumTextField;

@property (nonatomic, strong)UIButton *testBtn;

@end

@implementation DMRealNameCertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"实名认证";
    
    [self CreateUI];
    
}



- (UIImageView *)CreateZCImg {
    
    if (!_ZCImg) {
        
        _ZCImg = [[UIImageView alloc] init];
        _ZCImg.frame = CGRectMake((DMDeviceWidth - 298/2 - 111 - 83)/2, 20, 298/2, 97/2);
        if (iPhone5) {
             _ZCImg.frame = CGRectMake((DMDeviceWidth - 298/2/porprotion - 111/porprotion - 83/porprotion)/2, 20, 298/2/porprotion, 97/2/porprotion);
        }
        _ZCImg.image = [UIImage imageNamed:@"新注册账号"];
    }
    
    return _ZCImg;
}
- (UIImageView *)CreateSMImg {
    
    if (!_SMImg) {
        
        _SMImg = [[UIImageView alloc] init];
        _SMImg.frame = CGRectMake(_ZCImg.frame.size.width + _ZCImg.frame.origin.x, 20, 111, 96/2);
        if (iPhone5) {
             _SMImg.frame = CGRectMake(_ZCImg.frame.size.width + _ZCImg.frame.origin.x, 20, 111/porprotion, 96/2/porprotion);
        }
        _SMImg.image = [UIImage imageNamed:@"新实名认证-未验证状态"];
    }
    
    return _SMImg;
}
- (UIImageView *)CreateCZImg {
    
    if (!_CZImg) {
        
        _CZImg = [[UIImageView alloc] init];
        _CZImg.frame = CGRectMake(_SMImg.frame.size.width + _SMImg.frame.origin.x ,20 , 83, 97/2);
        if (iPhone5) {
             _CZImg.frame = CGRectMake(_SMImg.frame.size.width + _SMImg.frame.origin.x ,20 , 83/porprotion, 97/2/porprotion);
        }
        _CZImg.image = [UIImage imageNamed:@"新充值购买-未验证状态"];
    }
    
    return _CZImg;
}


- (void)CreateUI {
    
    
    self.img.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.CreateZCImg];
    [self.view addSubview:self.CreateSMImg];
    [self.view addSubview:self.CreateCZImg];
    
    UILabel *point = [[UILabel alloc] init];
    point.frame = CGRectMake(0, _SMImg.frame.size.height + _SMImg.frame.origin.y + 17, DMDeviceWidth, 10);
    point.textAlignment = NSTextAlignmentCenter;
    point.text = @"*为确保账户安全，需保证姓名、身份证、银行卡开户人为同一人";
    point.font = [UIFont systemFontOfSize:10];
    point.textColor = UIColorFromRGB(0xffcd8d);
    [self.view addSubview:point];
    
    [self.view addSubview:self.CreateNameImg];
    [self.view addSubview:self.CreateRealnameTextField];
    [self.view addSubview:self.CreateIdCardImg];
    [self.view addSubview:self.CreateIdCardNumTextField];
    
    [self.view addSubview:self.CreateTestBtn];
    
}




- (UIImageView *)CreateNameImg {
    
    if (!_NameImg) {
        _NameImg = [[UIImageView alloc] init];
        _NameImg.frame = CGRectMake(48,  141, 29/2, 15);
        _NameImg.image = [UIImage imageNamed:@"新真实姓名icon"];
    }
    
    return _NameImg;
}


- (UITextField *)CreateRealnameTextField {
    
    if (!_realnameTextField) {
        _realnameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(64, 123, DMDeviceWidth - 64-48, 50) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _realnameTextField.placeholder = @"真实姓名";
        //kvc方法改变颜色  字号
        _realnameTextField.textColor = WITHEBACK_INPUT;
        _realnameTextField.font = [UIFont systemFontOfSize:14];
        _realnameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
         [_realnameTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        _realnameTextField.delegate = self;
        
        
    }
    UILabel *userNameline = [[UILabel alloc] init];
    userNameline.frame = CGRectMake(74, 160, DMDeviceWidth - 48 - 74, 1);
    userNameline.backgroundColor = WITHEBACK_LINE;
    [self.view addSubview:userNameline];
    
    
    return _realnameTextField;
    
}



- (UIImageView *)CreateIdCardImg {
    
    if (!_IdCardImg) {
        _IdCardImg = [[UIImageView alloc] init];
        _IdCardImg.frame = CGRectMake(48,  197, 30/2*1.2, 23/2*1.2);
        _IdCardImg.image = [UIImage imageNamed:@"新身份证icon"];
    }
    
    return _IdCardImg;
}

- (UITextField *)CreateIdCardNumTextField {
    
    if (!_IdCardNumTextField) {
        _IdCardNumTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(64, 178, DMDeviceWidth - 64 - 48 , 50) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _IdCardNumTextField.placeholder = @"身份证号码";
        _IdCardNumTextField.textColor = WITHEBACK_INPUT;
        _IdCardNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _IdCardNumTextField.font = [UIFont systemFontOfSize:14];
        [_IdCardNumTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        
    }

    
    
    UILabel *userPassWordline = [[UILabel alloc] init];
    userPassWordline.frame = CGRectMake(74, 215, DMDeviceWidth - 48 - 74, 1);
    userPassWordline.backgroundColor = WITHEBACK_LINE;
    [self.view addSubview:userPassWordline];
    
    
    return _IdCardNumTextField;
    
}



- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (self.IdCardNumTextField.text.length > 0 && self.realnameTextField.text.length > 0) {
        
        [_testBtn setImage:[UIImage imageNamed:@"立即认证-填写正确"] forState:UIControlStateNormal];
        [_testBtn setImage:[UIImage imageNamed:@"立即认证-填写正确"] forState:UIControlStateHighlighted];
        
    } else {
        
        [_testBtn setImage:[UIImage imageNamed:@"立即认证-默认"] forState:UIControlStateNormal];
        [_testBtn setImage:[UIImage imageNamed:@"立即认证-默认"] forState:UIControlStateHighlighted];

        
        
    }
    
    
    if (textField == self.IdCardNumTextField) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
            ShowMessage(@"身份证不能超过18位");
        }
    }
    

}




- (UIButton *)CreateTestBtn {
    
    if (!_testBtn) {
        
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _testBtn.frame = CGRectMake((DMDeviceWidth - 294/2)/2, _IdCardNumTextField.frame.origin.y +_IdCardNumTextField.frame.size.height + 27 + 168/2, 294/2, 74/2);
        [_testBtn setImage:[UIImage imageNamed:@"立即认证-默认"] forState:UIControlStateNormal];
        [_testBtn setImage:[UIImage imageNamed:@"立即认证-默认"] forState:UIControlStateHighlighted];
        [_testBtn addTarget:self action:@selector(TestAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
    }
    
    return _testBtn;
    
}



- (void)TestAction {
    
    if ([self isEmpty:_realnameTextField.text]) {
        ShowMessage(@"请输入姓名");
    } else if ([self isEmpty:_IdCardNumTextField.text]){
        
        UILabel *prompt = [[UILabel alloc] init];
        prompt.frame = CGRectMake(48, _IdCardNumTextField.frame.origin.y +_IdCardNumTextField.frame.size.height + 17, DMDeviceWidth - 48*2, 10);
        prompt.text = @"身份证号码有误，请重新输入";
        prompt.font = [UIFont systemFontOfSize:10];
        prompt.textColor = UIColorFromRGB(0xffcd8d);
        [self.view addSubview:prompt];
    } else if (![self validateIdentityCard:_IdCardNumTextField.text]){
        ShowMessage(@"身份证号不合法，请重新输入");
    } else {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[LJQMineRequestManager RequestManager] LJQRealNameIdNumber:_IdCardNumTextField.text name:_realnameTextField.text successBlock:^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ShowMessage(@"认证成功");
            [[NSUserDefaults standardUserDefaults] setObject:_realnameTextField.text forKey:@"realName"];
            [self performSelector:@selector(backToEarly) withObject:nil afterDelay:1];
            
        } faild:^(NSString *message, BOOL status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ShowMessage(message);
        }];
    }
}

#pragma mark -- 点击空白收起输入框
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)backToEarly {
    
    DMAddBandCardViewController *addbandcard = [[DMAddBandCardViewController alloc] init];
    addbandcard.realName = _realnameTextField.text;
    addbandcard.IdcardNum = _IdCardNumTextField.text;
    [self.navigationController pushViewController: addbandcard animated:YES];
}


- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


@end
