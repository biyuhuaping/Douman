//
//  DMConfirmationViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMConfirmationViewController.h"
#import "LLLockViewController.h"
#import "DMLoginRequestManager.h"
#import "LJQCouponsVC.h"

@interface DMConfirmationViewController ()

@property (nonatomic, strong)UITextField *SMScodeTextField;


@property (nonatomic, strong)UIButton *SMScodeBtn;
@property (nonatomic, strong)UIButton *seepchBth;
@property (nonatomic, strong)UIButton *finishBth;


@end

@implementation DMConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.title = @"发送验证码";
    
    [self CreateUI];
    
}

#pragma mark - keyboardHight
-(void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerForKeyboardNotifications
{
    
   [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}




- (void)keyboardWasShown:(NSNotification*)aNotification
{

    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, -80+64, DMDeviceWidth, DMDeviceHeight);
    }];
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 64, DMDeviceWidth, DMDeviceHeight);
    }];
    
    
}




-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_SMScodeTextField resignFirstResponder];

}



- (void)CreateUI {
    
    UILabel *PromptLabel = [[UILabel alloc] init];
    PromptLabel.frame = CGRectMake(0,  67, DMDeviceWidth, 20);
    PromptLabel.text = @"已发送验证码短信到";
    PromptLabel.textColor = DarkGray; /////////////4c6ca7
    PromptLabel.textAlignment = NSTextAlignmentCenter;
    PromptLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:PromptLabel];
    

    [self.view addSubview:self.CreatePhoneNum];
    [self.view addSubview:self.CreateSMScodeTextField];
    [self CreateseepchView];
    [self.view addSubview:self.CreatefinishBtn];

}




- (UILabel *)CreatePhoneNum {
    
    if (!_PhoneNum) {
        _PhoneNum = [[UILabel alloc] init];
        _PhoneNum.frame = CGRectMake(0,  67 + 20 + 14, DMDeviceWidth, 25);
        _PhoneNum.textAlignment = NSTextAlignmentCenter;
        _PhoneNum.textColor = LightGray; //////////////86a7e8
        _PhoneNum.font = [UIFont boldSystemFontOfSize:25];
        NSString *tel = [self.userNameStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _PhoneNum.text = tel;
       
    }
    return _PhoneNum;
}

- (UITextField *)CreateSMScodeTextField {
    
    if (!_SMScodeTextField) {
        _SMScodeTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(48 +20, _PhoneNum.frame.origin.y +_PhoneNum.frame.size.height + 25, DMDeviceWidth - 48*2 - 20 - 75, 58) PlaceHoldFont:12 PlaceHoldColor:LightGray];
        _SMScodeTextField.placeholder = @"短信验证码";
        _SMScodeTextField.font = [UIFont systemFontOfSize:14];
        _SMScodeTextField.textAlignment = NSTextAlignmentCenter;
        _SMScodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _SMScodeTextField.textColor = DarkGray;

    }
    
    
    _SMScodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SMScodeBtn.frame = CGRectMake(DMDeviceWidth -48 - 75 , _PhoneNum.frame.origin.y +_PhoneNum.frame.size.height + 40, 75, 19);
    
    _SMScodeBtn.layer.cornerRadius = 8;
    _SMScodeBtn.layer.borderColor = MainRed.CGColor;
    _SMScodeBtn.layer.borderWidth = 1;
    [_SMScodeBtn setTitleColor:MainRed forState:UIControlStateNormal];
    _SMScodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_SMScodeBtn addTarget:self action:@selector(SMScodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_SMScodeBtn];
    
    
    [[DMLoginRequestManager manager]msmCaptchaWithPhoneNumber:self.userNameStr Success:^{
        
    } Faild:^{
        
    }];
    
    
    __block int time = 59;
    __block UIButton *verifybutton = _SMScodeBtn;
    verifybutton.enabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{

                verifybutton.backgroundColor = [UIColor clearColor];
                [verifybutton setTitle:@"重新获取" forState:UIControlStateNormal];
                verifybutton.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{

                verifybutton.backgroundColor = [UIColor clearColor];
                NSString *strTime = [NSString stringWithFormat:@"%dS",time];
                [verifybutton setTitle:strTime forState:UIControlStateNormal];

            });
            time--;
        }
    });
    dispatch_resume(_timer);


    
    
    UILabel *SMScodeline = [[UILabel alloc] init];
    SMScodeline.frame = CGRectMake(35, _SMScodeBtn.frame.origin.y +_SMScodeBtn.frame.size.height + 7, DMDeviceWidth - 70, 0.7);
    SMScodeline.backgroundColor = UIColorFromRGB(0xececec);
    [self.view addSubview:SMScodeline];
    
    
    return _SMScodeTextField;
    
}

- (void)SMScodeAction {
    
    
    
    [[DMLoginRequestManager manager]msmCaptchaWithPhoneNumber:self.userNameStr Success:^{
        
    } Faild:^{
        
    }];

    
    __block int time = 61;
    __block UIButton *verifybutton = _SMScodeBtn;
    verifybutton.enabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{

                verifybutton.backgroundColor = [UIColor clearColor];
                [verifybutton setTitle:@"重新获取" forState:UIControlStateNormal];
                verifybutton.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                verifybutton.backgroundColor = [UIColor clearColor];
                NSString *strTime = [NSString stringWithFormat:@"%dS",time];
                [verifybutton setTitle:strTime forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_timer);

    
    
}

- (void)CreateseepchView {
    
    UIImageView *seepchView = [[UIImageView alloc] init];
    seepchView.frame = CGRectMake((DMDeviceWidth - 335/2)/2, _SMScodeBtn.frame.origin.y +_SMScodeBtn.frame.size.height + 7 + 56, 335/2, 26/2);
    seepchView.image = [UIImage imageNamed:@"收不到验证码？获取语音验证码"];
    [self.view addSubview:seepchView];
    
    if (!_seepchBth) {
        
        _seepchBth = [UIButton buttonWithType:UIButtonTypeCustom];
        _seepchBth.frame = CGRectMake((DMDeviceWidth - 335/2)/2+80,  _SMScodeBtn.frame.origin.y +_SMScodeBtn.frame.size.height + 7 + 56, 100, 13);
        _seepchBth.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_seepchBth addTarget:self action:@selector(SeepchAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_seepchBth];
    }
}

- (void)SeepchAction {
    
    
    
    [[DMLoginRequestManager manager]smsVoiceCaptchaWithPhoneNumber:self.userNameStr Success:^{
        
    } Faild:^{
        ShowMessage(@"请检查你的网络");
    }];
    
    
}

- (UIButton *)CreatefinishBtn {
    
    if (!_finishBth) {
        
        _finishBth = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBth.frame = CGRectMake((DMDeviceWidth - 197)/2, _SMScodeBtn.frame.origin.y +_SMScodeBtn.frame.size.height + 7 + 56 + 80, 197, 37);
        [_finishBth setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
        [_finishBth setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateHighlighted];
        [_finishBth addTarget:self action:@selector(finishBthAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _finishBth;
    
}


- (void)finishBthAction {
    
    if (_SMScodeTextField.text.length == 0) {
        ShowMessage(@"请填写验证码");
    } else {
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DMLoginRequestManager manager] userRegisterWithPhoneNumber:self.userNameStr Captcha:_SMScodeTextField.text PassWord:self.userPassWord Success:^(){
            [[DMLoginRequestManager manager] loginWithUserName:self.userNameStr PassWord:self.userPassWord Success:^(){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"注册红包发送至账户" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

                    LLLockViewController *lockVC = [[LLLockViewController alloc] init];
                    lockVC.nLockViewType = LLLockViewTypeCreate;
                    lockVC.leftType = @"login";
                    [self.navigationController pushViewController:lockVC animated:YES];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"查看礼包" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController pushViewController:[[LJQCouponsVC alloc] init] animated:YES];
                }];
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            } Faild:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        } Faild:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}




@end
