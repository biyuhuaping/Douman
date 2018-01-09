//
//  ModifyViewController.m
//  豆蔓理财
//
//  Created by edz on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "ModifyViewController.h"
#import "PopUpView.h"
#import "DMOpenPopUpView.h"


@interface ModifyViewController ()<UITextFieldDelegate,PopUpDelegate>

@property (nonatomic, strong)PopUpView *popup;

//姓名
@property (nonatomic, strong)UIImageView *realnameImg;
@property (nonatomic, strong)UITextField *realnameTextField;

//身份证号
@property (nonatomic, strong)UIImageView *IdCardImg;
@property (nonatomic, strong)UITextField *IdCardNumTextField;

//手机号
@property (nonatomic, strong)UIImageView *phoneImg;
@property (nonatomic, strong)UITextField *phoneNumTextField;

//验证码
@property (nonatomic, strong)UIImageView *codeImg;
@property (nonatomic, strong)UITextField *codeTextField;

@property (nonatomic, strong)UIButton *SMScodeBtn;
@property (nonatomic, strong)UIButton *modify;//修改


@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.img.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改交易密码";
    
    [self.view addSubview:self.CreateRealNameView];
    [self.view addSubview:self.CreateIdCardView];
    [self.view addSubview:self.CreatePhoneNumView];
    [self.view addSubview:self.CreateCodeView];
    [self.view addSubview:self.modify];
    [self CreatePrompt];

}


//持卡人
- (UIView *)CreateRealNameView {
    
    UIView *RealNameView = [[UIView alloc] init];
    RealNameView.frame = CGRectMake(0, 37, DMDeviceWidth, 20);
    
    _realnameImg = [[UIImageView alloc] init];
    _realnameImg.frame = CGRectMake(23, 0, 29/2, 15);
    _realnameImg.image = [UIImage imageNamed:@"持卡人icon"];
    [RealNameView addSubview:_realnameImg];
    
    
    UILabel *realnameL = [[UILabel alloc] init];
    realnameL.frame = CGRectMake(48, 0, 60, 14);
    realnameL.text = @"持卡人:";
    realnameL.textColor = WITHEBACK_INPUT;
    realnameL.font = [UIFont systemFontOfSize:12];
    [RealNameView addSubview:realnameL];
    
    [RealNameView addSubview:self.realnameTextField];
    
    UILabel *realnameline = [[UILabel alloc] init];
    realnameline.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    realnameline.backgroundColor = WITHEBACK_LINE;
    [RealNameView addSubview:realnameline];
    
    return RealNameView;
    
}

- (UITextField *)realnameTextField {
    
    if (!_realnameTextField) {
        _realnameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(110, 0, DMDeviceWidth - 110 - 48, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _realnameTextField.placeholder = @"请输入姓名";
        //kvc方法改变颜色  字号
        _realnameTextField.textColor = WITHEBACK_INPUT;
        _realnameTextField.font = [UIFont systemFontOfSize:14];
        _realnameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_realnameTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        _realnameTextField.delegate = self;
        
        
    }
    return _realnameTextField;
}

///身份证号
- (UIView *)CreateIdCardView {
    
    UIView *IdCardView = [[UIView alloc] init];
    IdCardView.frame = CGRectMake(0, 37 + 57 , DMDeviceWidth, 20);
    
    
    _IdCardImg = [[UIImageView alloc] init];
    _IdCardImg.frame = CGRectMake(23, 4, 34/2, 34/2);
    _IdCardImg.image = [UIImage imageNamed:@"身份证"];
    [IdCardView addSubview:_IdCardImg];
    
    UILabel *bandcardL = [[UILabel alloc] init];
    bandcardL.frame = CGRectMake(48, 0, 70, 20);
    bandcardL.text = @"身份证号:";
    bandcardL.textColor = WITHEBACK_DEFAULT;
    bandcardL.font = [UIFont systemFontOfSize:12];
    [IdCardView addSubview:bandcardL];
    
    [IdCardView addSubview:self.IdCardNumTextField];
    
    
    UILabel *Bandcardline = [[UILabel alloc] init];
    Bandcardline.frame = CGRectMake(48, 20, DMDeviceWidth - 48 * 2, 1);
    Bandcardline.backgroundColor = WITHEBACK_LINE;
    [IdCardView addSubview:Bandcardline];
    
    return IdCardView;
    
}

- (UITextField *)IdCardNumTextField {
    
    if (!_IdCardNumTextField) {
        _IdCardNumTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(110, 0, DMDeviceWidth - 110 - 48, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _IdCardNumTextField.placeholder = @"请输入身份证号码";
        _IdCardNumTextField.textColor = WITHEBACK_INPUT;
        _IdCardNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _IdCardNumTextField.font = [UIFont systemFontOfSize:14];
        [_IdCardNumTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        
    }
    
    return _IdCardNumTextField;
    
}

- (UIView *)CreatePhoneNumView {
    
    UIView *PhoneNumView = [[UIView alloc] init];
    PhoneNumView.frame = CGRectMake(0, 37 + 57*2, DMDeviceWidth, 20);
    
    _phoneImg = [[UIImageView alloc] init];
    _phoneImg.frame = CGRectMake(26, 2.5, 10, 15);
    _phoneImg.image = [UIImage imageNamed:@"手机icon"];
    [PhoneNumView addSubview:_phoneImg];
    
    if (!_phoneNumTextField) {
        _phoneNumTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(38, 0, DMDeviceWidth - 38*2, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _phoneNumTextField.placeholder = @"请输入银行卡预留手机号";
        _phoneNumTextField.delegate = self;
        _phoneNumTextField.textColor = WITHEBACK_INPUT;
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTextField.font = [UIFont systemFontOfSize:14];
        [_phoneNumTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        [PhoneNumView addSubview:_phoneNumTextField];
        
        
    }
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    line.backgroundColor = WITHEBACK_LINE;
    [PhoneNumView addSubview:line];
    
    return PhoneNumView;
}

- (UIView *)CreateCodeView {
    
    UIView *CodeView = [[UIView alloc] init];
    CodeView.frame = CGRectMake(0, 37 + 57*3, DMDeviceWidth, 20);
    
    _codeImg = [[UIImageView alloc] init];
    _codeImg.frame = CGRectMake(27, 3.5, 17, 17);
    _codeImg.image = [UIImage imageNamed:@"验证码"];
    [CodeView addSubview:_codeImg];
    
    if (!_codeTextField) {
        _codeTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(38, 0, DMDeviceWidth - 38*2, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.delegate = self;
        _codeTextField.textColor = WITHEBACK_INPUT;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.font = [UIFont systemFontOfSize:14];
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        [CodeView addSubview:_codeTextField];
        
        
    }
    
    _SMScodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SMScodeBtn.frame = CGRectMake(DMDeviceWidth -48 - 75 , -3, 75, 20);
    [_SMScodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _SMScodeBtn.layer.cornerRadius = 8;
    _SMScodeBtn.layer.borderColor = UIColorFromRGB(0xffd542).CGColor;
    _SMScodeBtn.layer.borderWidth = 1;
    [_SMScodeBtn setTitleColor:UIColorFromRGB(0xffd542) forState:UIControlStateNormal];
    _SMScodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_SMScodeBtn addTarget:self action:@selector(SMScodeAction) forControlEvents:UIControlEventTouchUpInside];
    [CodeView addSubview:_SMScodeBtn];
    
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    line.backgroundColor = WITHEBACK_LINE;
    [CodeView addSubview:line];
    
    return CodeView;
}


- (UIButton *)modify {
    
    if (!_modify) {
        _modify = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_modify];
        
        [_modify mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.codeTextField.mas_bottom).offset(75);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(@146);
            make.height.mas_equalTo(@36);
        }];
        
        [_modify setImage:[UIImage imageNamed:@"新-修改交易密码"] forState:UIControlStateNormal];
        [_modify setImage:[UIImage imageNamed:@"新-修改交易密码"] forState:UIControlStateHighlighted];
        [_modify addTarget:self action:@selector(modifyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modify;
}

- (void)modifyAction {
    
    _popup = [[PopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) WithTitle:@"交易密码设置成功" WithBtnTitle:@"设置交易密码"];
    
    _popup.delegate = self;

    [[UIApplication sharedApplication].keyWindow addSubview:self.popup];
    
}


-(void)Click {
    
    [_popup removeFromSuperview];
    
    DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight)];
    open.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:open];
    
}


- (void)SMScodeAction {
    
 
    
    
    __block int time = 60;
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




- (void)textFieldDidChange:(UITextField *)textField{
    
    
    
}


- (void)CreatePrompt {
    
    
    UILabel *prompt = [[UILabel alloc] init];
    prompt.frame = CGRectMake(23, DMDeviceHeight - 70 - 154, DMDeviceWidth - 23*2, 13);
    prompt.text = @"温馨提示";
    prompt.textColor = UIColorFromRGB(0x595757);
    prompt.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:prompt];
    
    UILabel *information = [[UILabel alloc] init];
    information.frame = CGRectMake(23, prompt.frame.size.height + prompt.frame.origin.y , DMDeviceWidth - 23*2, 80);
    NSString *str = [NSString stringWithFormat:@"1.为保护您的账户安全，同时防止不法分子利用平台进行盗卡等行为，平台已正式启用同卡进出功能；\n2.请谨慎选择您的银行卡，一经绑定非银行卡丢失及特殊因素外，不可更换已绑定银行卡；\n3.如咨询请联系客服: "];
    information.numberOfLines = 0;
    information.text = str;
    information.textColor = UIColorFromRGB(0x9a9a9a);
    information.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:information];
    
    UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
    phone.frame = CGRectMake(122,  prompt.frame.size.height + prompt.frame.origin.y + 61, 100, 11);
    [phone setTitle:@"400-003-3939" forState:UIControlStateNormal];
    [phone setTitleColor:UIColorFromRGB(0xff9900) forState:UIControlStateNormal];
    phone.titleLabel.font= [UIFont systemFontOfSize:11];
    [phone addTarget:self action:@selector(PhoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phone];
    
}

- (void)PhoneAction {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-003-3939"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
