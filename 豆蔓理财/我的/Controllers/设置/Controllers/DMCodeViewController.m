//
//  DMCodeViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/20.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMCodeViewController.h"
#import "DMSettransactionpasswordViewController.h"
#import "DMSettingManager.h"
#import "DMProgressHUD.h"
#import "ModifyViewController.h"
#import "DMCreditRequestManager.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
#import "OpenAnaccount.h"

#import "OpenAccountStatusView.h"

@interface DMCodeViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,OpenAnaccountDelegate>
{
    BOOL realname;
}

@property (nonatomic, strong) UILabel *prompt;// 提示
@property (nonatomic, strong) UITableView *tableView;//填写身份

/* 真实姓名  */
@property (nonatomic, strong)UIImageView *realnameImg;
@property (nonatomic, strong)UITextField *realnameTextField;

/* 身份证号  */
@property (nonatomic, strong)UIImageView *IdCardImg;
@property (nonatomic, strong)UITextField *IdCardNumTextField;

/* 银行卡号  */
@property (nonatomic, strong)UIImageView *bandsymbolImg;
@property (nonatomic, strong)UITextField *bandcardTextFiled;

/* 开户行  */
@property (nonatomic, strong)UIImageView *bandImg;
@property (nonatomic, strong)UITextField *bandTextFiled;
@property (nonatomic, strong)UIButton *bandBtn;

/* 手机号  */
@property (nonatomic, strong)UIImageView *phoneImg;
@property (nonatomic, strong)UITextField *phoneNumTextField;

@property (nonatomic, strong)UIButton *open;//开通

@property (nonatomic, strong)NSArray *bandlistArr;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, strong)OpenAccountStatusView *openAnaccount;
@property (nonatomic,assign) BOOL sure;

@property (nonatomic, strong)LJQUserInfoModel *userModel;


@end

@implementation DMCodeViewController


//个人信息获取接口
- (void) requestuserinfo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQUserInfoDataSourceSuccessBlock:^(NSInteger index, LJQUserInfoModel *model, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (index == 0) {
            self.userModel = model;
            if (model.account != nil) {
                //绑卡
            }else {
                //未绑卡
            }
            if (model.name != nil) {
                //实名
            }else {
                //未实名
            }
            
            if (model.name == nil) {
                model.name = @"";
            }
            if (model.account == nil) {
                model.account = @"";
            }
            if (model.bank == nil) {
                model.bank = @"";
            }
            if (model.mobile == nil) {
                model.mobile = @"";
            }
            if (model.idNumber == nil) {
                model.idNumber = @"";
            }
            
            NSDictionary *userinfo = @{@"name":model.name,
                                       @"account":model.account,
                                       @"bank":model.bank,
                                       @"mobile": model.mobile,
                                       @"idNumber": model.idNumber};
            self.dic = userinfo;
            //判断是否实名 实名过走绑卡接口 没实名过走开户接口
            if (![[userinfo objectForKey:@"name"] isEqualToString:@""]) {
                realname = YES;
                
            } else {
                realname = NO;
            }
            NSLog(@"%@",self.dic);
            [self.view addSubview:self.CreateRealNameView];
            [self.view addSubview:self.CreateIdCardView];
            [self.view addSubview:self.CreateBandCardView];
            [self.view addSubview:self.CreateBandView];
            [self.view addSubview:self.CreatePhoneNumView];
            [self.view addSubview:self.open];

            [_open mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(75);
                make.centerX.equalTo(self.view);
                make.width.mas_equalTo(@146);
                make.height.mas_equalTo(@36);
            }];

        }
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSDictionary *)dic {
    if (!_dic) {
        _dic = [NSDictionary dictionary];
    }
    return _dic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"实名绑卡";
    self.img.hidden = true;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bandlistArr = [[NSArray alloc]initWithObjects:@"广发银行",@"华夏银行",@"交通银行",@"平安银行",@"浦东发展银行",@"兴业银行",@"招商银行",@"中国工商银行",@"光大银行",@"中国建设银行",@"民生银行",@"中国农业银行",@"中国银行",@"中国邮政银行",@"中信银行",nil];
    
    //[self.view addSubview:self.prompt];
    [self requestuserinfo];

}


#pragma mark - Lazy Loading

- (UILabel *)prompt {
    
    if(!_prompt) {
        
        _prompt = [[UILabel alloc] init];
        [self.view addSubview:_prompt];
        [_prompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(@12);
        }];
        _prompt.textAlignment = NSTextAlignmentCenter;
        _prompt.font = SYSTEMFONT(12);
        _prompt.text = @"*确保您的资金安全，请先开通徽商银行存管账号";
        _prompt.textColor = [UIColor redColor];
    }
    return _prompt;

}

//真实姓名
- (UIView *)CreateRealNameView {
    
    UIView *RealNameView = [[UIView alloc] init];
    RealNameView.frame = CGRectMake(0, 57, DMDeviceWidth, 20);
    
    _realnameImg = [[UIImageView alloc] init];
    _realnameImg.frame = CGRectMake(23, 0, 29/2, 15);
    _realnameImg.image = [UIImage imageNamed:@"持卡人icon"];
    [RealNameView addSubview:_realnameImg];
    
    
    UILabel *realnameL = [[UILabel alloc] init];
    realnameL.frame = CGRectMake(48, 0, 60, 14);
    realnameL.text = @"真实姓名:";
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
        
        if (![[self.dic objectForKey:@"name"] isEqualToString:@""]) {
            _realnameTextField.text = [self.dic objectForKey:@"name"];
        }
        
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
    IdCardView.frame = CGRectMake(0, 57*2 , DMDeviceWidth, 20);
    
    
    _IdCardImg = [[UIImageView alloc] init];
    _IdCardImg.frame = CGRectMake(23, 4, 34/2, 34/2);
    _IdCardImg.image = [UIImage imageNamed:@"身份证"];
    [IdCardView addSubview:_IdCardImg];
    
    UILabel *bandcardL = [[UILabel alloc] init];
    bandcardL.frame = CGRectMake(48, 0, 70, 20);
    bandcardL.text = @"身份证号:";
    bandcardL.textColor = WITHEBACK_INPUT;
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
        if (![[self.dic objectForKey:@"idNumber"] isEqualToString:@""]) {
            _IdCardNumTextField.text = [self.dic objectForKey:@"idNumber"];
        }
        _IdCardNumTextField.placeholder = @"请输入身份证号码";
        _IdCardNumTextField.textColor = WITHEBACK_INPUT;
        _IdCardNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _IdCardNumTextField.font = [UIFont systemFontOfSize:14];
        [_IdCardNumTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        _IdCardNumTextField.delegate = self;
        
    }
    
    return _IdCardNumTextField;
    
}

//银行卡号
- (UIView *)CreateBandCardView {
    
    UIView *BandcardView = [[UIView alloc] init];
    BandcardView.frame = CGRectMake(0, 57*3, DMDeviceWidth, 20);
    
    
    _bandsymbolImg = [[UIImageView alloc] init];
    _bandsymbolImg.frame = CGRectMake(23, 3, 38/2, 26/2);
    _bandsymbolImg.image = [UIImage imageNamed:@"银行卡icon"];
    [BandcardView addSubview:_bandsymbolImg];
    
    UILabel *bandcardL = [[UILabel alloc] init];
    bandcardL.frame = CGRectMake(48, 0, 70, 20);
    bandcardL.text = @"银行卡号:";
    bandcardL.textColor = WITHEBACK_INPUT;
    bandcardL.font = [UIFont systemFontOfSize:12];
    [BandcardView addSubview:bandcardL];
    
    [BandcardView addSubview:self.bandcardTextFiled];
    
    UILabel *Bandcardline = [[UILabel alloc] init];
    Bandcardline.frame = CGRectMake(48, 20, DMDeviceWidth - 48 * 2, 1);
    Bandcardline.backgroundColor = WITHEBACK_LINE;
    [BandcardView addSubview:Bandcardline];
    
    return BandcardView;
    
}

- (UITextField *) bandcardTextFiled {

    if (!_bandcardTextFiled) {
        _bandcardTextFiled = [[CustomTextField alloc] initWithFrame:CGRectMake(110, 0, DMDeviceWidth - 48 - 120, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        if (![[self.dic objectForKey:@"account"] isEqualToString:@""]) {
            _bandcardTextFiled.text = [self.dic objectForKey:@"account"];
        }
        _bandcardTextFiled.placeholder = @"请输入银行卡号";
        _bandcardTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bandcardTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _bandcardTextFiled.font = [UIFont systemFontOfSize:14];
        _bandcardTextFiled.textColor = WITHEBACK_INPUT;
        _bandcardTextFiled.delegate = self;
        [_bandcardTextFiled addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
  

    }

    return _bandcardTextFiled;
    
}

//开户支行
- (UIView *)CreateBandView {
    
    UIView *BandView = [[UIView alloc] init];
    BandView.frame = CGRectMake(0, 57*4, DMDeviceWidth, 20);

    _bandImg = [[UIImageView alloc] init];
    _bandImg.frame = CGRectMake(23, 2, 34/2, 32/2);
    _bandImg.image = [UIImage imageNamed:@"开户支行"];
    [BandView addSubview:_bandImg];
    
    [BandView addSubview:self.bandTextFiled];
    [BandView addSubview:self.bandBtn];
    
    UILabel *Bandline = [[UILabel alloc] init];
    Bandline.frame = CGRectMake(48, 20, DMDeviceWidth - 48 * 2, 1);
    Bandline.backgroundColor = WITHEBACK_LINE;
    [BandView addSubview:Bandline];
    
    return BandView;
    
}

- (UITextField *)bandTextFiled {
    
    if (!_bandTextFiled) {
        _bandTextFiled = [[CustomTextField alloc] initWithFrame:CGRectMake(38, 0, DMDeviceWidth - 38*2, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        if (![[self.dic objectForKey:@"bank"] isEqualToString:@""]) {
            _bandTextFiled.text = [self.dic objectForKey:@"bank"];
        }

        _bandTextFiled.placeholder = @"请选择开户行";
        _bandTextFiled.font = [UIFont systemFontOfSize:14];
        _bandTextFiled.textColor = WITHEBACK_INPUT;
        _bandTextFiled.delegate = self;
        [_bandTextFiled addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        

    }
    
    return _bandTextFiled;

}

- (UIButton *)bandBtn {
    
    if (!_bandBtn) {
        _bandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bandBtn.frame =CGRectMake(38, 0, DMDeviceWidth - 38*2, 20);
        [_bandBtn addTarget:self action:@selector(bandlist) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bandBtn;
}

- (void)bandlist {
    
    [self.view endEditing:YES];
    
    if (!_pickerView) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, DMDeviceHeight-175-64, DMDeviceWidth, 175)];
        // 显示选中框
        _pickerView.backgroundColor = [UIColor lightGrayColor];
        //pickerView.backgroundColor = [UIColor redColor];
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];

    } else {
        
        [_pickerView removeFromSuperview];
        _pickerView = nil;
        
    }
    
    
    
    
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return [_bandlistArr count];
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
    
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    NSString  *proNameStr = [_bandlistArr objectAtIndex:row];
    _bandTextFiled.text = proNameStr;
    NSLog(@"nameStr=%@",proNameStr);
    
    
}

#pragma mark 给pickerview设置字体大小和颜色等
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor lightGrayColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    return pickerLabel;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    
    return [_bandlistArr objectAtIndex:row];

}


- (UIView *)CreatePhoneNumView {
    
    UIView *PhoneNumView = [[UIView alloc] init];
    PhoneNumView.frame = CGRectMake(0,57*5, DMDeviceWidth, 20);
    
    _phoneImg = [[UIImageView alloc] init];
    _phoneImg.frame = CGRectMake(26, 2.5, 10, 15);
    _phoneImg.image = [UIImage imageNamed:@"手机icon"];
    [PhoneNumView addSubview:_phoneImg];
    
    [PhoneNumView addSubview:self.phoneNumTextField];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    line.backgroundColor = WITHEBACK_LINE;
    [PhoneNumView addSubview:line];
    
    return PhoneNumView;
}


- (UITextField *)phoneNumTextField {
    
    if (!_phoneNumTextField) {
        _phoneNumTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(38, 0, DMDeviceWidth - 38*2, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        
        if (![[self.dic objectForKey:@"mobile"] isEqualToString:@""]) {
            _phoneNumTextField.text = [self.dic objectForKey:@"mobile"];
        } else if (PhoneNumber) {
            _phoneNumTextField.text = PhoneNumber;
        }
        
        _phoneNumTextField.placeholder = @"请输入银行卡预留手机号";
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.delegate = self;
        _phoneNumTextField.textColor = WITHEBACK_INPUT;
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTextField.font = [UIFont systemFontOfSize:14];
        [_phoneNumTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];

    }
    return _phoneNumTextField;
    
}

- (UIButton *)open {
    
    if (!_open) {
        _open = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_open];

        [_open mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneNumTextField.mas_bottom).offset(75);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(@146);
            make.height.mas_equalTo(@36);
        }];
        
        if (![[self.dic objectForKey:@"name"] isEqualToString:@""]) {
 
            [_open setImage:[UIImage imageNamed:@"立即绑卡"] forState:UIControlStateNormal];
            [_open setImage:[UIImage imageNamed:@"立即绑卡"] forState:UIControlStateHighlighted];
        } else {
  
            [_open setImage:[UIImage imageNamed:@"立即开通"] forState:UIControlStateNormal];
            [_open setImage:[UIImage imageNamed:@"立即开通"] forState:UIControlStateHighlighted];
        }

        [_open addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _open;
}

- (void)openAction {
    
    if ([self isEmpty:_realnameTextField.text]) {
        ShowMessage(@"请输入真实姓名");
    } else if ([self isEmpty:_IdCardNumTextField.text]) {
        ShowMessage(@"请输入身份证号");
    }
    else if ([self isEmpty:_IdCardNumTextField.text]) {
        ShowMessage(@"请输入银行卡号");
    }
    else if ([self isEmpty:_IdCardNumTextField.text]) {
        ShowMessage(@"请输入开户银行");
    }
    else if ([self isEmpty:_IdCardNumTextField.text]) {
        ShowMessage(@"请输入手机号");
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (realname) {
            [[DMSettingManager RequestManager] requestForhuishangBankTieOnCarduserId:USER_ID name:_realnameTextField.text idNumber:_IdCardNumTextField.text bankName:_bandTextFiled.text bankCardNo:_bandcardTextFiled.text mobile:_phoneNumTextField.text Success:^(BOOL sure) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.sure = YES;
                [self isTradePassWordRequestshow:3];
            } Faild:^(BOOL sure) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.sure = NO;
                [self isTradePassWordRequestshow:4];
            }];
        } else {
            
            [[DMSettingManager RequestManager] requestForhuishangBankOpenAnAccountuserId:USER_ID name:_realnameTextField.text idNumber:_IdCardNumTextField.text bankName:_bandTextFiled.text bankCardNo:_bandcardTextFiled.text mobile:_phoneNumTextField.text Success:^(BOOL sure) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.sure = YES;
                [self addOpenAccountView:1];
            } Faild:^(BOOL sure) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.sure = NO;
                [self addOpenAccountView:2];
            }];
        }
    }

}

- (void)pop {
    
    [DMProgressHUD hideHUD];
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(push) userInfo:nil repeats:NO];
}

- (void)push {
    
    ModifyViewController *modify = [[ModifyViewController alloc] init];
    [self.navigationController pushViewController:modify animated:YES]; 
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, DMDeviceWidth, 255)];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = UIColorFromRGB(0xD8D8D8);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.showsVerticalScrollIndicator =  NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        }
    return _tableView;

}






- (void)textFieldDidChange:(UITextField *)textField{
    
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //实名过的姓名和身份证不可编辑
    
    if (textField == _realnameTextField) {
        
        if (realname) {
            return NO;
        } else {
            return YES;
        }
    } else if (textField == _IdCardNumTextField) {
        
        if (realname) {
            return NO;
        } else {
            return YES;
        }
        
    } else {
        
        return YES;
        
    }
    
    
}


#pragma mark - keyboardHight


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    

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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_pickerView removeFromSuperview];
    _pickerView = nil;
}

//设置交易密码
- (void)jumpToTradePassWord {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DMCreditRequestManager manager] replacePassWordSuccess:^(NSString *argument) {
        DMWebViewController *drawCash = [[DMWebViewController alloc] init];
        drawCash.parameter = argument;
        drawCash.webUrl = [[DMWebUrlManager manager] getsumapayUrl];
        [self.navigationController pushViewController:drawCash animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
}


//是否设置交易密码
- (void)isTradePassWordRequestshow:(NSInteger)show {
    
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQIsSetTradePassWordSuccessblock:^(NSString *result) {
        if (![result isEqualToString:@"true"]) {
            //未设置过
            [self addOpenAccountView:show];
        }else {
            [self addOpenAccountView:show];
        }
    } faild:^{
        
    }];
}


- (void)addOpenAccountView:(NSInteger)Status {
    OpenAccountStatusView *automicTransfer = [[OpenAccountStatusView alloc] initWithIsOpenAccount:Status];
    
    __weak OpenAccountStatusView *weakAuto = automicTransfer;
    
    //设置交易密码
    automicTransfer.autoMicTransfer = ^{
        [weakAuto dismissFromView];
        
        //设置交易密码
        [self jumpToTradePassWord];
    };
    //取消按钮事件
    automicTransfer.jumpToAgreement = ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [automicTransfer showView];
}

- (void)hideHUD:(MBProgressHUD *)progress {
    __block MBProgressHUD *progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hide:YES];
        progressC = nil;
    });
}
@end
