//
//  DMRegisterViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMRegisterViewController.h"
#import "DMConfirmationViewController.h"
#import "DMLoginViewController.h"
#import "DMLoginRequestManager.h"
#import "DMWebUrlManager.h"
#import "DMWebViewController.h"


@interface DMRegisterViewController ()<UITextFieldDelegate>
{
    CGFloat keyboardhight;
    BOOL jugde;
}

@property (nonatomic, strong)UIImageView *LogoView;
@property (nonatomic, strong)UIImageView *phoneImg;
@property (nonatomic, strong)UIImageView *passWordImg;

@property (nonatomic, strong)UITextField *userNameTextField;
@property (nonatomic, strong)UITextField *userPassWordTextField;


@property (nonatomic, strong)UIButton *hidePassWordBtn;
@property (nonatomic, strong)UIButton *sureBtn;
@property (nonatomic, strong)UIButton *delegateBtn;
@property (nonatomic, strong)UIButton *LoginBtn;
@property (nonatomic, strong)UIButton *RegisterBtn;

@property (nonatomic, assign)BOOL isHide;
@property (nonatomic, assign)BOOL isSure;

@property (nonatomic, strong)UIView *buttonview;

@property (nonatomic, nonnull, strong) UILabel *prompt;//提示


@end

@implementation DMRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    _isHide = false;
    _isSure = true;
    jugde = false;

    
    [self.view addSubview:self.CreateLogoimg];
    
//    [self.view addSubview:self.CreatePhoneImg];
    [self.view addSubview:self.CreateUserNameTextField];
    
//    [self.view addSubview:self.CreatePassWordImg];
    [self.view addSubview:self.CreateUserPassWordTextField];
    
    [self.view addSubview:self.CreateSureBtn];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(59 , 283, 20, 15);
    [button addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.view addSubview:self.CreateDelegateBtn];
    [self.view addSubview:self.CreateRegisterBtnn];
    [self.view addSubview:self.CreateloginBtn];
    
    
    [self.view addSubview:self.prompt];
    
}

- (UIImageView *)CreateLogoimg{
    
    if (!_LogoView) {
        _LogoView = [[UIImageView alloc] init];
        _LogoView.frame = CGRectMake((DMDeviceWidth - 146)/2 + 20, 43, 146, 75);
        _LogoView.image = [UIImage imageNamed:@"logo_picture"];
        _LogoView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _LogoView;
}



- (UIImageView *)CreatePhoneImg {
    
    if (!_phoneImg) {
        _phoneImg = [[UIImageView alloc] init];
        _phoneImg.frame = CGRectMake(48,  _LogoView.frame.origin.y +_LogoView.frame.size.height + 60.5, 10, 15);
        _phoneImg.image = [UIImage imageNamed:@"手机iconblue"];
    }
    
    return _phoneImg;
}


- (UITextField *)CreateUserNameTextField {
    
    if (!_userNameTextField) {
        _userNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 160, DMDeviceWidth - 75, 50) PlaceHoldFont:12 PlaceHoldColor:LightGray]; ///////////////4b6ca7
        _userNameTextField.placeholder = @"手机号";
        _userNameTextField.font = [UIFont systemFontOfSize:14];
        _userNameTextField.clearButtonMode = UITextFieldViewModeAlways;
        _userNameTextField.textColor = DarkGray; /////////////86a7e8
        _userNameTextField.delegate = self;
        [_userNameTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        _userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        //自定义清除按钮
        UIButton *clearButton = [self.userNameTextField valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateNormal]; /////////////清除icon
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateHighlighted];
        
    }
    UILabel *userNameline = [[UILabel alloc] init];
    userNameline.frame = CGRectMake(35, 197, DMDeviceWidth - 70, 0.7);
    userNameline.backgroundColor = UIColorFromRGB(0xececec); //////////////23395f
    [self.view addSubview:userNameline];
    
    
    return _userNameTextField;
    
}

- (UIImageView *)CreatePassWordImg {
    
    if (!_passWordImg) {
        _passWordImg = [[UIImageView alloc] init];
        _passWordImg.frame = CGRectMake(48, 247, 10, 16);
        _passWordImg.image = [UIImage imageNamed:@"登录密码icon.png"];
    }
    
    return _passWordImg;
}

- (UITextField *)CreateUserPassWordTextField {
    
    if (!_userPassWordTextField) {
        _userPassWordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 230, DMDeviceWidth - 35 - 48 - 34, 50) PlaceHoldFont:12 PlaceHoldColor:LightGray]; /////////////4b6ca7
        _userPassWordTextField.placeholder = @"请输入6-10位大小写英文及数字组合密码";
        _userPassWordTextField.secureTextEntry = YES;
        _userPassWordTextField.textColor = DarkGray; ///////////////86a7e8
        [_userPassWordTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        _userPassWordTextField.delegate = self;
        _userPassWordTextField.font = [UIFont systemFontOfSize:14];
        
    }
    _hidePassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hidePassWordBtn.frame = CGRectMake(DMDeviceWidth - 45 - 17*2 + 17/2, 243, 34, 24);
    [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateNormal]; ///////////不显示密码
    [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateHighlighted];
    [_hidePassWordBtn addTarget:self action:@selector(hidePassWordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hidePassWordBtn];
    
    
    UILabel *userPassWordline = [[UILabel alloc] init];
    userPassWordline.frame = CGRectMake(35, 267, DMDeviceWidth - 70, 0.7);
    userPassWordline.backgroundColor = UIColorFromRGB(0xececec); ///////////////23395f
    [self.view addSubview:userPassWordline];
    
    
    return _userPassWordTextField;
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == self.userNameTextField) {


        
        if (textField.text.length == 11) {
            
            [[DMLoginRequestManager manager] checkMobileWithPhoneNumber:_userNameTextField.text Success:^{
            
                
                jugde = true;
                
            } Faild:^(NSString *message) {
                
                ShowMessage(@"该用户已注册，请直接登录");
                jugde = false;
            }];
            
        }

    

      if (textField.text.length > 11) {

            textField.text = [textField.text substringToIndex:11];
            ShowMessage(@"手机号不能超过11位");
        }
    }else {
        
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
            ShowMessage(@"密码不能超过10位");
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if ((character < 48) ||(character > 57 && character < 65) || (character > 90 && character < 97) || (character > 122)){
            ShowMessage(@"不能输入特殊符号");
            return NO;
        }
        
    }
    return YES;
}


#pragma mark ------- 密码显示不显示
- (void)hidePassWordAction {
    
    if (_isHide) {
        _isHide = false;
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateNormal]; /////////////不显示密码
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"Don't-show"] forState:UIControlStateHighlighted];
        _userPassWordTextField.secureTextEntry = YES;
        
    } else {
        
        _isHide = true;
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"lighten_icon"] forState:UIControlStateNormal]; //////////////显示密码
        [_hidePassWordBtn setImage:[UIImage imageNamed:@"lighten_icon"] forState:UIControlStateHighlighted];
        _userPassWordTextField.secureTextEntry = NO;
        
    }
    
}

- (UIButton *)CreateSureBtn {
    
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(47, 285, 10, 10);
        [_sureBtn setImage:[UIImage imageNamed:@"round_highlight_icon"] forState:UIControlStateNormal]; /////////////勾选
        [_sureBtn setImage:[UIImage imageNamed:@"round_highlight_icon"] forState:UIControlStateHighlighted];

    }
    
    return _sureBtn;
}

- (void)sureAction {
    
    if (_isSure) {
        _isSure = false;
        [_sureBtn setImage:[UIImage imageNamed:@"round_default_icon"] forState:UIControlStateNormal]; ////////////////未勾选
        [_sureBtn setImage:[UIImage imageNamed:@"round_default_icon"] forState:UIControlStateHighlighted];
        
    } else {
        
        _isSure = true;
        [_sureBtn setImage:[UIImage imageNamed:@"round_highlight_icon"] forState:UIControlStateNormal]; /////////////勾选
        [_sureBtn setImage:[UIImage imageNamed:@"round_highlight_icon"] forState:UIControlStateHighlighted];
        
    }

    
}

#pragma mark --- 豆蔓注册协议

- (UIButton *)CreateDelegateBtn {
    
    UILabel *prompt = [[UILabel alloc] init];
    prompt.frame = CGRectMake(_sureBtn.mj_x+_sureBtn.mj_w+5, 285, 220, 11);
//    prompt.text = @"我已阅读并同意";
     prompt.textColor = LightGray; ///////////4b6ca7
    
    NSString *contentStr = @"我已阅读并同意<豆蔓智投用户服务协议>";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    [str addAttribute:NSForegroundColorAttributeName value:MainGreen range:NSMakeRange(7, 12)]; /////////ffd542
    prompt.attributedText = str;
    
    prompt.textAlignment = NSTextAlignmentLeft;
   
    prompt.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:prompt];

    if (!_delegateBtn) {
        _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delegateBtn.frame = CGRectMake((DMDeviceWidth-220 - 20)/2 + 20 + 80, 285, 150, 11);
//        NSString *str = [[NSString alloc]initWithString:[NSString stringWithFormat:@"<豆蔓理财用户服务协议>"]];
//        [_delegateBtn setTitle:str forState:UIControlStateNormal];
//        [_delegateBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//        _delegateBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//        _delegateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_delegateBtn addTarget:self action:@selector(DelegateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _delegateBtn;
    
}

- (void)DelegateBtnAction {
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.webUrl = [[DMWebUrlManager manager] registerProtocol];
    webVC.title = @"豆蔓智投注册协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (UIButton *)CreateRegisterBtnn {
    
    if (!_RegisterBtn) {
        
        _RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _RegisterBtn.frame = CGRectMake((DMDeviceWidth - 197)/2, _delegateBtn.frame.origin.y +_delegateBtn.frame.size.height + 72, 197, 37);
        [_RegisterBtn setImage:[UIImage imageNamed:@"register_button"] forState:UIControlStateNormal]; ////////////注--册
        [_RegisterBtn setImage:[UIImage imageNamed:@"register_button"] forState:UIControlStateHighlighted];
        [_RegisterBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
       
        
    }
    
    return _RegisterBtn;
    
}

- (UILabel *)prompt {
    
    if (!_prompt) {
        _prompt = [[UILabel alloc] init];
        _prompt.frame = CGRectMake(30, _RegisterBtn.frame.origin.y +_RegisterBtn.frame.size.height + 20, DMDeviceWidth-60, 12);
        _prompt.textAlignment = NSTextAlignmentCenter;
        _prompt.text = @"市场有风险，投资需谨慎";
        _prompt.font = SYSTEMFONT(12);
        _prompt.textColor = DarkGray; //////////////86a7e8
    }
    
    return _prompt;
}


- (void)registerAction {
    
    if (_userNameTextField.text.length == 0 || _userPassWordTextField.text.length == 0) {
        ShowMessage(@"手机号，密码不能为空");
    }else if (![[CheckMobile manager]checkMobileNumber:_userNameTextField.text]){
        ShowMessage(@"手机号不合法");
    }else if (_userPassWordTextField.text.length < 6){
        ShowMessage(@"密码不能少于6位");
    }else if (!jugde) {
        ShowMessage(@"该手机号已经注册过,请登录");
    }else if (![self checkValidityOfPasswordWithPasswordStr:self.userPassWordTextField.text]) {
        ShowMessage(@"请输入6-10含有大写字母、小写字母、数字的密码");
    }else if (!_isSure) {
        ShowMessage(@"请阅读并同意注册协议");
    } else {

    DMConfirmationViewController *confirmation = [[DMConfirmationViewController alloc] init];
    confirmation.userNameStr = _userNameTextField.text;
    confirmation.userPassWord = _userPassWordTextField.text;
    [self.navigationController pushViewController:confirmation animated:YES];
        
    }
}

/* @return 布尔类型,true为合法, false为不合法
 * @param 待验证的密码字符串
**/

- (BOOL)checkValidityOfPasswordWithPasswordStr:(NSString *)password {
    
    BOOL hasUpperLetter = NO;
    BOOL hasLowerLetter = NO;
    BOOL hasDigital = NO;
    
    NSUInteger length = password.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < length; loopIndex++) {
        unichar character = [password characterAtIndex:loopIndex];
        
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        //是否有数字
        if (character >= 48 && character <= 57) {
            hasDigital = YES;
        }
        //是否有小写字母
        if (character >=97  && character <= 122) {
            hasLowerLetter = YES;
        }
        //是否有大写字母
        if (character >=65  && character <= 90) {
            hasUpperLetter = YES;
        }
    }
    
    return hasDigital&&hasUpperLetter&&hasLowerLetter;
}

- (UIButton *)CreateloginBtn {
    
    if (!_LoginBtn) {
        
        _LoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _LoginBtn.frame = CGRectMake((DMDeviceWidth - 167/2)/2, DMDeviceHeight - 13 - 15 - 64, 167/2, 25/2);
        [_LoginBtn setImage:[UIImage imageNamed:@"已有账号？登录-1"] forState:UIControlStateNormal]; ///////////已有账号？登录
        [_LoginBtn setImage:[UIImage imageNamed:@"已有账号？登录-1"] forState:UIControlStateHighlighted];
        [_LoginBtn addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _LoginBtn;
    
}

- (void)LoginAction {
    
    if (!_login) {
        [self.navigationController pushViewController:[DMLoginViewController alloc] animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 140;
    [self.view registerAsDodgeViewForMLInputDodger];
}

@end
