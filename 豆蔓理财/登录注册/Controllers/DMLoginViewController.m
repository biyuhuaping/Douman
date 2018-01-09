 //
//  DMLoginViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMLoginViewController.h"
#import "LLLockViewController.h"
#import "DMForgetPassWordViewController.h"
#import "DMRegisterViewController.h"
#import "DMLoginRequestManager.h"
#import "HMTabBarViewController.h"
#import "DMSettingManager.h"

#import "LJQUserInfoModel.h"

#import "DMSettransactionpasswordViewController.h"

@interface DMLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong)UIImageView *LogoView;
@property (nonatomic, strong)UIImageView *phoneImg;
@property (nonatomic, strong)UIImageView *passWordImg;

@property (nonatomic, strong)UITextField *userNameTextField;
@property (nonatomic, strong)UITextField *userPassWordTextField;

//@property (nonatomic, strong)UIButton *goBackBtn;
@property (nonatomic, strong)UIButton *hidePassWordBtn;
@property (nonatomic, strong)UIButton *forgetPassWordBtn;
@property (nonatomic, strong)UIButton *LoginBtn;
@property (nonatomic, strong)UIButton *RegisterBtn;

@property (nonatomic, assign)BOOL isHide;
@property (nonatomic, nonnull, strong) UILabel *prompt;//提示

@property (nonatomic, strong)LJQUserInfoModel *userModel;

@property (nonatomic, copy)NSString *name; //姓名
@property (nonatomic, copy)NSString *account;//银行账户
@property (nonatomic, copy)NSString *bank; //银行名称
@property (nonatomic, copy)NSString *mobile;//手机
@property (nonatomic, copy)NSString *idNumber; //身份证号


@end

@implementation DMLoginViewController



- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        _isHide = false;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"登录";
    [self.view addSubview:self.CreateLogoimg];
//    [self.view addSubview:self.CreatePhoneImg];
    [self.view addSubview:self.CreateUserNameTextField];
//    [self.view addSubview:self.CreatePassWordImg];
    [self.view addSubview:self.CreateUserPassWordTextField];
    [self.view addSubview:self.CreateforgetBtn];
    [self.view addSubview:self.CreatelogintBtn];
    [self.view addSubview:self.CreateregisterBtn];
    [self.view addSubview:self.prompt];
    
    __weak __typeof(self) weakSelf = self;
    [self.RegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(97/2));
        make.height.mas_equalTo(@(13));
        make.centerX.mas_equalTo(self.view);
        if (weakSelf.isExpanded) {
            make.bottom.mas_equalTo(-130);
        } else {
            make.bottom.mas_equalTo(-15);
        }
    }];
}



- (UIImageView *)CreateLogoimg{
    
    if (!_LogoView) {
        _LogoView = [[UIImageView alloc] init];
        _LogoView.frame = CGRectMake((DMDeviceWidth - 146)/2 + 20, 43 , 146, 75);
        _LogoView.contentMode = UIViewContentModeScaleAspectFill;
        _LogoView.image = [UIImage imageNamed:@"logo_picture"];
    }
    
    return _LogoView;
}

- (UIImageView *)CreatePhoneImg {
    
    if (!_phoneImg) {
        _phoneImg = [[UIImageView alloc] init];
        _phoneImg.frame = CGRectMake(48,  178.5, 10, 15);
        _phoneImg.image = [UIImage imageNamed:@"手机iconblue"];
    }
    
    return _phoneImg;
}


- (UITextField *)CreateUserNameTextField {
    
    
    if (!_userNameTextField) {

        _userNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 160, DMDeviceWidth - 75, 50) PlaceHoldFont:12 PlaceHoldColor:LightGray]; /////////////////4b6ca7
        _userNameTextField.placeholder = @"请输入账号";
        _userNameTextField.textColor = DarkGray; /////////////////86a7e8
        _userNameTextField.font = [UIFont systemFontOfSize:14];
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameTextField.keyboardType = UIKeyboardTypeDefault;
        _userNameTextField.text = PhoneNumber;
        UILabel *userNameline = [[UILabel alloc] init];
        userNameline.frame = CGRectMake(35, 197, DMDeviceWidth - 70, 0.7);
        userNameline.backgroundColor = UIColorFromRGB(0xececec); ////////////23395f
        [self.view addSubview:userNameline];
    }

    
    return _userNameTextField;
}



- (UIImageView *)CreatePassWordImg {
    
    if (!_passWordImg) {
        _passWordImg = [[UIImageView alloc] init];
        _passWordImg.frame = CGRectMake(48, 247 , 10, 16);
        _passWordImg.image = [UIImage imageNamed:@"登录密码icon.png"];
    }
    
    return _passWordImg;
}

- (UITextField *)CreateUserPassWordTextField {
    
    if (!_userPassWordTextField) {
        _userPassWordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 230, DMDeviceWidth - 40 - 48 - 24, 50) PlaceHoldFont:12 PlaceHoldColor:LightGray]; ///////////////4b6ca7
        _userPassWordTextField.placeholder = @"请输入登录密码";
        //变成小点点的那个方法
        _userPassWordTextField.secureTextEntry = true;
        _userPassWordTextField.textColor = DarkGray; ////////////////86a7e8
        _userPassWordTextField.font = [UIFont systemFontOfSize:14];
        _userPassWordTextField.delegate = self;
        _userPassWordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _userPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _hidePassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hidePassWordBtn.frame = CGRectMake(DMDeviceWidth - 45 - 17*2 + 17/2, 243, 34, 24);
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateNormal]; ///////////////不显示密码
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateHighlighted]; ///////////////不显示密码
        [_hidePassWordBtn addTarget:self action:@selector(hidePassWordAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_hidePassWordBtn];
        
        UILabel *userPassWordline = [[UILabel alloc] init];
        userPassWordline.frame = CGRectMake(35, 267, DMDeviceWidth - 70, 0.7);
        userPassWordline.backgroundColor = UIColorFromRGB(0xececec); ////////////23395f
        [self.view addSubview:userPassWordline];
    }
    return _userPassWordTextField;
}



- (void)hidePassWordAction {
    
    if (_isHide) {
        _isHide = false;
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateNormal]; ///////////////不显示密码
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateHighlighted];/////////////不显示密码
        _userPassWordTextField.secureTextEntry = true;
        
    } else {
        
        _isHide = true;
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"lighten_icon"] forState:UIControlStateNormal]; /////////////显示密码
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"lighten_icon"] forState:UIControlStateHighlighted];////////////显示密码
        _userPassWordTextField.secureTextEntry = false;
        
    }
    
}


- (UIButton *)CreateforgetBtn {
    
    if (!_forgetPassWordBtn) {
        
        _forgetPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPassWordBtn.frame = CGRectMake(DMDeviceWidth - 30 - 60, 285, 60, 12);
        [_forgetPassWordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPassWordBtn setTitleColor:LightGray forState:UIControlStateNormal]; ////////////////4b6ca7
        _forgetPassWordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetPassWordBtn addTarget:self action:@selector(forgetPassWordAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _forgetPassWordBtn;
    
}

- (void)forgetPassWordAction {
    
    DMForgetPassWordViewController *forgetpassword = [[DMForgetPassWordViewController alloc] init];
    forgetpassword.mine = self.mine;
    [self.navigationController pushViewController:forgetpassword animated:YES];
    
}

- (UIButton *)CreatelogintBtn {
    
    if (!_LoginBtn) {
        
        _LoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _LoginBtn.frame = CGRectMake((DMDeviceWidth - 197)/2, _userPassWordTextField.frame.origin.y +_userPassWordTextField.frame.size.height + 7 + 60, 197, 37);
        [_LoginBtn setImage:[UIImage imageNamed:@"The-login_button"] forState:UIControlStateNormal]; //////////////登--录
        _LoginBtn.adjustsImageWhenHighlighted = NO;
        [_LoginBtn setImage:[UIImage imageNamed:@"The-login_button"] forState:UIControlStateHighlighted];
        [_LoginBtn addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _LoginBtn;
}


- (UILabel *)prompt {
    
    if (!_prompt) {
        _prompt = [[UILabel alloc] init];
        _prompt.frame = CGRectMake(30, _LoginBtn.frame.origin.y +_LoginBtn.frame.size.height + 20, DMDeviceWidth-60, 12);
        _prompt.textAlignment = NSTextAlignmentCenter;
        _prompt.text = @"市场有风险，投资需谨慎";
        _prompt.font = SYSTEMFONT(12);
        _prompt.textColor = DarkGray; /////////////////86a7e8
    }
    
    return _prompt;
    
}


- (void)LoginAction {
    
    if (_userNameTextField.text.length == 0 || _userPassWordTextField.text.length == 0) {
        ShowMessage(@"账号或密码不能为空");
    } else {
        
        [self request];
    }

}


//登录接口
- (void)request {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DMLoginRequestManager manager] loginWithUserName:self.userNameTextField.text PassWord:self.userPassWordTextField.text Success:^() {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self requestbindcard];
    } Faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void) requestbindcard {
    
    if (_current) {
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.LoginSuccess) {
            self.LoginSuccess();
            
        }
    } else {
        
        
        if (!Lock) {
            
            LLLockViewController *lockVC = [[LLLockViewController alloc] init];
            lockVC.nLockViewType = LLLockViewTypeCreate;
            lockVC.leftType = @"login";
            [[self topViewController].navigationController pushViewController:lockVC animated:YES];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}



- (UIButton *)CreateregisterBtn {
    
    if (!_RegisterBtn) {
        _RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _RegisterBtn.frame = CGRectMake((DMDeviceWidth - 97/2)/2, DMDeviceHeight - 13 - 15 - 64*2, 97/2, 13);
        [_RegisterBtn setImage:[UIImage imageNamed:@"Quick-registration"] forState:UIControlStateNormal]; //////////////快速注册
        [_RegisterBtn setImage:[UIImage imageNamed:@"Quick-registration"] forState:UIControlStateHighlighted];
        [_RegisterBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _RegisterBtn;
    
}

- (void)registerAction {
    DMRegisterViewController *dmregister = [[DMRegisterViewController alloc] init];
    dmregister.login = YES;
    [self.navigationController pushViewController:dmregister animated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 120;
    [self.view registerAsDodgeViewForMLInputDodger];
}

@end
