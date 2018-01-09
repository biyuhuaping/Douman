//
//  DMSettransactionpasswordViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSettransactionpasswordViewController.h"
#import "DMModifytransactionpassword ViewController.h"
#import "DMMineViewController.h"
#import "LJQSetPassWordVC.h"

@interface DMSettransactionpasswordViewController ()

@property (nonatomic, strong) UIImageView *theNewPassWordImg;
@property (nonatomic, strong) UIImageView *againPassWordImg;

@property (nonatomic, strong) UITextField *theNewPassWordTextField;
@property (nonatomic, strong) UITextField *againPassWordTextField;


@property (nonatomic, strong) UIButton *finishBtn;

@end

@implementation DMSettransactionpasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.back setHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.back setHidden:NO];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (_sure == YES) {
        self.title = @"设置交易密码";
    } else {
        self.title = @"重置交易密码";
    }
    
    self.img.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:self.theNewPassWordImg];
    [self.view addSubview:self.theNewPassWordTextField];
    [self.view addSubview:self.againPassWordImg];
    [self.view addSubview:self.againPassWordTextField];
    [self.view addSubview:self.finishBtn];
    
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_theNewPassWordTextField resignFirstResponder];
    [_againPassWordTextField resignFirstResponder];
    
    
}


- (UIImageView *)theNewPassWordImg {
    
    if (!_theNewPassWordImg) {
        _theNewPassWordImg = [[UIImageView alloc] init];
        _theNewPassWordImg.frame = CGRectMake(48, 48, 10, 16);
        _theNewPassWordImg.image = [UIImage imageNamed:@"登录密码icon"];
    }
    
    return _theNewPassWordImg;
}


- (UITextField *)theNewPassWordTextField {
    
    if (!_theNewPassWordTextField) {
        _theNewPassWordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(74, 48, DMDeviceWidth - 74-48, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _theNewPassWordTextField.placeholder = @"请输入交易密码(只能是六位数字)";
        [_theNewPassWordTextField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        _theNewPassWordTextField.font = [UIFont systemFontOfSize:14];
        _theNewPassWordTextField.clearButtonMode = UITextFieldViewModeAlways;
        _theNewPassWordTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_theNewPassWordTextField setValue:WITHEBACK_DEFAULT forKeyPath:@"_placeholderLabel.textColor"];
        _theNewPassWordTextField.textColor = WITHEBACK_INPUT;
        [_theNewPassWordTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
        
    }
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(74, _theNewPassWordTextField.frame.origin.y+_theNewPassWordTextField.frame.size.height + 7, DMDeviceWidth - 48 - 74, 1);
    line.backgroundColor = WITHEBACK_LINE;
    [self.view addSubview:line];
    
    return _theNewPassWordTextField;
    
}


- (UIImageView *)againPassWordImg {
    
    if (!_againPassWordImg) {
        _againPassWordImg = [[UIImageView alloc] init];
        _againPassWordImg.frame = CGRectMake(48,  _theNewPassWordTextField.frame.origin.y +_theNewPassWordTextField.frame.size.height + 55, 20/2, 32/2);
        _againPassWordImg.image = [UIImage imageNamed:@"登录密码icon"];
    }
    
    return _againPassWordImg;
}

- (UITextField *)againPassWordTextField {
    
    if (!_againPassWordTextField) {
        _againPassWordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(74, _theNewPassWordTextField.frame.origin.y +_theNewPassWordTextField.frame.size.height + 55, DMDeviceWidth - 74 - 48 - 34, 20) PlaceHoldFont:12 PlaceHoldColor:WITHEBACK_DEFAULT];
        _againPassWordTextField.placeholder = @"再次输入交易密码";
        _againPassWordTextField.secureTextEntry = false;
        [_againPassWordTextField setValue:WITHEBACK_DEFAULT forKeyPath:@"_placeholderLabel.textColor"];
        _againPassWordTextField.textColor = WITHEBACK_INPUT;
        _againPassWordTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_againPassWordTextField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        _againPassWordTextField.font = [UIFont systemFontOfSize:14];
        [_againPassWordTextField addTarget:self action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];

    }
    
    
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(74, _againPassWordTextField.frame.origin.y +_againPassWordTextField.frame.size.height + 7, DMDeviceWidth - 48 - 74, 1);
    line.backgroundColor = WITHEBACK_LINE;
    [self.view addSubview:line];
    
    
    return _againPassWordTextField;
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    
    

        
    if (textField == self.theNewPassWordTextField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            ShowMessage(@"交易密码只能是六位");
        }
            
    } else if (textField == _againPassWordTextField) {
            
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            ShowMessage(@"交易密码只能是六位");
        }
            
    }

    
    
    if (self.theNewPassWordTextField.text.length > 0 && self.againPassWordTextField.text.length >0) {
        
        [_finishBtn setImage:[UIImage imageNamed:@"新完--成-填写正确"] forState:UIControlStateNormal];
        [_finishBtn setImage:[UIImage imageNamed:@"新完--成-填写正确"] forState:UIControlStateHighlighted];
        
        
    } else {
        
        [_finishBtn setImage:[UIImage imageNamed:@"新完--成-默认"] forState:UIControlStateNormal];
        [_finishBtn setImage:[UIImage imageNamed:@"新完--成-默认"] forState:UIControlStateHighlighted];
        
    }
}


- (UIButton *)finishBtn {
    
    if (!_finishBtn) {
        
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake((DMDeviceWidth - 300)/2, _againPassWordTextField.frame.origin.y +_againPassWordTextField.frame.size.height + 7 + 80, 300, 40);
        [_finishBtn setImage:[UIImage imageNamed:@"新完--成-默认"] forState:UIControlStateNormal];
        [_finishBtn setImage:[UIImage imageNamed:@"新完--成-默认"] forState:UIControlStateHighlighted];
        [_finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _finishBtn;
    
}

- (void)finishAction {
    
    if (_theNewPassWordTextField.text.length < 6) {
        ShowMessage(@"交易只能是6位数字");
    } else if (![_theNewPassWordTextField.text isEqualToString:_againPassWordTextField.text]){
        ShowMessage(@"两次输入不相同，请重新输入");
    } else {
        
        if (_sure == YES) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *userPassWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassWord"];
            [[LJQMineRequestManager RequestManager]LJQSetTradePassWordLoginPd:userPassWord tradePd:_theNewPassWordTextField.text successBlock:^(NSInteger result,NSString *str) {
                if (result == 1) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self performSelector:@selector(backToEarly) withObject:nil afterDelay:1];                    
                } else {
                    
                    ShowMessage(str);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            } faild:^(NSString *message) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        } else {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
            [manager LJQResetPayMentPassWord:_theNewPassWordTextField.text smsCaptcha:self.code successBlock:^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self performSelector:@selector(backToEarly1) withObject:nil afterDelay:1];
                
            } faild:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ShowMessage(@"修改失败");
            }];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            LJQMineRequestManager *manager1 = [LJQMineRequestManager RequestManager];
            [manager1 LJQResetPayMentPassWord:_theNewPassWordTextField.text smsCaptcha:self.code successBlock:^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ShowMessage(@"修改成功");
                [self performSelector:@selector(backToEarly1) withObject:nil afterDelay:1];
                
            } faild:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ShowMessage(@"修改失败");
            }];
        }
    }
    
}

- (void)backToEarly1 {
    
    __weak typeof (self)weakself = self;
    
    ShowMessage(@"修改成功");
    
    NSArray *temArray = weakself.navigationController.viewControllers;
    for(UIViewController *temVC in temArray){
        if ([temVC isKindOfClass:[LJQSetPassWordVC class]]){
            [weakself.navigationController popToViewController:temVC animated:YES];

        }
        
    }

}

- (void)backToEarly {
    
    ShowMessage(@"设置成功");
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//重置交易密码
- (void)resetPayPassWord:(NSString *)PayPassWord smsCaptcha:(NSString *)smsCaptcha {
    
   

}

@end
