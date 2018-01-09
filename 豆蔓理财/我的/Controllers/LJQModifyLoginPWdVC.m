//
//  LJQModifyLoginPWdVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQModifyLoginPWdVC.h"
#import "LJQTextFieldAndImage.h"
@interface LJQModifyLoginPWdVC ()<UITextFieldDelegate>

@property (nonatomic, strong)LJQTextFieldAndImage *OneTextField;
@property (nonatomic, strong)LJQTextFieldAndImage *TwoTextField;
@property (nonatomic, strong)LJQTextFieldAndImage *ThreeTextField;

@property (nonatomic, strong)UILabel *promptLabel;
@property (nonatomic, strong)UILabel *TwoPromptLabel;
@property (nonatomic, strong)UIButton *Finish;

@end

@implementation LJQModifyLoginPWdVC
@synthesize Finish;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改登录密码";
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *pitcure = [UIImage imageNamed:@"登录密码icon"];
    
    
    self.OneTextField = [[LJQTextFieldAndImage alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 20) imageName:@"" space:20 Height:20 string:@"请输入原登录密码"];
    self.OneTextField.keyMode = TextFieldModeLogin;
    self.OneTextField.comStrBK = ^(UITextField *textField) {
        
    };
    
    self.TwoTextField = [[LJQTextFieldAndImage alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_MaxY(self.OneTextField) + 30, SCREENWIDTH, 20) imageName:@"" space:20 Height:20 string:@"新密码为:6-10位大小写英文及数字组合密码"];
    self.TwoTextField.textField.delegate = self;
    self.TwoTextField.textField.secureTextEntry = YES;
    self.TwoTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.TwoTextField.keyMode = TextFieldModeLogin;
    [self.TwoTextField.textField addTarget:self action:@selector(editEnd:) forControlEvents:(UIControlEventEditingDidEnd)];
    __weak LJQModifyLoginPWdVC *weakSelf = self;
    self.TwoTextField.comStrBK = ^(UITextField *textField) {
      //  NSInteger index = [weakSelf checkIsHaveNumAndLetter:textField.text];
        BOOL index = [weakSelf checkValidityOfPasswordWithPasswordStr:textField.text];
        if (index == YES) {
            weakSelf.TwoPromptLabel.hidden = YES;
        }else {
            weakSelf.TwoPromptLabel.hidden = NO;
        }
        
            };
    
    self.ThreeTextField = [[LJQTextFieldAndImage alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_MaxY(self.TwoTextField) + 30, SCREENWIDTH, 20) imageName:@"" space:20 Height:20 string:@"请再次输入新登录密码"];
    self.ThreeTextField.textField.delegate = self;
    self.ThreeTextField.textField.secureTextEntry = YES;
    self.ThreeTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ThreeTextField.keyMode = TextFieldModeLogin;
    
   // [self.ThreeTextField.textField addTarget:self action:@selector(ThreeEditEnd:) forControlEvents:(UIControlEventEditingDidEnd)];
    
    self.ThreeTextField.comStrBK = ^(UITextField *textField) {
        NSLog(@"%@",textField.text);
        NSString *string = weakSelf.TwoTextField.textField.text;
        if (textField.text.length == 0) {
            weakSelf.promptLabel.hidden = YES;
        }else if (textField.text.length > string.length){
            weakSelf.promptLabel.hidden = NO;
        }
        else {
            string = [string substringToIndex:textField.text.length];
            if ([string isEqualToString:textField.text]) {
                weakSelf.promptLabel.hidden = YES;
            }else{
                weakSelf.promptLabel.hidden = NO;
            }
            
//            if ([weakSelf.TwoTextField.textField.text isEqualToString:textField.text]) {
//                if (self.OneTextField.textField.text.length != 0) {
//                    UIImage *image = [UIImage imageNamed:@"complete"]; //////////////完--成
//                    [Finish setBackgroundImage:image forState:(UIControlStateNormal)];
//                    [Finish setBackgroundImage:image forState:UIControlStateHighlighted];
//                }else {
//                    UIImage *image = [UIImage imageNamed:@"完成"];
//                    [Finish setBackgroundImage:image forState:(UIControlStateNormal)];
//                    [Finish setBackgroundImage:image forState:UIControlStateHighlighted];
//                }
//
//            }else {
//                UIImage *image = [UIImage imageNamed:@"完成"];
//                [Finish setBackgroundImage:image forState:(UIControlStateNormal)];
//                [Finish setBackgroundImage:image forState:UIControlStateHighlighted];
//            }
        }
    };
    
    self.TwoPromptLabel = [UILabel createLabelFrame:CGRectMake(pitcure.size.width + 30, LJQ_VIEW_MaxY(self.TwoTextField) + 10, SCREENWIDTH - pitcure.size.width - 30, 11) labelColor:UIColorFromRGB(0xffd542) textAlignment:(NSTextAlignmentLeft) textFont:10.f];
    self.TwoPromptLabel.text = @"请输入6-10位大小写英文及数字组合密码";
    self.TwoPromptLabel.hidden = YES;
    [self.view addSubview:self.TwoPromptLabel];

    
    self.promptLabel = [UILabel createLabelFrame:CGRectMake(pitcure.size.width + 30, LJQ_VIEW_MaxY(self.ThreeTextField) + 10, SCREENWIDTH - pitcure.size.width - 30, 11) labelColor:UIColorFromRGB(0xffd542) textAlignment:(NSTextAlignmentLeft) textFont:10.f];
    self.promptLabel.text = @"两次输入的密码不同，请重新输入";
    self.promptLabel.hidden = YES;
    [self.view addSubview:self.promptLabel];
    
    [self.view addSubview:self.OneTextField];
    [self.view addSubview:self.TwoTextField];
    [self.view addSubview:self.ThreeTextField];
    
    UIImage *imageP = [UIImage imageNamed:@"complete"]; //////////////完成
    Finish = [UIButton buttonWithType:(UIButtonTypeCustom)];
    Finish.frame = CGRectMake((SCREENWIDTH - 197) / 2, LJQ_VIEW_MaxY(self.promptLabel) + 30, 197, 37);
    [Finish setBackgroundImage:imageP forState:(UIControlStateNormal)];
    [Finish setBackgroundImage:imageP forState:(UIControlStateHighlighted)];
    [Finish addTarget: self action:@selector(FinishEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:Finish];
    
    
}

- (void)editEnd:(UITextField *)textField {
//  NSInteger index = [self checkIsHaveNumAndLetter:textField.text];
    BOOL index = [self checkValidityOfPasswordWithPasswordStr:textField.text];
    if (textField.text.length < 6) {
        self.TwoPromptLabel.hidden = NO;
        
        if (textField.text.length == 0) {
            self.TwoPromptLabel.hidden = YES;
        }
    }else {
        if (index == YES) {
            self.TwoPromptLabel.hidden = YES;
        }else {
            self.TwoPromptLabel.hidden = NO;
        }

    }
}


- (void)ThreeEditEnd:(UITextField *)textField {
    if (self.OneTextField.textField.text.length != 0 && self.TwoTextField.textField.text.length != 0 && self.ThreeTextField.textField.text.length != 0) {
        UIImage *image = [UIImage imageNamed:@"complete"]; //////////完--成
        [Finish setBackgroundImage:image forState:(UIControlStateNormal)];
        [Finish setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}


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

//判断字符串的类型
-(NSInteger)checkIsHaveNumAndLetter:(NSString*)password{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
    
}

- (void)FinishEvent:(UIButton *)sender {
    if (self.OneTextField.textField.text.length != 0 && [self.TwoTextField.textField.text isEqualToString:self.ThreeTextField.textField.text] && self.TwoTextField.textField.text.length != 0) {
        if ([self checkValidityOfPasswordWithPasswordStr:self.TwoTextField.textField.text]) {
            [self modifyLoginPassWordOldPd:self.OneTextField.textField.text newPd:self.ThreeTextField.textField.text];
        }else {
            ShowMessage(@"请输入6-10位大小写英文及数字组合密码");
        }
    }else {
        ShowMessage(@"输入不能为空");
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)modifyLoginPassWordOldPd:(NSString *)oldPd newPd:(NSString *)newPd {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQModifyLoginPassWord:oldPd newPassWord:newPd successBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowMessage(@"修改成功");
        //将修改的登录密码保存
        [[NSUserDefaults standardUserDefaults] setObject:newPd forKey:@"userPassWord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(backToEarly) withObject:nil afterDelay:1];
    } faild:^(NSString *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowMessage(result);
    }];
}

- (void)backToEarly {
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.TwoTextField.textField || textField == self.ThreeTextField.textField) {
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
    
    return YES;
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
