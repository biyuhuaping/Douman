
//
//  DMReplaceViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMReplaceViewController.h"
#import "DMSettransactionpasswordViewController.h"
#import "DMLoginViewController.h"
#import "DMLoginRequestManager.h"
#import "DMMineViewController.h"

@interface DMReplaceViewController ()<UITextFieldDelegate>


@property (nonatomic, strong) UIImageView *theNewPassWordImg;
@property (nonatomic, strong) UIImageView *againPassWordImg;

@property (nonatomic, strong) UITextField *theNewPassWordTextField;
@property (nonatomic, strong) UITextField *againPassWordTextField;


@property (nonatomic, strong) UIButton *finishBtn;


@end

@implementation DMReplaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"重置密码";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];

//    [self.view addSubview:self.CreateTheNewPassWordImg];
    [self.view addSubview:self.CreateTheNewPassWordTextField];
//    [self.view addSubview:self.CreateAgainPassWordImg];
    [self.view addSubview:self.CreateAgainPassWordTextField];
    [self.view addSubview:self.CreateFinishBtn];
    
}



-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_theNewPassWordTextField resignFirstResponder];
    [_againPassWordTextField resignFirstResponder];
    
    
}



- (UIImageView *)CreateTheNewPassWordImg {
    
    if (!_theNewPassWordImg) {
        _theNewPassWordImg = [[UIImageView alloc] init];
        _theNewPassWordImg.frame = CGRectMake(48, 48, 10, 16);
        _theNewPassWordImg.image = [UIImage imageNamed:@"登录密码icon"];
    }
    
    return _theNewPassWordImg;
}


- (UITextField *)CreateTheNewPassWordTextField {
    
    if (!_theNewPassWordTextField) {
        _theNewPassWordTextField = [[UITextField alloc] init];
        _theNewPassWordTextField.frame = CGRectMake(45,  48, DMDeviceWidth - 85, 14);
        _theNewPassWordTextField.placeholder = @"请输入6~10位数字、英文组合密码";
        [_theNewPassWordTextField setValue:LightGray forKeyPath:@"_placeholderLabel.textColor"];//////////4b6ca7
        [_theNewPassWordTextField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        _theNewPassWordTextField.font = [UIFont systemFontOfSize:14];
        _theNewPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _theNewPassWordTextField.delegate = self;
        _theNewPassWordTextField.textColor = DarkGray; //////////////0x86a7e8)
        
        UIButton *clearButton = [_theNewPassWordTextField valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateNormal]; ////////////清除icon
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateHighlighted];
    }
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(35, _theNewPassWordTextField.frame.origin.y+_theNewPassWordTextField.frame.size.height + 7, DMDeviceWidth - 70, 0.7);
    line.backgroundColor = UIColorFromRGB(0xececec); ////////////23395f
    [self.view addSubview:line];
    
    return _theNewPassWordTextField;
    
}


- (UIImageView *)CreateAgainPassWordImg {
    
    if (!_againPassWordImg) {
        _againPassWordImg = [[UIImageView alloc] init];
        _againPassWordImg.frame = CGRectMake(48,  _theNewPassWordTextField.frame.origin.y +_theNewPassWordTextField.frame.size.height + 55, 20/2, 32/2);
        _againPassWordImg.image = [UIImage imageNamed:@"登录密码icon"];
    }
    
    return _againPassWordImg;
}

- (UITextField *)CreateAgainPassWordTextField {
    
    if (!_againPassWordTextField) {
        _againPassWordTextField = [[UITextField alloc] init];
        _againPassWordTextField.frame = CGRectMake(45, _theNewPassWordTextField.frame.origin.y +_theNewPassWordTextField.frame.size.height + 55, DMDeviceWidth - 85 , 14);
        _againPassWordTextField.placeholder = @"再次输入密码";
        _againPassWordTextField.secureTextEntry = false;
        _againPassWordTextField.textColor = DarkGray; /////////////86a7e8
        [_againPassWordTextField setValue:LightGray forKeyPath:@"_placeholderLabel.textColor"]; /////////4b6ca7
        [_againPassWordTextField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        _againPassWordTextField.font = [UIFont systemFontOfSize:14];
        _againPassWordTextField.delegate = self;
        _againPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIButton *clearButton = [_againPassWordTextField valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateNormal]; //////////////清除icon
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateHighlighted];
    }
    
    
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(35, _againPassWordTextField.frame.origin.y +_againPassWordTextField.frame.size.height + 7, DMDeviceWidth - 70, 0.7);
    line.backgroundColor = UIColorFromRGB(0xececec); ///////////23395f
    [self.view addSubview:line];
    
    
    return _againPassWordTextField;
    
}

- (UIButton *)CreateFinishBtn {
    
    if (!_finishBtn) {
        
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake((DMDeviceWidth - 300)/2, _againPassWordTextField.frame.origin.y +_againPassWordTextField.frame.size.height + 7 + 80, 300, 40);
        [_finishBtn setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal]; ///////////完--成
        [_finishBtn setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateHighlighted];
        [_finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _finishBtn;
    
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
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 10) {
            ShowMessage(@"密码不能超过10位");
            return NO;//限制长度
        }
        return YES;
}
- (void)finishAction {
    
    if (_theNewPassWordTextField.text.length ==0) {
        ShowMessage(@"密码不能为空");
    } else if (_theNewPassWordTextField.text.length < 6 || _againPassWordTextField.text.length < 6) {
        ShowMessage(@"输入密码不能小于6位");
    }  else if (![_againPassWordTextField.text isEqualToString:_theNewPassWordTextField.text]){
        ShowMessage(@"两次输入的不相同，请重新输入");
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DMLoginRequestManager manager] resetPassWordWithPhoneNumber:_PhoneNum Captcha:_captcha NewPsd:_theNewPassWordTextField.text Success:^() {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ShowMessage(@"密码重置成功");
            [self performSelector:@selector(backToEarly) withObject:nil afterDelay:1];
        } Faild:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ShowMessage(@"请求失败");
        }];
    }
}

- (void)backToEarly {
    
    __weak typeof (self)weakself = self;
    if (self.mine) {
        NSArray *temArray = weakself.navigationController.viewControllers;
        for(UIViewController *temVC in temArray){
            if ([temVC isKindOfClass:[DMMineViewController class]]){
                [weakself.navigationController popToViewController:temVC animated:YES];
            }
        }
    } else {
        NSArray *temArray = weakself.navigationController.viewControllers;
        for(UIViewController *temVC in temArray){
            if ([temVC isKindOfClass:[DMLoginViewController class]]){
                [weakself.navigationController popToViewController:temVC animated:YES];
            }
            
        }
    }

}

@end
