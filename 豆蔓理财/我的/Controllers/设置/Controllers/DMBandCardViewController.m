//
//  DMBandCardViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMBandCardViewController.h"
#import "DMConfirmationViewController.h"

@interface DMBandCardViewController ()

@property (nonatomic, strong)UIImageView *realnameImg;
@property (nonatomic, strong)UIImageView *IdcardImg;
@property (nonatomic, strong)UIImageView *bandsymbolImg;
@property (nonatomic, strong)UIImageView *phoneImg;

@property (nonatomic, strong)UILabel *realnameLabel;
@property (nonatomic, strong)UILabel *IdcardLabel;
@property (nonatomic, strong)UILabel *bandcardLabel;

@property (nonatomic, strong)UITextField *phoneNumTextField;

@property (nonatomic, strong)UIButton *nextBtn;


@end

@implementation DMBandCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绑定银行卡";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreateUI];
}

- (void)CreateUI {
    
    [self.view addSubview:self.CreateRealNameView];
    [self.view addSubview:self.CreateIdcardView];
    [self.view addSubview:self.CreateBandcardView];
    [self.view addSubview:self.CreatePhoneNumView];
    [self.view addSubview:self.CreateNextBtn];
    [self CreatePrompt];
}


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
    realnameL.textColor = UIColorFromRGB(0xa8abb1);
    realnameL.font = [UIFont systemFontOfSize:14];
    [RealNameView addSubview:realnameL];
    
    _realnameLabel = [[UILabel alloc] init];
    NSString *Name = [_realName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    _realnameLabel.text = [NSString stringWithFormat:@"%@",Name];
    _realnameLabel.frame = CGRectMake(110, 0, DMDeviceWidth - 48*2, 14);
    _realnameLabel.textColor = UIColorFromRGB(0x6b727a);
    _realnameLabel.font = [UIFont systemFontOfSize:14];
    [RealNameView addSubview:_realnameLabel];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    line.backgroundColor = [UIColor lightGrayColor];
    [RealNameView addSubview:line];
    
    return RealNameView;
    
}

- (UIView *)CreateIdcardView {

    UIView *IdcardView = [[UIView alloc] init];
    IdcardView.frame = CGRectMake(0, 37 + 57, DMDeviceWidth, 20);
    
    _IdcardImg = [[UIImageView alloc] init];
    _IdcardImg.frame = CGRectMake(23, 0, 30/2, 23/2);
    _IdcardImg.image = [UIImage imageNamed:@"身份证icon"];
    [IdcardView addSubview:_IdcardImg];
    
    UILabel *IdcardL = [[UILabel alloc] init];
    IdcardL.frame = CGRectMake(48, 0, 60, 14);
    IdcardL.text = @"身份证:";
    IdcardL.textColor = UIColorFromRGB(0xa8abb1);
    IdcardL.font = [UIFont systemFontOfSize:14];
    [IdcardView addSubview:IdcardL];
    
    _IdcardLabel = [[UILabel alloc] init];
    NSString *Name = [_IdcardNum stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    _IdcardLabel.text = [NSString stringWithFormat:@"%@",Name];
    _IdcardLabel.frame = CGRectMake(110, 0, DMDeviceWidth - 48*2, 14);
    _IdcardLabel.textColor = UIColorFromRGB(0x6b727a);
    _IdcardLabel.font = [UIFont systemFontOfSize:14];
    [IdcardView addSubview:_IdcardLabel];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    line.backgroundColor = [UIColor lightGrayColor];
    [IdcardView addSubview:line];
    
    return IdcardView;
}



- (UIView *)CreateBandcardView {
    
    UIView *BandcardView = [[UIView alloc] init];
    BandcardView.frame = CGRectMake(0, 37 + 57*2, DMDeviceWidth, 20);
    
    _bandsymbolImg = [[UIImageView alloc] init];
    _bandsymbolImg.frame = CGRectMake(23, 0, 209/2, 44/2);
    _bandsymbolImg.image = [UIImage imageNamed:@"银行"];
    [BandcardView addSubview:_bandsymbolImg];
    
    _bandcardLabel = [[UILabel alloc] init];
    _bandcardLabel.frame = CGRectMake(23 + 209/2 + 10, 0, DMDeviceWidth - 48, 20);
    NSString *bandcard = [_bandcardNum stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    _bandcardLabel.text = [NSString stringWithFormat:@"%@",bandcard];
    _bandcardLabel.textColor = UIColorFromRGB(0x6b727a);
    _bandcardLabel.font = [UIFont systemFontOfSize:14];
    [BandcardView addSubview:_bandcardLabel];

    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    line.backgroundColor = [UIColor lightGrayColor];
    [BandcardView addSubview:line];
    
    
    return BandcardView;
    
    
}

- (UIView *)CreatePhoneNumView {
    
    UIView *PhoneNumView = [[UIView alloc] init];
    PhoneNumView.frame = CGRectMake(0, 37 + 57*3, DMDeviceWidth, 20);
    
    _phoneImg = [[UIImageView alloc] init];
    _phoneImg.frame = CGRectMake(26, 2.5, 10, 15);
    _phoneImg.image = [UIImage imageNamed:@"手机icon"];
    [PhoneNumView addSubview:_phoneImg];
    
    if (!_phoneNumTextField) {
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.frame = CGRectMake(48, 0, DMDeviceWidth - 48*2, 20);
        _phoneNumTextField.placeholder = @"请输入银行卡预留手机号";
        [_phoneNumTextField setValue:UIColorFromRGB(0Xa8abb1) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneNumTextField.font = [UIFont systemFontOfSize:12];
        [PhoneNumView addSubview:_phoneNumTextField];
        
    }
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(48, 20, DMDeviceWidth - 48*2, 1);
    line.backgroundColor = [UIColor lightGrayColor];
    [PhoneNumView addSubview:line];

    return PhoneNumView;
}

- (UIButton *)CreateNextBtn {
    
    if (!_nextBtn) {
        
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake((DMDeviceWidth - 292/2)/2,  37 + 57*4 +56, 292/2, 72/2);
        [_nextBtn setImage:[UIImage imageNamed:@"绑定卡-下一步"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"绑定卡-下一步"] forState:UIControlStateHighlighted];
        [_nextBtn addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _nextBtn;
    
}

- (void)CreatePrompt {
    
    
    UILabel *prompt = [[UILabel alloc] init];
    prompt.frame = CGRectMake(23, _nextBtn.frame.size.height + _nextBtn.frame.origin.y + 56, DMDeviceWidth - 23*2, 13);
    prompt.text = @"温馨提示";
    prompt.textColor = UIColorFromRGB(0x595757);
    prompt.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:prompt];
    
    UILabel *information = [[UILabel alloc] init];
    information.frame = CGRectMake(23, _nextBtn.frame.size.height + _nextBtn.frame.origin.y + 56 + 13*2, DMDeviceWidth - 23*2, 80);
    NSString *str = [NSString stringWithFormat:@"1.为保护您的账户安全，同时防止不法分子利用平台进行盗卡等行为，平台已正式启用同卡进出功能；\n2.请谨慎选择您的银行卡，一经绑定非银行卡丢失及特殊因素外，不可更换已绑定银行卡；\n3.如咨询请联系客服: "];
    information.numberOfLines = 0;
    information.text = str;
    information.textColor = UIColorFromRGB(0x9a9a9a);
    information.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:information];
    
    UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
    phone.frame = CGRectMake(122,  _nextBtn.frame.size.height + _nextBtn.frame.origin.y + 56 + 87.5, 100, 11);
    [phone setTitle:@"400-003-3939" forState:UIControlStateNormal];
    [phone setTitleColor:UIColorFromRGB(0xff9900) forState:UIControlStateNormal];
    phone.titleLabel.font= [UIFont systemFontOfSize:11];
    [phone addTarget:self action:@selector(PhoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phone];
    
    
}

- (void)NextAction {
    
    DMConfirmationViewController *DMconfirmation = [[DMConfirmationViewController alloc] init];
    [self.navigationController pushViewController:DMconfirmation animated:YES];
    
}

- (void)PhoneAction {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-003-3939"];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}





@end
