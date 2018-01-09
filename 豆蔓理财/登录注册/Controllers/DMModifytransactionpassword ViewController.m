//
//  DMModifytransactionpassword ViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMModifytransactionpassword ViewController.h"
#import "DMSettransactionpasswordViewController.h"

@interface DMModifytransactionpassword_ViewController ()

@property (nonatomic, strong) UIImageView *phonenumImg;
@property (nonatomic, strong) UIImageView *sendtestImg;

@property (nonatomic, strong) UITextField *phonenumTextField;
@property (nonatomic, strong) UITextField *sendtestTextField;


@property (nonatomic, strong) UIButton *sendtestcodeBtn;
@property (nonatomic, strong) UIButton *nextBtn;


@property (nonatomic ,copy) NSString *captcha;

@end

@implementation DMModifytransactionpassword_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.img.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:self.phonenumImg];
    [self.view addSubview:self.phonenumTextField];
    [self.view addSubview:self.sendtestImg];
    [self.view addSubview:self.sendtestTextField];
    [self.view addSubview:self.sendtestcodeBtn];
    [self.view addSubview:self.nextBtn];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_phonenumTextField resignFirstResponder];
    [_sendtestTextField resignFirstResponder];
}

- (UIImageView *)phonenumImg {
    
    if (!_phonenumImg) {
        _phonenumImg = [[UIImageView alloc] init];
        _phonenumImg.frame = CGRectMake(48,  48, 10, 15);
        _phonenumImg.image = [UIImage imageNamed:@"手机iconblue"];
    }
    
    return _phonenumImg;
}


- (UITextField *)phonenumTextField {
    
    if (!_phonenumTextField) {
        _phonenumTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(64, 30, DMDeviceWidth - 74-48, 50) PlaceHoldFont:12 PlaceHoldColor:UIColorFromRGB(0X4b6ca7)];
        _phonenumTextField.placeholder = @"请输入您注册时使用的手机号";
        _phonenumTextField.textColor = WITHEBACK_INPUT;
        _phonenumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phonenumTextField.font = [UIFont systemFontOfSize:14];
        _phonenumTextField.clearButtonMode = UITextFieldViewModeAlways;
        [_phonenumTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];

    }
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(74, 67, DMDeviceWidth - 48 - 74, 1);
    line.backgroundColor = WITHEBACK_LINE;
    [self.view addSubview:line];
    
    return _phonenumTextField;
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    
    
    
    if (self.phonenumTextField.text.length > 0 && self.sendtestTextField.text.length >0) {
        
        [_nextBtn setImage:[UIImage imageNamed:@"新下一步-填写正确"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"新下一步-填写正确"] forState:UIControlStateHighlighted];

        
    } else {
        
        [_nextBtn setImage:[UIImage imageNamed:@"新下一步-默认"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"新下一步-默认"] forState:UIControlStateHighlighted];

    }
    
    
    
    if (textField == self.phonenumTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
            ShowMessage(@"手机号不能超过11位");
        }
        
    }
}




- (UIImageView *)sendtestImg {
    
    if (!_sendtestImg) {
        _sendtestImg = [[UIImageView alloc] init];
        _sendtestImg.frame = CGRectMake(48,  110, 23/2, 25/2);
        _sendtestImg.image = [UIImage imageNamed:@"检验码icon"];
    }
    
    return _sendtestImg;
}

- (UITextField *)sendtestTextField {
    
    if (!_sendtestTextField) {
        _sendtestTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(64, 92, DMDeviceWidth - 74 - 48 - 34, 50) PlaceHoldFont:12 PlaceHoldColor:UIColorFromRGB(0X4b6ca7)];
        _sendtestTextField.placeholder = @"请输入校验码";
        _sendtestTextField.secureTextEntry = false;
        _sendtestTextField.textColor = UIColorFromRGB(0x86a7e8);
        _sendtestTextField.font = [UIFont systemFontOfSize:14];
        _sendtestTextField.textColor = WITHEBACK_INPUT;
        [_sendtestTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];

        
    }
    
    
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(74, 129, DMDeviceWidth - 105 - 74, 1);
    line.backgroundColor = WITHEBACK_LINE;
    [self.view addSubview:line];
    
    
    return _sendtestTextField;
    
}



- (UIButton *)sendtestcodeBtn {
    
    if (!_sendtestcodeBtn) {
        
        _sendtestcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendtestcodeBtn.frame = CGRectMake(DMDeviceWidth -100, 110 , 75, 19);
        _sendtestcodeBtn.layer.cornerRadius = 8;
        _sendtestcodeBtn.layer.borderColor = UIColorFromRGB(0xffd542).CGColor;
        _sendtestcodeBtn.layer.borderWidth = 1;
        [_sendtestcodeBtn setTitleColor:UIColorFromRGB(0xffd542) forState:UIControlStateNormal];
        [_sendtestcodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendtestcodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendtestcodeBtn addTarget:self action:@selector(SendtestcodeAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _sendtestcodeBtn;
    
}

- (void)SendtestcodeAction {
    
    if (![[CheckMobile manager] checkMobileNumber:_phonenumTextField.text]){
        ShowMessage(@"手机号不合法");
    } else {
        LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
        [manager LJQSendTradeSmsCaptchaMobile:_phonenumTextField.text successBlock:^{
            
            __block int time = 60;
            __block UIButton *verifybutton = _sendtestcodeBtn;
            verifybutton.enabled = NO;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(time<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        verifybutton.backgroundColor = [UIColor clearColor];
                        [verifybutton setTitle:@"重新获取" forState:UIControlStateNormal];
                        verifybutton.enabled = YES;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        verifybutton.backgroundColor = [UIColor clearColor];
                        NSString *strTime = [NSString stringWithFormat:@"%dS",time];
                        [verifybutton setTitle:strTime forState:UIControlStateNormal];
                    });
                    time--;
                }
            });
            dispatch_resume(_timer);
            
        } faild:^(NSString *message) {
            NSLog(@"%@",message);
        }];
 
    }
    
}


- (UIButton *)nextBtn {
    
    if (!_nextBtn) {
        
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake((DMDeviceWidth - 294/2)/2, _sendtestTextField.frame.origin.y +_sendtestTextField.frame.size.height + 7 + 80, 294/2, 74/2);
        [_nextBtn setImage:[UIImage imageNamed:@"新下一步-默认"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"新下一步-默认"] forState:UIControlStateHighlighted];
        [_nextBtn addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _nextBtn;
    
}

- (void)NextAction {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQCheckTradeSmsCaptchaSmsCaptcha:_sendtestTextField.text successBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DMSettransactionpasswordViewController *settran = [[DMSettransactionpasswordViewController alloc] init];
        settran.code = _sendtestTextField.text;
        settran.sure = NO;
        [self.navigationController pushViewController:settran animated:YES];
    } faild:^(NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowMessage(message);
    }];
}



@end
