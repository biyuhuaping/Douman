//
//  LJQTradePassWordVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQTradePassWordVC.h"
#import "LJQTextFieldAndImage.h"

@interface LJQTradePassWordVC ()

@property (nonatomic, strong)LJQTextFieldAndImage *OneTextField;
@property (nonatomic, strong)LJQTextFieldAndImage *TwoTextField;
@property (nonatomic, strong)LJQTextFieldAndImage *ThreeTextField;

@property (nonatomic, strong)UILabel *promptLabel;
@property (nonatomic, strong)UIButton *Finish;

@end

@implementation LJQTradePassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];

     self.title = @"设置交易密码";
    // 设置交易密码
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *pitcure = [UIImage imageNamed:@"登录密码icon"];

    
    self.OneTextField = [[LJQTextFieldAndImage alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 20) imageName:@"登录密码icon" space:20 Height:20 string:@"请输入登录密码"];
    self.OneTextField.keyMode = TextFieldModeLogin;
    self.OneTextField.comStrBK = ^(UITextField *textField) {
        
    };
    
    self.TwoTextField = [[LJQTextFieldAndImage alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_MaxY(self.OneTextField) + 30, SCREENWIDTH, 20) imageName:@"交易密码icon" space:20 Height:20 string:@"请输入6位数字交易密码"];
    self.TwoTextField.keyMode = TextFieldModeTrade;
    
  //  [self.ThreeTextField.textField addTarget:self action:@selector(TradeThreeEditEnd:) forControlEvents:(UIControlEventEditingDidEnd)];
    
    self.TwoTextField.comStrBK = ^(UITextField *textField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    };
    
    self.ThreeTextField = [[LJQTextFieldAndImage alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_MaxY(self.TwoTextField) + 30, SCREENWIDTH, 20) imageName:@"交易密码icon" space:20 Height:20 string:@"请再次输入6位数字交易密码"];
    self.ThreeTextField.keyMode = TextFieldModeTrade;
    __weak LJQTradePassWordVC *weakSelf = self;
    self.ThreeTextField.comStrBK = ^(UITextField *textField) {
        NSLog(@"%@",textField.text);
        
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        
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
            
            if ([weakSelf.TwoTextField.textField.text isEqualToString:textField.text]) {
                if (self.OneTextField.textField.text.length != 0) {
                    UIImage *image = [UIImage imageNamed:@"完--成"];
                    [weakSelf.Finish setBackgroundImage:image forState:(UIControlStateNormal)];
                    [weakSelf.Finish setBackgroundImage:image forState:UIControlStateHighlighted];
                }
                
            }

        }
    };
 
    
    self.promptLabel = [UILabel createLabelFrame:CGRectMake(pitcure.size.width + 30, LJQ_VIEW_MaxY(self.ThreeTextField) + 10, SCREENWIDTH - pitcure.size.width - 30, 11) labelColor:UIColorFromRGB(0xffd542) textAlignment:(NSTextAlignmentLeft) textFont:10.f];
    self.promptLabel.text = @"两次输入的密码不同，请重新输入";
    self.promptLabel.hidden = YES;
    [self.view addSubview:self.promptLabel];
    
    [self.view addSubview:self.OneTextField];
    [self.view addSubview:self.TwoTextField];
    [self.view addSubview:self.ThreeTextField];
    
    UIImage *imageP = [UIImage imageNamed:@"完成"];
    _Finish = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _Finish.frame = CGRectMake((SCREENWIDTH - imageP.size.width) / 2, LJQ_VIEW_MaxY(self.promptLabel) + 30, imageP.size.width, imageP.size.height);
    [_Finish setBackgroundImage:imageP forState:(UIControlStateNormal)];
    [_Finish setBackgroundImage:imageP forState:(UIControlStateHighlighted)];
    [_Finish addTarget: self action:@selector(FinishEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_Finish];

    
}

- (void)FinishEvent:(UIButton *)sender {
    if (self.OneTextField.textField.text.length != 0 && [self.TwoTextField.textField.text isEqualToString:self.ThreeTextField.textField.text] && self.TwoTextField.textField.text.length != 0) {
        [self setTradePassWordResultLoginPd:self.OneTextField.textField.text tradePd:self.ThreeTextField.textField.text];
    }else {
        ShowMessage(@"输入不能为空");
    }
}


- (void)TradeThreeEditEnd:(UITextField *)textField {
    if (self.OneTextField.textField.text.length != 0 && self.TwoTextField.textField.text.length != 0 && self.ThreeTextField.textField.text.length != 0) {
        UIImage *image = [UIImage imageNamed:@"完--成"];
        [_Finish setBackgroundImage:image forState:(UIControlStateNormal)];
        [_Finish setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//设置交易密码
- (void)setTradePassWordResultLoginPd:(NSString *)loginPd tradePd:(NSString *)tradePd {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager LJQSetTradePassWordLoginPd:loginPd tradePd:tradePd successBlock:^(NSInteger result,NSString *str) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowMessage(@"设置成功");
        [self performSelector:@selector(backToEarly) withObject:nil afterDelay:1];
    } faild:^(NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowMessage(message);
    }];
}

- (void)backToEarly {
    [self.navigationController popViewControllerAnimated:YES];
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
