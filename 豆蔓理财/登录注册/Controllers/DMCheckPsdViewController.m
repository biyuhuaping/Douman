//
//  DMCheckPsdViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/28.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMCheckPsdViewController.h"
#import "CustomTextField.h"
#import "DMForgetPassWordViewController.h"
#import "LLLockViewController.h"
#import "DMCreditRequestManager.h"
@interface DMCheckPsdViewController ()

@property (nonatomic, strong) CustomTextField *passWordField;

@end

@implementation DMCheckPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView{
    UIImageView *lockImage = [[UIImageView alloc] init];
    lockImage.image = [UIImage imageNamed:@"登录密码icon"];
//    [self.view addSubview:lockImage];
    
    self.passWordField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceHoldFont:12 PlaceHoldColor:LightGray];
    _passWordField.placeholder = @"请输入登录密码";
    _passWordField.textColor = DarkGray;
    _passWordField.font = [UIFont systemFontOfSize:15];
    _passWordField.secureTextEntry = YES;
    _passWordField.clearsOnBeginEditing = YES;

    [self.view addSubview:_passWordField];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [forgetBtn setTitleColor:LightGray forState:UIControlStateNormal];
    [self.view addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(findPsd:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xdedede);
    [self.view addSubview:lineView];
    
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"Immediately-verify"] forState:UIControlStateNormal];
    [self.view addSubview:checkBtn];
    [checkBtn addTarget:self action:@selector(checkPsd:) forControlEvents:UIControlEventTouchUpInside];
    
//    [lockImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@20);
//        make.top.equalTo(@55);
//        make.width.equalTo(@10);
//        make.height.equalTo(@16);
//    }];
    
    [_passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@25);
        make.top.equalTo(@38);
        make.width.equalTo(@(DMDeviceWidth-50));
        make.height.equalTo(@50);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passWordField);
        make.right.equalTo(_passWordField);
        make.bottom.equalTo(_passWordField).offset(-5);
        make.height.equalTo(@1);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView);
        make.top.equalTo(lineView);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
    }];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@235);
        make.height.equalTo(@44);
        make.width.equalTo(@260);
    }];

}

- (void)findPsd:(UIButton *)btn{
    DMForgetPassWordViewController *forgetVC = [[DMForgetPassWordViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)checkPsd:(UIButton *)btn{
    [self.passWordField resignFirstResponder];
    if (self.passWordField.text.length == 0) {
        ShowMessage(@"请输入密码");
    }else if (self.passWordField.text.length<6 || self.passWordField.text.length>20){
        ShowMessage(@"请输入6-10位字母或数字");
    }else{
        [[DMCreditRequestManager manager] checkPassWordWithPassword:self.passWordField.text Success:^{
            LLLockViewController *lockVC = [[LLLockViewController alloc] initWithType:LLLockViewTypeCreate];
            lockVC.leftType = @"return";
            [self.navigationController pushViewController:lockVC animated:YES];
        } Faild:^(NSString *message) {
            ShowMessage(message);
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
