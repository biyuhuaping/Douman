//
//  DMForgetPassWordViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMForgetPassWordViewController.h"
#import "DMReplaceViewController.h"
#import "DMLoginRequestManager.h"
#import "DMCodeView.h"

@interface DMForgetPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) DMCodeView *Code;

@property (nonatomic, strong) UIImageView *PhoneNumImg;
@property (nonatomic, strong) UIImageView *calibrateImg;
@property (nonatomic, strong) UIImageView *testcodeImg;

@property (nonatomic, strong) UITextField *PhoneNumTextField;
@property (nonatomic, strong) UITextField *calibrateTextField;
@property (nonatomic, strong) UITextField *testcodeTextField;

@property (nonatomic, strong) UIButton *sendtestcodeBtn;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int second;

@end

@implementation DMForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"找回密码";
    
    [self CreateUI];
    
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 64, DMDeviceWidth, DMDeviceHeight);
    }];
    
    
}


- (void)CreateUI {
//    [self.view addSubview:self.CreatePhoneNumImg];
    [self.view addSubview:self.CreateUserNameTextField];
//    [self.view addSubview:self.CreateCalibrateImg];
    [self.view addSubview:self.CreateCalibrateTextField];
    [self.view addSubview:self.CreateCode];
//    [self.view addSubview:self.CreateTestcodeImg];
    [self.view addSubview:self.CreateTestcodeTextField];
    [self.view addSubview:self.CreatesSendtestcodeBtn];
    [self.view addSubview:self.CreatesNextBtn];
    
}


- (UIImageView *)CreatePhoneNumImg {
    
    if (!_PhoneNumImg) {
        _PhoneNumImg = [[UIImageView alloc] init];
        _PhoneNumImg.frame = CGRectMake(48, 48, 10, 15);
        _PhoneNumImg.image = [UIImage imageNamed:@"手机iconblue"];
    }
    
    return _PhoneNumImg;
}


- (UITextField *)CreateUserNameTextField {
    
    if (!_PhoneNumTextField) {
        _PhoneNumTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 30, DMDeviceWidth - 75, 50) PlaceHoldFont:12 PlaceHoldColor:LightGray]; ////////////4b6ca7
        _PhoneNumTextField.placeholder = @"请输入您注册时使用的手机号";
        _PhoneNumTextField.font = [UIFont systemFontOfSize:14];
        _PhoneNumTextField.clearButtonMode = UITextFieldViewModeAlways;
        _PhoneNumTextField.textColor = DarkGray; ///////////////86a7e8
        [_PhoneNumTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        _PhoneNumTextField.text = PhoneNumber;
        
        //自定义清除按钮
        UIButton *clearButton = [_PhoneNumTextField valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateNormal]; ///////////清除icon
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateHighlighted];

        
    }
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(35, 67, DMDeviceWidth - 70, 0.7);
    line.backgroundColor = UIColorFromRGB(0xececec); ////////////23395f
    [self.view addSubview:line];

    return _PhoneNumTextField;
    
}



- (UIImageView *)CreateCalibrateImg {
    
    if (!_calibrateImg) {
        _calibrateImg = [[UIImageView alloc] init];
        _calibrateImg.frame = CGRectMake(48,110, 23/2, 25/2);
        _calibrateImg.image = [UIImage imageNamed:@"检验码icon"];
    }
    
    return _calibrateImg;
}

- (UITextField *)CreateCalibrateTextField {
    
    if (!_calibrateTextField) {
        _calibrateTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 92, DMDeviceWidth - 35 - 48 - 110, 50) PlaceHoldFont:12 PlaceHoldColor:LightGray]; /////////////4b6ca7
        _calibrateTextField.placeholder = @"请输入校验码";
        _calibrateTextField.secureTextEntry = false;
        _calibrateTextField.textColor = DarkGray; /////////////86a7e8
        _calibrateTextField.delegate = self;
        _calibrateTextField.keyboardType = UIKeyboardTypeNumberPad;
        _calibrateTextField.font = [UIFont systemFontOfSize:14];
        [_calibrateTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        
    }
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(35, 129, DMDeviceWidth - 145, 0.7);
    line.backgroundColor = UIColorFromRGB(0xececec); //////////////23395f
    [self.view addSubview:line];
    return _calibrateTextField;
}




/*
*
* 手机号的合法性
*
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _calibrateTextField) {
        
        if (![self checkMobileNumber:_calibrateTextField.text]) {
            ShowMessage(@"手机号不合法");
        }
    }
}
 */


- (DMCodeView *)CreateCode {
    _Code = [[DMCodeView alloc] initWithFrame:CGRectMake(DMDeviceWidth -105, 102, 70, 26)];
    return _Code;
}

- (UIImageView *)CreateTestcodeImg {
    
    if (!_testcodeImg) {
        _testcodeImg = [[UIImageView alloc] init];
        _testcodeImg.frame = CGRectMake(48,  172, 23/2, 25/2);
        _testcodeImg.image = [UIImage imageNamed:@"检验码icon"];
    }
    return _testcodeImg;
}

- (UITextField *)CreateTestcodeTextField {
    
    if (!_testcodeTextField) {
        _testcodeTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 154, DMDeviceWidth - 35 - 48 - 110, 50) PlaceHoldFont:12 PlaceHoldColor:LightGray]; //////////////4b6ca7
        _testcodeTextField.placeholder = @"请输入短信验证码";
        _testcodeTextField.secureTextEntry = false;
        _testcodeTextField.textColor = DarkGray; ///////////86a7e8
        _testcodeTextField.delegate = self;
        _testcodeTextField.font = [UIFont systemFontOfSize:14];
        _testcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        
    }

    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(35, 191, DMDeviceWidth - 150, 0.7);
    line.backgroundColor = UIColorFromRGB(0xececec); //////////////23395f
    [self.view addSubview:line];
    
    
    return _testcodeTextField;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _testcodeTextField) {
        if (_calibrateTextField.text.length == 0) {
            ShowMessage(@"输入的校验码不能为空");
            return NO;
        } else if (![_calibrateTextField.text isEqualToString: _Code.changeString]) {
            ShowMessage(@"您输入的校验码不正确,请重新输入");
            return NO;
        } else {
            return YES;
        }
        return YES;
    }
    return YES;
}



- (UIButton *)CreatesSendtestcodeBtn {
    
    if (!_sendtestcodeBtn) {
        
        _sendtestcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendtestcodeBtn.frame = CGRectMake(DMDeviceWidth -110, 169, 75, 19);
        _sendtestcodeBtn.layer.cornerRadius = 8;
        _sendtestcodeBtn.layer.borderColor = UIColorFromRGB(0xfc6f57).CGColor;
        _sendtestcodeBtn.layer.borderWidth = 1;
        [_sendtestcodeBtn setTitleColor:UIColorFromRGB(0xfc6f57) forState:UIControlStateNormal];
        [_sendtestcodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendtestcodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendtestcodeBtn addTarget:self action:@selector(SendtestcodeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendtestcodeBtn];
        
    }
    
    return _sendtestcodeBtn;
    
}

- (void)SendtestcodeAction {
    self.second = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(subSeconds) userInfo:nil repeats:YES];

    if (_calibrateTextField.text.length == 0) {
        ShowMessage(@"输入的校验码不能为空");
    } else if (![_calibrateTextField.text isEqualToString: _Code.changeString]) {
        ShowMessage(@"您输入的校验码不正确,请重新输入");
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DMLoginRequestManager manager] findPassWordWithPhoneNumber:_PhoneNumTextField.text Success:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ShowMessage(@"发送成功");
        } Faild:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ShowMessage(@"发送验证码失败");
            self.sendtestcodeBtn.userInteractionEnabled = YES;
            [self.sendtestcodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [self.timer invalidate];
            self.timer = nil;
        }];
    }
}

- (void)subSeconds{
    self.second--;
    self.sendtestcodeBtn.userInteractionEnabled = NO;
    [self.sendtestcodeBtn setTitle:[NSString stringWithFormat:@"%ds",self.second] forState:UIControlStateNormal];
    if (self.second == 0) {
        self.sendtestcodeBtn.userInteractionEnabled = YES;
        [self.sendtestcodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}



- (UIButton *)CreatesNextBtn {
    
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake((DMDeviceWidth - 197)/2, _testcodeTextField.frame.origin.y +_testcodeTextField.frame.size.height + 7 + 80, 197, 74/2);
        [_nextBtn setImage:[UIImage imageNamed:@"The-next-step"] forState:UIControlStateNormal]; ////////////找回-下一步
        [_nextBtn setImage:[UIImage imageNamed:@"The-next-step"] forState:UIControlStateHighlighted];
        [_nextBtn addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)NextAction {
    if (_PhoneNumTextField.text.length == 0) {
        ShowMessage(@"手机号不能为空");
    } else if (![[CheckMobile manager] checkMobileNumber:_PhoneNumTextField.text]){
        ShowMessage(@"手机号不合法");
    } else if (_calibrateTextField.text.length == 0) {
        ShowMessage(@"检验吗不能为空");
    } else if ([_testcodeTextField.text isEqualToString: @""]){
        ShowMessage(@"短信验证码不能为空");
    } else {
        DMReplaceViewController *replace = [[DMReplaceViewController alloc] init];
        replace.PhoneNum = _PhoneNumTextField.text;
        replace.captcha = _testcodeTextField.text;
        replace.mine = self.mine;
        [self.navigationController pushViewController:replace animated:YES];
    }
}






- (void)textFieldDidChange:(UITextField *)textField{
    
    if (textField == self.PhoneNumTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
            ShowMessage(@"手机号不能超过11位");
        }
        
    } else if (textField == _calibrateTextField) {
        
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:11];
            ShowMessage(@"校验码不能超过4位");
        }
        
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
