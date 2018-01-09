//
//  DMAddBandCardViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMAddBandCardViewController.h"
#import "DMBandCardViewController.h"
#import "DMCodeViewController.h"
#import "DMSettingManager.h"
#import "DMSetupBankAccountViewController.h"
#import "DMSettingManager.h"
#import "DMSettransactionpasswordViewController.h"


@interface DMAddBandCardViewController ()
{
    
    NSArray *_citiesArray;
    NSMutableArray *_dataArray;
    UIView *pick;
    BOOL pickHidden;
    NSString *temppro;
    NSString *tempcity;
    
    UIView *view;
    
    
}

@property (nonatomic, strong)UIScrollView *bigscroll;//

@property (nonatomic, strong)NSMutableArray *ProvinceCodeArr; //省份数据源
@property (nonatomic, strong)NSMutableArray *ProvinceCityArr; //城市数据源

@property (nonatomic, strong)UIButton *limitBtn;
@property (nonatomic, strong)UIButton *sureBtn;

@property (nonatomic, strong)UITextField *bandcardTextFiled;

/* 持卡人  */
@property (nonatomic, strong)UIImageView *realnameImg;
@property (nonatomic, strong)UILabel *realnameLabel;
@property (nonatomic, strong)UITextField *realnameTextField;

@property (nonatomic, strong)UIImageView *IdCardImg;
@property (nonatomic, strong)UITextField *IdCardNumTextField;

@property (nonatomic, strong)UIImageView *bandsymbolImg;
@property (nonatomic, strong)UIImageView *bandImg;
@property (nonatomic, strong)UITextField *bandTextFiled;

@property (nonatomic, strong)UIImageView *cityImg;
@property (nonatomic, strong)UITextField *cityTextFiled;
@property (nonatomic, strong)UIButton *citybtn;
@property (nonatomic, strong)UIButton *provincebtn;

@property (nonatomic, strong)UIImageView *phoneImg;
@property (nonatomic, strong)UITextField *phoneNumTextField;

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIPickerView *citypickerView;

@property (nonatomic, strong)LJQUserInfoModel *userModel;


@property (nonatomic, strong)UIImageView *codeImg;
@property (nonatomic, strong)UITextField *codeTextField;

@property (nonatomic, strong)UIButton *SMScodeBtn;

@property (nonatomic, strong)UIView *backView;

//省
@property(nonatomic, copy)NSString *province;
//市
@property(nonatomic, copy)NSString *city;
//银行
@property(nonatomic, copy)NSString *band;








@end

@implementation DMAddBandCardViewController


#pragma mark - Initialization

- (instancetype)init {
    
    self = [super init];
    
    if (self) {

        pickHidden = YES;
        _city = @"";
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"city" ofType:@"plist"];
        _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
        _citiesArray = _dataArray[0][@"cities"];
        
    }
    return self;
}

- (NSMutableArray *)ProvinceCodeArr {
    if (!_ProvinceCodeArr) {
        self.ProvinceCodeArr = [@[] mutableCopy];
    }
    return _ProvinceCodeArr;
}
- (NSMutableArray *)ProvinceCityArr {
    if (!_ProvinceCityArr) {
        self.ProvinceCityArr = [@[] mutableCopy];
    }
    return _ProvinceCityArr;
}
- (NSMutableDictionary *)dic {
    if (!_dic) {
        self.dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}




#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    self.img.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///手势 点击空白收起输入框
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.title = @"实名绑卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreateNav];
    
    
    [self requestProvinceCodes];
    
    [self.view addSubview:self.bigscroll];
    
    [self.bigscroll addSubview:self.CreateRealNameView];
    [self.bigscroll addSubview:self.CreateIdCardView];
    [self.bigscroll addSubview:self.CreateBandCardView];
    [self.bigscroll addSubview:self.CreateCity];
    [self.bigscroll addSubview:self.CreateBandView];
    [self.bigscroll addSubview:self.CreatePhoneNumView];
    [self.bigscroll addSubview:self.CreateCodeView];
    [self.bigscroll addSubview:self.CreateSureBtn];
    [self CreatePrompt];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Loading

- (UIScrollView *)bigscroll {
    
    if (!_bigscroll) {
        _bigscroll = [[UIScrollView alloc] init];
        _bigscroll.frame = CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight);
        _bigscroll.showsVerticalScrollIndicator = NO;
        _bigscroll.showsHorizontalScrollIndicator = NO;
        _bigscroll.pagingEnabled = NO;
        //_bigscroll.bounces = NO;
        _bigscroll.contentSize = CGSizeMake(0,700);
    }
    return _bigscroll;
}


- (void)CreateNav {
    
    _limitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _limitBtn.frame = CGRectMake(10, 10, 50, 14);
    [_limitBtn setTitle:@"查看限额" forState:UIControlStateNormal];
    [_limitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _limitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_limitBtn addTarget: self action:@selector(limitClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_limitBtn];
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



//清行卡号
- (UIView *)CreateBandCardView {
    
    UIView *BandcardView = [[UIView alloc] init];
    BandcardView.frame = CGRectMake(0, 37 + 57*2, DMDeviceWidth, 20);
    
    
    _bandsymbolImg = [[UIImageView alloc] init];
    _bandsymbolImg.frame = CGRectMake(23, 3, 38/2, 26/2);
    _bandsymbolImg.image = [UIImage imageNamed:@"银行卡icon"];
    [BandcardView addSubview:_bandsymbolImg];
    
    UILabel *bandcardL = [[UILabel alloc] init];
    bandcardL.frame = CGRectMake(48, 0, 70, 20);
    bandcardL.text = @"银行卡号:";
    bandcardL.textColor = WITHEBACK_DEFAULT;
    bandcardL.font = [UIFont systemFontOfSize:12];
    [BandcardView addSubview:bandcardL];
    
    if (!_bandcardTextFiled) {
        _bandcardTextFiled = [[CustomTextField alloc] initWithFrame:CGRectMake(110, 0, DMDeviceWidth - 48 - 120, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _bandcardTextFiled.placeholder = @"请输入银行卡号";
        _bandcardTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _bandcardTextFiled.font = [UIFont systemFontOfSize:14];
        _bandcardTextFiled.textColor = WITHEBACK_INPUT;
        _bandcardTextFiled.delegate = self;
        [_bandcardTextFiled addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        [BandcardView addSubview:_bandcardTextFiled];

    }
    
    
    UILabel *Bandcardline = [[UILabel alloc] init];
    Bandcardline.frame = CGRectMake(48, 20, DMDeviceWidth - 48 * 2, 1);
    Bandcardline.backgroundColor = WITHEBACK_LINE;
    [BandcardView addSubview:Bandcardline];
    
    return BandcardView;
    
}


- (UIView *) CreateCity {
    
    
    UIView *cityView = [[UIView alloc] init];
    cityView.frame = CGRectMake(0, 37 + 57*3, DMDeviceWidth, 20);
    
    
    _cityImg = [[UIImageView alloc] init];
    _cityImg.frame = CGRectMake(23, 3, 29/2, 29/2);
    _cityImg.image = [UIImage imageNamed:@"开户地区"];
    [cityView addSubview:_cityImg];
    
    UILabel *bandcardL = [[UILabel alloc] init];
    bandcardL.frame = CGRectMake(48, 0, 70, 20);
    bandcardL.text = @"开户地区:";
    bandcardL.textColor = WITHEBACK_DEFAULT;
    bandcardL.font = [UIFont systemFontOfSize:12];
    [cityView addSubview:bandcardL];
    

    
    _provincebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _provincebtn.frame = CGRectMake(120, -5, (DMDeviceWidth -120 - 48 - 27)/2, 24);
    _provincebtn.backgroundColor = UIColorFromRGB(0xececec);
    [_provincebtn setTitle:@"请选择省" forState:UIControlStateNormal];
    _provincebtn.titleLabel.font = SYSTEMFONT(12);
    _provincebtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_provincebtn setTitleColor:UIColorFromRGB(0x6b727a) forState:UIControlStateNormal];
    [_provincebtn addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
    [_provincebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 15)];
    UIImageView *provincebtnImg = [[UIImageView alloc] init];
    provincebtnImg.frame = CGRectMake((DMDeviceWidth -120 - 48 - 27)/2 - 15, 9, 10, 6);
    provincebtnImg.image=[UIImage imageNamed:@"绑卡-向下箭头"];
    [_provincebtn addSubview:provincebtnImg];
    [cityView addSubview:_provincebtn];
    
    _citybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _citybtn.frame = CGRectMake(120 + (DMDeviceWidth -120 - 48 - 27)/2 + 27, -5, (DMDeviceWidth -120 - 48 - 27)/2, 24);
    _citybtn.backgroundColor = UIColorFromRGB(0xececec);
    [_citybtn setTitle:@"请选择市" forState:UIControlStateNormal];
    [_citybtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 15)];
    _citybtn.titleLabel.font = SYSTEMFONT(12);
    [_citybtn setTitleColor:UIColorFromRGB(0x6b727a) forState:UIControlStateNormal];
    UIImageView *citybtnImg = [[UIImageView alloc] init];
    citybtnImg.frame = CGRectMake((DMDeviceWidth -120 - 48 - 27)/2 - 15, 9, 10, 6);
    citybtnImg.image=[UIImage imageNamed:@"绑卡-向下箭头"];
    [_citybtn addSubview:citybtnImg];

    [_citybtn addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
    [cityView addSubview:_citybtn];

    
    UILabel *cityline = [[UILabel alloc] init];
    cityline.frame = CGRectMake(48, 20, DMDeviceWidth - 48 * 2, 1);
    cityline.backgroundColor = WITHEBACK_LINE;
    [cityView addSubview:cityline];
    
    return cityView;

    
}

- (UIView *)CreateBandView {
    
    UIView *BandView = [[UIView alloc] init];
    BandView.frame = CGRectMake(0, 37 + 57*4, DMDeviceWidth, 20);
    
    
    _bandImg = [[UIImageView alloc] init];
    _bandImg.frame = CGRectMake(23, 2, 34/2, 32/2);
    _bandImg.image = [UIImage imageNamed:@"开户支行"];
    [BandView addSubview:_bandImg];
    

    
    if (!_bandTextFiled) {
        _bandTextFiled = [[CustomTextField alloc] initWithFrame:CGRectMake(38, 0, DMDeviceWidth - 38*2, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _bandTextFiled.placeholder = @"请输入开户支行名称";
        _bandTextFiled.font = [UIFont systemFontOfSize:14];
        _bandTextFiled.textColor = WITHEBACK_INPUT;
        _bandTextFiled.delegate = self;
        [_bandTextFiled addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        [BandView addSubview:_bandTextFiled];
        
        
    }
    
    
    UILabel *Bandline = [[UILabel alloc] init];
    Bandline.frame = CGRectMake(48, 20, DMDeviceWidth - 48 * 2, 1);
    Bandline.backgroundColor = WITHEBACK_LINE;
    [BandView addSubview:Bandline];
    
    return BandView;
    
}


- (UIView *)CreatePhoneNumView {
    
    UIView *PhoneNumView = [[UIView alloc] init];
    PhoneNumView.frame = CGRectMake(0, 37 + 57*5, DMDeviceWidth, 20);
    
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
    CodeView.frame = CGRectMake(0, 37 + 57*6, DMDeviceWidth, 20);
    
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

- (void)SMScodeAction {
    
    
    if (isEmpty(_phoneNumTextField.text)) {
        ShowMessage(@"请输入手机号");
        return;
    }
    
    [[DMSettingManager RequestManager] requestForSendMessage:_phoneNumTextField.text smsType:nil Success:^{
        
    } Faild:^{
        
    }];
    
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


- (UIButton *)CreateSureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake((DMDeviceWidth - 292/2)/2, 37 + 57*6+58, 292/2, 72/2);
        [_sureBtn setImage:[UIImage imageNamed:@"确--认"] forState:UIControlStateNormal];
        [_sureBtn setImage:[UIImage imageNamed:@"确--认"] forState:UIControlStateHighlighted];
        [_sureBtn addTarget:self action:@selector(SureAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sureBtn;
    
}

#pragma mark - action

- (void)limitClick {
    
    DMSetupBankAccountViewController *setup = [[DMSetupBankAccountViewController alloc] init];
    [self.navigationController pushViewController:setup animated:YES];
    
}


- (void)SureAction {
    
    NSString *bandUrl = [_bandTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (isEmpty(_bandcardTextFiled.text)) {
        ShowMessage(@"银行卡号不能为空");
    } else if (isEmpty(_realnameTextField.text)) {
        ShowMessage(@"请输入姓名");
    }else if (isEmpty(_IdCardNumTextField.text)) {
        ShowMessage(@"请输入姓名");
    }else if (isEmpty(bandUrl)) {
        ShowMessage(@"输入开户支行");
    }else if (isEmpty(_phoneNumTextField.text)) {
        ShowMessage(@"手机号码不能为空");
    }else if (![[CheckMobile manager]checkMobileNumber:_phoneNumTextField.text]) {
        ShowMessage(@"手机号码输入不正确");
    }else if (isEmpty(_province)) {
        ShowMessage(@"省份为空");
    }else if (isEmpty(_city)) {
        ShowMessage(@"城市为空");
    }else if (isEmpty(_band)) {
        ShowMessage(@"银行卡信息错误");
    }else if (isEmpty(_codeTextField.text)) {
        ShowMessage(@"请输入验证码");
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *strUrl = [ _bandcardTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[DMSettingManager RequestManager]requestForSettinguserId:USER_ID bankName:_band bankCard:strUrl phone:_phoneNumTextField.text province:_province city:_city branchName:bandUrl smsCaptcha:_codeTextField.text token:nil smsType:@"CREDITMARKET_CAPTCHA" name:_realnameTextField.text idNumber:_IdCardNumTextField.text Success:^(BOOL sure) {
            
            if (sure) {
                _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight)];
                _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
                [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
                
                view = [[UIView alloc] init];
                view.frame = CGRectMake((DMDeviceWidth - 270)/2, (DMDeviceHeight - 314/2)/2, 270, 314/2);
                view.backgroundColor = [UIColor whiteColor];
                [_backView addSubview:view];
                
                UIImageView *img = [[UIImageView alloc] init];
                img.frame = CGRectMake((270-34)/2, 20, 34, 34);
                img.image = [UIImage imageNamed:@"绑卡-确定"];
                [view addSubview:img];
                
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(0, 20 + 16 + 34, 270, 14);
                label.text = @"绑卡成功，请设置交易密码";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = UIColorFromRGB(0xdfa93c);
                label.font = SYSTEMFONT(14);
                [view addSubview:label];
                
                UILabel *line = [[UILabel alloc] init];
                line.frame = CGRectMake(0, label.frame.origin.y+label.frame.size.height + 27, 270, 1);
                line.textColor = [UIColor blackColor];
                [view addSubview:line];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =CGRectMake(0, 157 - 46, 270, 46);
                [button setTitle:@"确定" forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x445c85) forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } Faild:^(BOOL sure){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
}

- (void)buttonClick {
    
    
    [_backView removeFromSuperview];
    
    DMSettransactionpasswordViewController *settran = [[DMSettransactionpasswordViewController alloc] init];
    settran.sure = YES;
    [self.navigationController pushViewController:settran animated:YES];

    
}


- (void)PhoneAction {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-003-3939"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


#pragma mark -------pick  城市

- (void)cityClick:(UIButton *)btn {
    
    self.citypickerView = nil;
    self.pickerView = nil;
    
    if (btn == self.citybtn) {
        
        if (isEmpty(_province)) {
            ShowMessage(@"请先输入省");
            
            return;
        } else {
            
            
        }
        
        self.citypickerView = [[UIPickerView alloc]init];
        _citypickerView.frame = CGRectMake(0, 30, DMDeviceWidth, 300);
        _citypickerView.showsSelectionIndicator=YES;
        _citypickerView.dataSource = self;
        _citypickerView.delegate = self;
        


    } else {
        
        self.pickerView = [[UIPickerView alloc]init];
        _pickerView.frame = CGRectMake(0, 30, DMDeviceWidth, 300);
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        
        
    }
    
    pick = [[UIView alloc] initWithFrame:CGRectMake(0, DMDeviceHeight - 330 - 64, DMDeviceWidth, 330)];
    [self.view addSubview:pick];
    
    
    if (pickHidden) {
        pickHidden = NO;
        pick.backgroundColor = [UIColor grayColor];
        [pick setHidden:NO];
        
        [self.view addSubview:pick];
    } else {
        pickHidden = YES;
        temppro = nil;
        tempcity = nil;
        pick.backgroundColor = [UIColor grayColor];
        [pick setHidden:YES];
    }
    
    UIButton *Ybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Ybtn.frame =CGRectMake((DMDeviceWidth - 300)/2, 0, 100, 30);
    [Ybtn setTitle:@"取消" forState:UIControlStateNormal];
    [Ybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Ybtn addTarget:self action:@selector(noClick) forControlEvents:UIControlEventTouchUpInside];
    [pick addSubview:Ybtn];
    
    UIButton *Nbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Nbtn.frame =CGRectMake((DMDeviceWidth - 300)/2 + 200, 0, 100, 30);
    [Nbtn setTitle:@"确定" forState:UIControlStateNormal];
    [Nbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Nbtn.titleLabel.textColor = [UIColor whiteColor];
    [Nbtn addTarget:self action:@selector(yesClick) forControlEvents:UIControlEventTouchUpInside];
    [pick addSubview:Nbtn];
    
    [pick addSubview:_citypickerView];
    [pick addSubview:_pickerView];
    
}
- (void)yesClick {
    
    if (isEmpty(tempcity)) {
        
        if (temppro != _province) {
            [self.citybtn setTitle:@"请选择市" forState:UIControlStateNormal];
            _city = nil;
        } else {
            
        }
        _province = temppro;
        [self.provincebtn setTitle:_province forState:UIControlStateNormal];
        [self requestProvinceCityCodes:_province];

    } else {
        
        _city = tempcity;
        [self.citybtn setTitle:_city forState:UIControlStateNormal];
        
    }
    
    temppro = nil;
    tempcity = nil;
    pickHidden = YES;
    [pick setHidden:YES];
    
}

- (void)noClick {
    
    
    
    if (isEmpty(tempcity)) {
        
        if (isEmpty(_province)) {
            _province = nil;
        }
        
    } else {
        
        if (isEmpty(_city)) {
            _city  =nil;
        }
        
    }
    
    
    temppro = nil;
    tempcity = nil;
    pickHidden = YES;
    [pick setHidden:YES];
    
}



- (void)CreatePrompt {
    
    
    UILabel *prompt = [[UILabel alloc] init];
    prompt.frame = CGRectMake(23, _sureBtn.frame.size.height + _sureBtn.frame.origin.y + 56, DMDeviceWidth - 23*2, 13);
    prompt.text = @"温馨提示";
    prompt.textColor = UIColorFromRGB(0x595757);
    prompt.font = [UIFont systemFontOfSize:13];
    [self.bigscroll addSubview:prompt];
    
    UILabel *information = [[UILabel alloc] init];
    information.frame = CGRectMake(23, _sureBtn.frame.size.height + _sureBtn.frame.origin.y + 56 + 13*2, DMDeviceWidth - 23*2, 80);
    NSString *str = [NSString stringWithFormat:@"1.为保护您的账户安全，同时防止不法分子利用平台进行盗卡等行为，平台已正式启用同卡进出功能；\n2.请谨慎选择您的银行卡，一经绑定非银行卡丢失及特殊因素外，不可更换已绑定银行卡；\n3.如咨询请联系客服: "];
    information.numberOfLines = 0;
    information.text = str;
    information.textColor = UIColorFromRGB(0x9a9a9a);
    information.font = [UIFont systemFontOfSize:11];
    [self.bigscroll addSubview:information];
    
    UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
    phone.frame = CGRectMake(122,  _sureBtn.frame.size.height + _sureBtn.frame.origin.y + 56 + 87.5, 100, 11);
    [phone setTitle:@"400-003-3939" forState:UIControlStateNormal];
    [phone setTitleColor:UIColorFromRGB(0xff9900) forState:UIControlStateNormal];
    phone.titleLabel.font= [UIFont systemFontOfSize:11];
    [phone addTarget:self action:@selector(PhoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bigscroll addSubview:phone];
    
    
}

#pragma mark -- pickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (pickerView == self.pickerView) {
        
        return self.ProvinceCodeArr.count;
    } else {
        return self.ProvinceCityArr.count;
    }
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        pickerLabel.textColor = [UIColor whiteColor];
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    // Fill the label text here
    
    return pickerLabel;
}


//设置每行每列中的数据:

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView == self.pickerView) {
        temppro = self.ProvinceCodeArr[0];
        return self.ProvinceCodeArr[row];
    } else {
        tempcity = self.ProvinceCityArr[0];
        return self.ProvinceCityArr[row];
    }

}

//选择完成之后的事件:

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView == self.pickerView) {
        
        NSInteger areaRow=[self.pickerView selectedRowInComponent:0];
        temppro = self.ProvinceCodeArr[areaRow];
        
    } else {
        
        if (self.ProvinceCityArr.count == 1) {
            tempcity = self.ProvinceCityArr[0];
        } else {
            NSInteger areaRow=[self.citypickerView selectedRowInComponent:0];
            tempcity = self.ProvinceCityArr[areaRow];
        }
    }
    
    
    
}

#pragma mark ---------textfiled 代理


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _phoneNumTextField) {
        [self registerForKeyboardNotifications];
    } else if (textField == _codeTextField){
        [self registerForKeyboardNotifications];
    }
    
    //开始编辑时触发，文本字段将成为first responder
}

//输入银行卡号结束以后 判断银行
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _bandcardTextFiled) {
        
        
        
        if (_bandcardTextFiled.text.length < 15) {
            
            _bandsymbolImg.frame = CGRectMake(23, 2, 38/2, 26/2);
            _bandsymbolImg.image = [UIImage imageNamed:@"银行卡icon"];
            _band = @"";
            
            [self requestForbandCardWithband:_band];

        } else {
            
            [self requestForbandCardWithband:_band];
        
        }
    }
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    

    
    
    if (self.bandcardTextFiled.text.length > 0 && self.bandTextFiled.text.length > 0 && _phoneNumTextField.text.length > 0&&_realnameTextField.text.length>0 && _IdCardNumTextField.text.length > 0 && !isEmpty(_city) &&!isEmpty(_province)&& _codeTextField.text.length > 0) {

        [_sureBtn setImage:[UIImage imageNamed:@"确--认--黑"] forState:UIControlStateNormal];
        [_sureBtn setImage:[UIImage imageNamed:@"确--认--黑"] forState:UIControlStateHighlighted];
    } else {

        [_sureBtn setImage:[UIImage imageNamed:@"确--认"] forState:UIControlStateNormal];
        [_sureBtn setImage:[UIImage imageNamed:@"确--认"] forState:UIControlStateHighlighted];
    }
}
#pragma mark - keyboardHight


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
        self.view.frame = CGRectMake(0, -120+64, DMDeviceWidth, DMDeviceHeight);
    }];
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 64, DMDeviceWidth, DMDeviceHeight);
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


//收起键盘

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_bandcardTextFiled resignFirstResponder];
    [_bandTextFiled resignFirstResponder];
    [_cityTextFiled resignFirstResponder];
    [_phoneNumTextField resignFirstResponder];
    [_realnameTextField resignFirstResponder];
    [_IdCardNumTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    pickHidden = YES;
    [pick setHidden:YES];
}


#pragma mark - Network Request


- (void)requestForbandCardWithband:(NSString *)band {
    
    
    NSString *strUrl = [ _bandcardTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];//空格去除
    
    [[DMSettingManager RequestManager] requestForbandCard:strUrl Success:^(NSString *message){
        
        _band = message;
        NSLog(@"%@",message);
        
        NSString *imageName = [NSString stringWithFormat:@"%@银行",_band];
        _bandsymbolImg.image = [UIImage imageNamed:imageName];
        _bandsymbolImg.frame = CGRectMake(23, -1, 19, 19);
        
        
    } Faild:^(NSString *message){
        
        _band = @"";
        ShowMessage(message);
        NSLog(@"%@",message);
        
    }];


}



//数据请求
/* 省份 */
- (void)requestProvinceCodes {
    
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] requestProvinceCodes:^(NSArray *array) {
        
        weakSelf.ProvinceCodeArr = [NSMutableArray arrayWithArray:array];
        [weakSelf.pickerView reloadAllComponents];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
/* 城市 */
- (void)requestProvinceCityCodes:(NSString *)string {
    
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager requestProvinceCityCodes:string successBlock:^(NSArray *array) {
        
        weakSelf.ProvinceCityArr = [NSMutableArray arrayWithArray:array];
        [weakSelf.citypickerView reloadAllComponents];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



///-------------------------------////////////////判断是不是空
BOOL isEmpty(NSString *string){
    
    if ([string isKindOfClass:[NSNumber class]]) {
        if ([[NSString stringWithFormat:@"%@",string] isEqualToString:@"0"]) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if (string == nil || string == NULL || ![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}




@end
